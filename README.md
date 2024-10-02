# strava-api-playground

## Setting up tokens and stuff

https://developers.strava.com/docs/reference/

https://developers.strava.com/docs/getting-started/


http://www.strava.com/oauth/authorize?client_id=99749542&response_type=code&redirect_uri=http://localhost/exchange_token&approval_prompt=force&scope=read


Get your client ID and secret from the [Strava API settings](https://www.strava.com/settings/api) and store it in a file named `client_id` and `client_secret`.

```
client_id=$(cat client_id)
```

Pass it into

<pre>
http://www.strava.com/oauth/authorize?client_id=[<b>REPLACE_WITH_YOUR_CLIENT_ID</b>]&response_type=code&redirect_uri=http://localhost/exchange_token&approval_prompt=force&scope=read_all,profile:read_all,activity:read_all
</pre>

Paste into browser, go, and click `Authorize`.

It will say `Unable to connect` or something. Copy the resulting URL and pull out the value for the `code` parameter.

```
grep -oP 'code=\K[^&]+' http://localhost/exchange_token?state=&code=[AUTHORIZATION_CODE]&scope=read,activity:read_all,profile:read_all,read_all
c5fd4006c632a1268d39a6a7453adbeb19980276

http://localhost/exchange_token?state=&code=d590b5c08c67ed2ce4d2f251a3595d1ff43ffa03&scope=read,activity:read_all,profile:read_all,read_all
```

Make a curl request with authorization code.

```
curl -X POST https://www.strava.com/oauth/token \
	-F client_id=$(cat client_id) \
	-F client_secret=$(cat client_secret) \
	-F code=$(cat authorization_code) \
	-F grant_type=authorization_code
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

Use the value for the key `"access_token"` to make you API calls.

### Refresh Token

If the access token expires you can get a new one using the refresh token.

```bash
curl -X POST https://www.strava.com/api/v3/oauth/token \
  -d client_id=$(cat client_id) \
  -d client_secret=$(cat client_secret) \
  -d grant_type=refresh_token \
  -d refresh_token=$(cat refresh_token)
```

## Test Server

```bash
python3 -m http.server
```

## Polyline

The API returns a polyline that you can use to draw the route. Kinda cool.

https://stackoverflow.com/questions/48017792/strava-api-how-to-get-route-image

https://developers.google.com/maps/documentation/utilities/polylinealgorithm

https://maps.googleapis.com/maps/api/staticmap?size=600x300&maptype=roadmap&path=enc:GIVE_YOUR_POLYLINE_DATA&key=GIVE_YOUR_API_KEY

a|srFdggiMZt@DTLL^NPRNB@DHA`@LVHPPXHL@XIl@@^GtAYp@IPINFTA|AQ@?|@QR@j@GFCAMFGNK`@ORMLKFMz@q@TKHQCSFDEBD?I_@AyAGYCY@YY`@@AQCGEc@Og@]Yc@_A{CCUG[KWs@c@QUQKSG[Si@QWB



https://maps.googleapis.com/maps/api/staticmap?size=600x300&maptype=roadmap&path=enc:a|srFdggiMZt@DTLL^NPRNB@DHA`@LVHPPXHL@XIl@@^GtAYp@IPINFTA|AQ@?|@QR@j@GFCAMFGNK`@ORMLKFMz@q@TKHQCSFDEBD?I_@AyAGYCY@YY`@@AQCGEc@Og@]Yc@_A{CCUG[KWs@c@QUQKSG[Si@QWB&key=GIVE_YOUR_API_KEY

May need to update API restrictions [here](https://console.cloud.google.com/google/maps-apis/credentials) when your IP address changes.

# To Do

* Setup small server (on NUC?) to handle webhooks
