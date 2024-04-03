# strava-api-playground

## Setting up tokens and stuff

https://developers.strava.com/docs/getting-started/


http://www.strava.com/oauth/authorize?client_id=99749542&response_type=code&redirect_uri=http://localhost/exchange_token&approval_prompt=force&scope=read


Get client ID

```
client_id=$(cat client_id)
```

Pass it into

```
http://www.strava.com/oauth/authorize?client_id=[REPLACE_WITH_YOUR_CLIENT_ID]&response_type=code&redirect_uri=http://localhost/exchange_token&approval_prompt=force&scope=read_all,profile:read_all,activity:read_all
```

Paste into browser, go, and click `Authorize`.

It will say `Unable to connect` or something. Copy the resulting URL and pull out the value for the `code` parameter.

```
http://localhost/exchange_token?state=&code=[AUTHORIZATION_CODE]&scope=read,activity:read_all,profile:read_all,read_all
c5fd4006c632a1268d39a6a7453adbeb19980276
```

Make a curl request with authorization code.

```
curl -X POST https://www.strava.com/oauth/token \
	-F client_id=118860 \
	-F client_secret=$(cat client_secret) \
	-F code=c5fd4006c632a1268d39a6a7453adbeb19980276 \
	-F grant_type=$(cat authorization_code)
```

```json
{
  "token_type": "Bearer",
  "expires_at": 1709015195,
  "expires_in": 21600,
  "refresh_token": "REDACTED",
  "access_token": "REDACTED",
  "athlete": {
    ...
  }
}
```

### Refresh Token

```bash
curl -X POST https://www.strava.com/api/v3/oauth/token \
  -d client_id=$(cat client_id) \
  -d client_secret=$(cat client_secret) \
  -d grant_type=refresh_token \
  -d refresh_token=REFRESH_TOKEN
```

## Test Server

```bash
python3 -m http.server
```
