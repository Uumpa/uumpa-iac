# ckangpt

## Deploy

Create secret `chroma-users` with a single key `chroma.xml` with the following content:

```xml
<clickhouse>
    <profiles>
      <default>
            <password>...</password>
            <allow_experimental_lightweight_delete>1</allow_experimental_lightweight_delete>
            <mutations_sync>1</mutations_sync>
        </default>
    </profiles>
</clickhouse>
```
