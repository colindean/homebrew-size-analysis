# Ideas and notes

## Reducing load on GHCR.io and ISP DNS servers

Setup HAProxy as a reverse proxy that can keep connections alive versus curl opening a new connection every time?

https://www.haproxy.com/blog/http-keep-alive-pipelining-multiplexing-and-connection-pooling/

## Reducing request count

```sh
curl --header "Accept: application/vnd.oci.image.index.v1+json" --header "Authorization: Bearer QQ==" https://ghcr.io/v2/homebrew/core/a2ps/manifests/4.15.3 | jq .
```

Each manifest/object has an `annotations` object that could gain a size somehow.

```json5
# ...
{
  "annotations": {
    "org.opencontainers.image.ref.name": "4.15.3.ventura",
    "sh.brew.bottle.digest": "63d06cf7e978d2683f8edb8f3a064b911c6a092127eae6065bbaf1a3977f5fdf",
    "sh.brew.tab": "{\"homebrew_version\":\"4.0.9-102-g140d444\",\"changed_files\":[\"bin/ogonkify\",\".bottle/etc/a2ps.cfg\"],\"source_modified_time\":1679862747,\"compiler\":\"clang\",\"runtime_dependencies\":[{\"full_name\":\"bdw-gc\",\"version\":\"8.2.2\",\"declared_directly\":true},{\"full_name\":\"libpaper\",\"version\":\"2.0.10\",\"declared_directly\":true}],\"arch\":\"x86_64\",\"built_on\":{\"os\":\"Macintosh\",\"os_version\":\"macOS 13\",\"cpu_family\":\"penryn\",\"xcode\":\"14.2\",\"clt\":\"14.2.0.0.1.1668646533\",\"preferred_perl\":\"5.30\"}}"
  }
}
```

This could reduce the number of requests from 1 per package-version-arch to 1 per package-version, 7 -> 1, reducing to 15% of the requests.
That could reduce the retrieval time to something that reindexing is trivial.
