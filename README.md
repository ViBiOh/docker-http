# viws

A superlight HTTP fileserver with customizable behavior.

[![Build](https://github.com/ViBiOh/viws/workflows/Build/badge.svg)](https://github.com/ViBiOh/viws/actions)
[![codecov](https://codecov.io/gh/ViBiOh/viws/branch/main/graph/badge.svg)](https://codecov.io/gh/ViBiOh/viws)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FViBiOh%2Fviws.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2FViBiOh%2Fviws?ref=badge_shield)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=ViBiOh_viws&metric=alert_status)](https://sonarcloud.io/dashboard?id=ViBiOh_viws)

## Installation

```bash
go install github.com/ViBiOh/viws/cmd/viws@latest
```

### Light version

Light version (without GZIP and Prometheus) is also available, for a smaller binary.

```bash
go install github.com/ViBiOh/viws/cmd/viws-light@latest
```

## Features

- Full TLS support
- GZIP Compression
- Prometheus monitoring on dedicated port
- Read-only container
- Serve static content, with Single Page App handling
- Serve environment variables for easier-config
- Configurable logger with JSON support

## Single Page Application

This mode is useful when you have a router in your javascript framework (e.g. Angular/React/Vue). When a request target a not found file, it returns the index instead of 404. This option also deactivates cache for the index in order to make work the cache-buster for javascript/style files.

```bash
curl myWebsite.com/users/vibioh/
=> /index.html
```

## Endpoints

- `GET /health`: healthcheck of server, respond [`okStatus (default 204)`](#usage) or `503` during [`graceDuration`](#usage) when SIGTERM is received
- `GET /ready`: same response than `/health` but it also checks external dependencies availability
- `GET /version`: value of `VERSION` environment variable
- `GET /env`: values of [specified environments variables](#environment-variables)
- `GET /metrics`: Prometheus metrics values (on a dedicated port)

## Environment variables

Environment variables are exposed as JSON from a single and easy to remember endpoint: `/env`. You have full control of exposed variables by declaring them on the CLI.

This feature is useful for Single Page Application, you first request `/env` in order to know the `API_URL` or `CONFIGURATION_TOKEN` and then proceed. You reuse the same artifact between `pre-production` and `production`, only variables change, in [respect of 12factor app](https://12factor.net/config)

### Configuration example

```bash
API_URL=https://api.vibioh.fr vibioh/viws --env API_URL

> curl http://localhost:1080/env
{"API_URL":"https://api.vibioh.fr"}
```

### Usage in SPA

```js
// index.js

const response = await fetch("/env");
const config = await response.json();
ReactDOM.render(<App config={config} />, document.getElementById("root"));
```

## Usage

By default, server is listening on the `1080` port and serve content for GET requests from the `/www/` directory. It assumes that HTTPS is done, somewhere between browser and server (e.g. CloudFlare, ReverseProxy, Traefik, ...) so it sets HSTS flag by default.

```bash
Usage of viws:
  -address string
        [server] Listen address {VIWS_ADDRESS}
  -cert string
        [server] Certificate file {VIWS_CERT}
  -corsCredentials
        [cors] Access-Control-Allow-Credentials {VIWS_CORS_CREDENTIALS}
  -corsExpose string
        [cors] Access-Control-Expose-Headers {VIWS_CORS_EXPOSE}
  -corsHeaders string
        [cors] Access-Control-Allow-Headers {VIWS_CORS_HEADERS} (default "Content-Type")
  -corsMethods string
        [cors] Access-Control-Allow-Methods {VIWS_CORS_METHODS} (default "GET")
  -corsOrigin string
        [cors] Access-Control-Allow-Origin {VIWS_CORS_ORIGIN} (default "*")
  -csp string
        [owasp] Content-Security-Policy {VIWS_CSP} (default "default-src 'self'; base-uri 'self'")
  -directory string
        [viws] Directory to serve {VIWS_DIRECTORY} (default "/www/")
  -env string
        [env] Environments key variables to expose, comma separated {VIWS_ENV}
  -frameOptions string
        [owasp] X-Frame-Options {VIWS_FRAME_OPTIONS} (default "deny")
  -graceDuration string
        [http] Grace duration when SIGTERM received {VIWS_GRACE_DURATION} (default "30s")
  -gzip
        [gzip] Enable gzip compression {VIWS_GZIP} (default true)
  -headers string
        [viws] Custom headers, tilde separated (e.g. content-language:fr~X-UA-Compatible:test) {VIWS_HEADERS}
  -hsts
        [owasp] Indicate Strict Transport Security {VIWS_HSTS} (default true)
  -idleTimeout string
        [server] Idle Timeout {VIWS_IDLE_TIMEOUT} (default "2m")
  -key string
        [server] Key file {VIWS_KEY}
  -loggerJson
        [logger] Log format as JSON {VIWS_LOGGER_JSON}
  -loggerLevel string
        [logger] Logger level {VIWS_LOGGER_LEVEL} (default "INFO")
  -loggerLevelKey string
        [logger] Key for level in JSON {VIWS_LOGGER_LEVEL_KEY} (default "level")
  -loggerMessageKey string
        [logger] Key for message in JSON {VIWS_LOGGER_MESSAGE_KEY} (default "message")
  -loggerTimeKey string
        [logger] Key for timestamp in JSON {VIWS_LOGGER_TIME_KEY} (default "time")
  -okStatus int
        [http] Healthy HTTP Status code {VIWS_OK_STATUS} (default 204)
  -port uint
        [server] Listen port (0 to disable) {VIWS_PORT} (default 1080)
  -prometheusAddress string
        [prometheus] Listen address {VIWS_PROMETHEUS_ADDRESS}
  -prometheusCert string
        [prometheus] Certificate file {VIWS_PROMETHEUS_CERT}
  -prometheusGzip
        [prometheus] Enable gzip compression of metrics output {VIWS_PROMETHEUS_GZIP} (default true)
  -prometheusIdleTimeout string
        [prometheus] Idle Timeout {VIWS_PROMETHEUS_IDLE_TIMEOUT} (default "10s")
  -prometheusIgnore string
        [prometheus] Ignored path prefixes for metrics, comma separated {VIWS_PROMETHEUS_IGNORE}
  -prometheusKey string
        [prometheus] Key file {VIWS_PROMETHEUS_KEY}
  -prometheusPort uint
        [prometheus] Listen port (0 to disable) {VIWS_PROMETHEUS_PORT} (default 9090)
  -prometheusReadTimeout string
        [prometheus] Read Timeout {VIWS_PROMETHEUS_READ_TIMEOUT} (default "5s")
  -prometheusShutdownTimeout string
        [prometheus] Shutdown Timeout {VIWS_PROMETHEUS_SHUTDOWN_TIMEOUT} (default "5s")
  -prometheusWriteTimeout string
        [prometheus] Write Timeout {VIWS_PROMETHEUS_WRITE_TIMEOUT} (default "10s")
  -readTimeout string
        [server] Read Timeout {VIWS_READ_TIMEOUT} (default "5s")
  -shutdownTimeout string
        [server] Shutdown Timeout {VIWS_SHUTDOWN_TIMEOUT} (default "10s")
  -spa
        [viws] Indicate Single Page Application mode {VIWS_SPA}
  -url string
        [alcotest] URL to check {VIWS_URL}
  -userAgent string
        [alcotest] User-Agent for check {VIWS_USER_AGENT} (default "Alcotest")
  -writeTimeout string
        [server] Write Timeout {VIWS_WRITE_TIMEOUT} (default "10s")
```

## Docker

```bash
docker run -d --name website \
  -p 1080:1080/tcp \
  -v "$(pwd):/www/:ro" \
  vibioh/viws
```

We recommend using a Dockerfile to ship your files inside it.

e.g.

```
FROM vibioh/viws

ENV VERSION 1.2.3-1234abcd
COPY dist/ /www/
```

### Light image

Image with tag `:light` is also available.

e.g.

```
FROM vibioh/viws:light

ENV VERSION 1.0.0-1234abcd
COPY dist/ /www/
```

## Compilation

You need Go 1.12+ with go modules enabled in order to compile the project.

```bash
make go
```

## License

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FViBiOh%2Fviws.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2FViBiOh%2Fviws?ref=badge_large)
