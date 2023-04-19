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
HBOT_MEM_LIMIT=1000m
HBOT_MEM_RESERVATION=300m
```

### Start Core 

The `start_core.sh` script is used to deploy the core components of hummingbot,
which are:

- Gateway
- PostgreSQL
- EMQX v5 Message Broker (MQTT)

The deployment also includes some tools for management and monitoring:

- Streamlit App
- Prometheus
- Grafana

Latest improvements includes a component [tradingview-mqtt-bridge](https://github.com/klpanagi/tradingview-webhook-mqtt) that forwards TradingView Alerts
(from webhooks) to an MQTT Topic (`tradingview/alerts`), from where bots can
consume alerts and implement and high-level logic for executing orders based on
event data. For more information about how to use this component can be found
[here](https://github.com/klpanagi/tradingview-webhook-mqtt).

```
Starting Hummingbot Core...

    Gateway Parameters:
    - Image:
    - Port: 15888
    - Passphrase: 123

    Gateway Parameters:
    - Image:
    - Port: 15888
    - Passphrase: 123

    PostgresDB Parameters:
    - Image: postgres:13
    - Name: postgres
    - User: postgres
    - Password: postgres

    Grafana Parameters:
    - Image: grafana/grafana:9.3.2

    TradingView Bridge Parameters:
    - Image: klpanagi/tradingview-mqtt-bridge:latest
    - Security Key: 123123
    - MQTT Topic: tradingview/alerts

    Streamlit App Parameters:
    - Image: hummingbot/streamlit-app:latest
    - Port: 8501

[+] Running 7/0
 ✔ Container hbot-gateway             Created
 ✔ Container hbot-emqx-1              Created
 ✔ Container hbot-db                  Created
 ✔ Container hbot-grafana             Created
 ✔ Container hbot-prometheus          Created
 ✔ Container streanlit-app            Created
 ✔ Container tradingview-mqtt-bridge  Created
```

The `start_core.sh` script uses the `core.compsoe.yml` compose deployment file 
to configure and manage deployments based on given flags.

```bash
[I] ➜ ./start_core.sh -h

Usage: ./start_core.sh [ --no-gw ]
                       [ --no-mqtt ]
                       [ --no-db ]
                       [ --no-obs ]
                       [ --no-analysis ]
                       [ --no-tv ]
                       [ -h | --help ]
```

Flags:

- `--no-gw`: Exclude gateway
- `--no-mqtt`: Exclude mqtt broker
- `--no-db`: Exclude db
- `--no-analysis`: Exclude analysis tools
- `--no-tv`: Exclude tradingview integration tools
- `--no-obs`: Exclude observability stack (Prometheus + Grafana)



### Start Bot

The `start_bot.sh` script is used to create and start bot instances.

```bash
[I] ➜ ./start_bot.sh -h     

Usage: ./start_bot.sh [ -n | --id ]
                      [ -p | --psk ]
                      [ -f | --strategy-file ]
                      [ -d | --detach ]
                      [ -h | --help  ]
```

**Options**:

- `-n | --id`: The id of the bot
- `-p | --psk`: The password of the bot
- `-f | --strategy-file`: The strategy file to autoload
- `-d | --detach`: Deploy and detach
- `-h | --help`: Prints help message and exits

The below example will create/start bot `mybot1` and will attach to the tty of
the container.

```bash
[I] ➜ ./start_bot.sh --id mybot1

Creating hbot container with parameters:
- id: mybot1
- psk: 
- strategy_file: 
- detach: 
[+] Running 5/0
 ✔ Volume "hbot-mybot1-conf"        Created
 ✔ Volume "hbot-mybot1-logs"        Created
 ✔ Volume "hbot-mybot1-scripts"     Created
 ✔ Volume "hbot-mybot1-pmmscripts"  Created
 ✔ Volume "hbot-mybot1-data"        Created
a751bc1e5fb91599f8a2256ca01e4632342a3365948baf6adf07fa1e09990325
```

### Stop Bot

Stops a containerized bot given it's ID.

```bash
[I] ➜ ./stop_bot.sh --id mybot1 -h       

Usage: ./stop_bot.sh [ -n | --id ]
                     [ -h | --help  ]
```

**Options**:

- `-n | --id`: The id of the bot
- `-h | --help`: Prints help message and exits

Example usage:

```bash
[I] ➜ ./stop_bot.sh --id mybot1          

hbot-mybot1
```

### Remove Bot

Remove the container and the volumes of a bot.

**Options**:

- `-n | --id`: The id of the bot
- `-h | --help`: Prints help message and exits

Example usage:

```bash
[I] ➜ ./rm_bot.sh --id mybot1

[*] - Removing container...
[*] - Removing volumes...
hbot-mybot1-data
hbot-mybot1-conf
hbot-mybot1-logs
hbot-mybot1-scripts
hbot-mybot1-pmmscripts
```

### List bots

List available bots

```bash
[I] ➜ ./ls_bots.sh -h

Usage: ./ls_bots.sh [ -h | --help  ]
```

**Options**:

- `-h | --help`: Prints help message and exits

Example usage:

```bash
[I] ➜ ./ls_bots.sh

hbot-mybot1
```
