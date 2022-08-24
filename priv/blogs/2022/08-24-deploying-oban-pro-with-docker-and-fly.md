%{
    title: "Deploying Oban Pro/Web with Docker and Fly.io",
    author: "Dave Lucia",
    tags: ~w(elixir),
    description: "How to deploy an Elixir app with Oban Pro to Fly.io using Docker"
}
---
[Oban](https://hexdocs.pm/oban/Oban.html) is a "robust job processing library which uses PostgreSQL for storage and coordination" for [Elixir](https://elixir-lang.org/). Like any other [hex](https://hex.pm/) dependency, you can install it through your `mix.exs` file, run `mix deps.get`, and boom, you're done.

## Oban Pro
Things get a little bit more complicated with the paid versions of Oban, [Oban Pro](https://getoban.pro/docs/pro/overview.html) and [Oban Web](https://getoban.pro/docs/web/overview.html), as you need to authenticate using a license key. Locally, you can install it right through the command line.

```shell
$ mix hex.repo add oban https://getoban.pro/repo \
  --fetch-public-key <OBAN_FINGER_PRINT>
  --auth-key <YOUR_API_KEY>
```

However, when deploying to the cloud using Docker, things get a bit more complicated. Passing your API key when building a Docker image should be done securely, and takes a little know-how.

### Deploy a Docker image with Oban Pro, using GitHub Actions and Fly.io

I deploy my service using [Fly.io](https://fly.io/), which provides a command-line tool called `flyctl`. Our challenge is to securely pass our API to `flyctl` when building our docker image using [Docker build secrets](https://docs.docker.com/develop/develop-images/build_enhancements/#new-docker-build-secret-information) and the `flyctl deploy` [--build-secret](https://fly.io/docs/reference/build-secrets/) option.

## Setting up your Dockerfile

Setting up your Dockerfile is the easy part, you can just follow the [Oban documentation](https://getoban.pro/docs/pro/docker.html). Simply add the following to your Dockerfile

```Dockerfile
# In your Dockerfile
RUN --mount=type=secret,id=OBAN_KEY_FINGERPRINT \
    --mount=type=secret,id=OBAN_LICENSE_KEY \
    mix hex.repo add oban https://getoban.pro/repo \
      --fetch-public-key "$(cat /run/secrets/OBAN_KEY_FINGERPRINT)" \
      --auth-key "$(cat /run/secrets/OBAN_LICENSE_KEY)"
```

## Passing the deploy secrets to `flyctl` in GitHub Actions

The tricky part for me was to correctly get my secrets from GitHub actions into my Dockerfile securely. Luckily, there is a new `--built-secret` option to `flyctl deploy` that solves this problem for us.

First, add the secrets to your [GitHub Actions](https://docs.github.com/en/rest/actions/secrets). If you're adding them following this example, you should name them `OBAN_KEY_FINGERPRINT` and `OBAN_LICENSE_KEY`.

Then you just pass them as build secrets in your GitHub Action like so.

```yaml
jobs:
  deploy:
    name: Deploy app
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: superfly/flyctl-actions/setup-flyctl@master
      - run: |
        flyctl deploy --remote-only \
          --build-secret OBAN_LICENSE_KEY=${{ secrets.OBAN_LICENSE_KEY }} \
          --build-secret OBAN_KEY_FINGERPRINT=${{ secrets.OBAN_KEY_FINGERPRINT }}
```


And boom! You're cooking with Oban Pro.
