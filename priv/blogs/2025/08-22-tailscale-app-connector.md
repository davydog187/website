# /blogs/2025/08-22-app-connector.md
%{
    title: "Private services across clouds with Tailscale App Connector",
    author: "Dave Lucia",
    tags: ~w(tailscale fly),
    description: "Connect services running in different services using Tailscale"
}
---

Ever need to write a website that you want to expose internally without exposing it to the internet at all?

How about a service running in Fly.io that you want to access from AWS while avoiding internet exposure?

If you run a small team like I do, you might not have the resources to set up secure bridges between VPCs in different clouds, the technical capabilities to do so, or the budget to build one.


Lucky for you, I'm going to show you how [Tailscale App Connector](https://tailscale.com/kb/1281/app-connectors) makes this possible and how you can do this yourself.

### What is Tailscale?

For the uninitiated, [Tailscale](https://tailscale.com/) is a VPN solution built on top of [Wireguard](https://www.wireguard.com/) that makes connecting devices on different networks a breeze. Simply spin up the [Tailscale agent](https://tailscale.com/download) on a machine and your desktop, configure your policy to allow traffic between them, and boom—you can now access that device from anywhere. Don't believe me? Give their [quickstart guide](https://tailscale.com/kb/1017/install) a try.

I've used Tailscale for a million things, but to name a few:

1. Access remote machines from anywhere
2. [Serve a local http service and expose it to the internet](https://tailscale.com/kb/1223/funnel) (like [ngrok](https://ngrok.com/))
3. Expose a machine as an [Exit Node](https://tailscale.com/kb/1408/quick-guide-exit-nodes?q=exit%20node) so I can access geographic-specific services
4. Use a [subnet router](https://tailscale.com/kb/1019/subnets?q=subnet) to use a "dumb printer" from anywhere

These are just a few off the top of my head, but Tailscale opens so many interesting possibilities that I never would have considered prior.


### What is a Tailscale App Connector?

An App Connector is conceptually three things:

1. It acts as a DNS server
2. It acts as a router for IP packets
3. It acts as a conduit for Access Control

App Connectors allow you to advertise a network's internal DNS to machines and users on your [Tailnet](https://tailscale.com/kb/1136/tailnet) as if they were on that network.

For example, here are a few interesting things you can do:

1. Have an internal-only HR website
2. Expose a logging service to edge nodes running on a VPS
3. Bridge two clouds so their services can talk to each other over a secure connection

There are many ways to achieve the above, but with Tailscale, you can make this possible over a secure Wireguard connection with ACL rules that allow you to limit access at both machine and user levels.


### Let's build an App Connector

In this example, let's deploy a service running on Fly.io and access it through the App Connector. We will not expose this service to the internet, so only users on your Tailnet who have permissions to access this service will be able to do so.

First, you'll need to deploy a container to Fly that runs the Tailscale agent and is configured to be an App Connector. It must meet the following criteria:

1. A public IP address
2. IP forwarding enabled


```dockerfile
FROM alpine:latest

# Install utilities for Tailscale
RUN apk update && apk add ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*

# Copy Tailscale binaries from the tailscale image on Docker Hub.
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# Copy startup script
COPY start-connector.sh /app/start-connector.sh
RUN chmod +x /app/start-connector.sh

CMD ["/app/start-connector.sh"]
```

You'll then start the app connector like this:

```bash
#!/bin/sh

set -e

# Enable IP forwarding for both IPv4 and IPv6 (required for subnet routing)
echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' >> /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf

# Start Tailscale daemon
/app/tailscaled --state=mem: --socket=/var/run/tailscale/tailscaled.sock &

if [ -z "$TS_AUTHKEY" ]; then
  echo "ERROR: TS_AUTHKEY environment variable not set"
  exit 1
fi

# This is your Fly.io network prefix
# fdaa is Fly's Unique Local Address prefix
# 1:ffff you would replace with your network prefix
# Which you can find by looking at your fly machine's IPv6 address
NETWORK_PREFIX=fdaa:1:ffff::/48

# Connect to Tailscale network with app connector enabled
/app/tailscale up \
  --auth-key=${TS_AUTHKEY} \
  --advertise-connector \
  --advertise-routes=${NETWORK_PREFIX} \
  --advertise-tags=tag:my-fly-connector \
  --hostname=${TS_HOSTNAME} \
  --accept-routes

# Keep the container running
sleep infinity
```

Finally, you'll spin up your app with a fly.toml that looks like this:


```toml
app = 'my-fly-connector'
primary_region = 'ewr'

[env]
  TS_HOSTNAME = 'my-fly-connector'

[[vm]]
  cpu_kind = 'shared'
  cpus = 1
  memory_mb = 256
```

Now `fly deploy` your app connector, and let's update your Tailscale policy file.


First, create a new tag for your app connector in `tagOwners`:

```json

  // Define the tags which can be applied to devices and by which users.
  "tagOwners": {
    "tag:my-fly-connector": ["autogroup:admin"]
  },
```

Then we need to auto-approve routes advertised by the App Connector:

```json
  "autoApprovers": {
    "routes": {
      // Allow traffic to fly.io 6PN network through the my-fly-connector
      "fdaa:1:ffff::/48": ["tag:my-fly-connector"]
    }
  },
```

Then we're going to grant access to users and machines we want to be able to access services exposed by the app connector:

```json
  "grants": [
    // Allow access to internal Fly.io services through app connector
    {
      "src": ["group:employees", "tag:my-service", "tag:something-else"],
      "dst": ["fdaa:1:ffff::/48"],
      "via": ["tag:my-fly-connector"],
      "ip": ["*"]
    }
  ],
```

Finally, we need to expose the service DNS that we want the app connector to advertise:


```

  "nodeAttrs": [
    {
      "target": ["*"],
      "app": {
        "tailscale.com/app-connectors": [
          {
            "name": "my-fly-connector",
            "connectors": ["tag:my-fly-connector"],
            "domains": [
              "logging-service.internal",
              "hr-website.internal",
              "business-intelligence.internal"
            ]
          }
        ]
      }
    }
  ],
```


### Summary

If you've followed these instructions carefully, you can type `http://my-service.internal` into your browser and access a private service running in Fly.io through a Tailscale app connector!

For any machine running Tailscale that you wish to access services exposed through the App Connector, it's important that you run `tailscale set --accept-routes` for an already running Tailscale agent, or `tailscale up --accept-routes` when starting a new one.

There was a lot of configuration involved in this process, and while it's tricky, it's certainly possible to use App Connectors to solve many problems!

That said, I've spoken to the fine folks over at Tailscale, and they previewed some upcoming changes to their product that will make this much easier and provide additional features for setting up HTTPS certificates and other goodies.

If you have any questions or get stuck, feel free to reach out. Thanks!
