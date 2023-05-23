# External Phoenix LiveView uploads to CloudFlare R2
%{
    title: "External LiveView uploads to CloudFlare R2",
    author: "Dave Lucia",
    tags: ~w(elixir liveview cloudflare),
    description: "Browser direct to CloudFlare R2 uploads using Phoenix LiveView external uploads and presigned PUT requests"
}
---
## The Problem
Recently, I've been working on a new product that requires uploading large zip files. While `Phoenix LiveView` has great out of the box functionality for direct file uploads, I chose not to use this feature for several reasons.

### 1. Direct File Uploads
Direct file uploads in Phoenix work by streaming the file in memory to the filesystem. The files that we expect to handle may be hundreds of Megabytes or even Gigabytes in size. This may cause capacity or possibly memory issues for our application. We plan to run more than a single node in our cluster, so this would mean having a networked filesystem, or some other way to make files accessible to all nodes in the cluster.

### 2. Application deployments halt in-flight uploads
When uploading directly to your application, you run the risk of halting an in-progress upload during deployments. There are various ways to avoid this problem with graceful shutdown i.e. proper socket draining and reasonable shutdown timeouts. However, I'd rather prioritize speedy deployment rollouts to match our high iteration speed. Waiting for a 3gB file to finish uploading on a slow network may not be feasible.

### 3. Let the client own their data
Another consideration for us is to allow our users to own their data. Having our users grant us access to their networked filesystem isn't very practical, but giving us an AWS S3 comptible bucket is.

Given these considerations, I chose to use CloudFlare R2 as a cheap solution and accessible solution for storage. My first attempt at integration was replicating the example from the Phoenix Live View external uploads documentation. While R2 claims to be S3 compatible, they do not support the presigned POST request that the example uses.

## The Solution - do it the hard way first
The Phoenix Live View External Uploads documentation gives an example using Chris McCord's "zero dependency"
