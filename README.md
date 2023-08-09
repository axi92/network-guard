# network-guard
Scans the network for not whitelisted devices. The whitelist is either a whitelist.json file or with the param -whitelistUrl a url from a webserver. I use git to store my whitelist. The whitelist from url is reloaded once per hour.

This programm is intended to be use with prometheus and optional grafana to visualize the "not-whitelisted" devices in a network.

# Usage

```
Usage of network-guard:
  -bindAddress string
        Address to bind the webserver for /metrics. Default empty = listening an all interfaces
  -bindPort int
        Port to bind the webserver for /metrics. Default 3000 (default 3000)
  -interfaceName string
        Network interface to scan. Example: enp38s0
  -whitelistUrl string
        Url to get the whitelist.json from, auth is not supported must be open. If this option is set the local whitelist.json will be ignored.
```

# Dependencies

`sudo apt-get install libpcap-dev`

Create a `whitelist.json` and use the `whitelist.json.template` as the template.

# Run & Build

## Run Local
Example: `sudo /usr/local/go/bin/go run networkGuard.go -interfaceName enp3s0`

## Build in docker with older glibc version
`docker run -ti --rm -v $(pwd):/workdir/. -w /workdir golang:buster bash`

Inside container:

`apt update && apt install -y libpcap-dev && wget "https://maclookup.app/downloads/json-database/get-db" -O src/mac-vendors-export.json && go build -buildvcs=false`

# Output

Those 2 raspberries are not whitelisted and got a 0 at the end of the line.

```
# HELP networkguard Online network devices.
# TYPE networkguard gauge
networkguard{ip="192.168.0.3", mac="00:00:00:00:00:00", vendor="VMware, Inc."} 1
networkguard{ip="192.168.0.15", mac="00:00:00:00:00:00", vendor="Raspberry Pi Foundation"} 0
networkguard{ip="192.168.0.19", mac="00:00:00:00:00:00", vendor="Raspberry Pi Trading Ltd"} 0
networkguard{ip="192.168.0.20", mac="00:00:00:00:00:00", vendor="NETGEAR"} 1
networkguard{ip="192.168.0.30", mac="00:00:00:00:00:00", vendor="ROHDE & SCHWARZ GMBH & CO. KG"} 1
networkguard{ip="192.168.0.44", mac="00:00:00:00:00:00", vendor="Wistron InfoComm(Kunshan)Co.,Ltd."} 1
networkguard{ip="192.168.0.47", mac="00:00:00:00:00:00", vendor="Raspberry Pi Trading Ltd"} 1
networkguard{ip="192.168.0.50", mac="00:00:00:00:00:00", vendor="VMware, Inc."} 1
networkguard{ip="192.168.0.52", mac="00:00:00:00:00:00", vendor="Micro-Star INTL CO., LTD."} 1
networkguard{ip="192.168.0.54", mac="00:00:00:00:00:00", vendor="Micro-Star INTL CO., LTD."} 1
networkguard{ip="192.168.0.56", mac="00:00:00:00:00:00", vendor="Fujitsu Technology Solutions GmbH"} 1
networkguard{ip="192.168.0.57", mac="00:00:00:00:00:00", vendor="VMware, Inc."} 1
```

# Grafana dashboard

![Dashbard](https://github.com/axi92/network-guard/blob/master/dashboard.png?raw=true)

Dashboard config in grafana-dashboard.json