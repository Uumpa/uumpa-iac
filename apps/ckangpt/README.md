# ckangpt

## Deploy

Create secret `chroma-auth`

```
htpasswd -c auth <USERNAME>
kubectl -n ckangpt create secret generic basic-auth --from-file=auth
rm auth
```
