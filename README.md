# hummingbot-compose
Deployment resources for docker compose


## Usage

First of all copy the env file to .env and modify its contents.

The following general purpose ENV Variables are defined within the env file:

```
GW_IMAGE="hummingbot/gateway:latest"
GW_PASSPHRASE=123
GW_PORT=15888
DB_NAME=postgres
DB_USER=postgres
DB_PASSWORD=postgres
HBOT_IMAGE="hummingbot/hummingbot:latest"
HBOT_COMPOSE_FILE=./hbot.compose.yml
```

Furthermore, the below are bot-specific and can be used with the start/stop/rm
scripts.

```
HBOT_ID=TEST
HBOT_PSK=123
HBOT_FILE=conf_pure_mm_1.yml
HBOT_MEM_LIMIT=1000m
HBOT_MEM_RESERVATION=300m
```


### Start Core 

The `start_core.sh` script is used to deploy the core components of hummingbot,
which are:

- Gateway
- PostgreSQL
- EMQX v5 Message Broker

The deployment also includes some tools for management and monitoring:

- Streamlit App
- Prometheus
- Grafana

To start the deployment simply execute the `start_core.sh` script


### Start Bot

TODO

### Stop Bot

TODO

### Remove Bot

TODO

### List bots

TODO
