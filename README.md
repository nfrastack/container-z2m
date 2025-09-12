# nfrastack/container-z2m

## About

This repository will build a container with [Clam Antivirus](https://www.z2m.net) to scan files or mail messages.

* Auto Configuration Support
* Automatic Downlad and update of Virus Definitions
* Ability to load custom definitions

## Maintainer

* [Nfrastack](https://www.nfrastack.com)

## Table of Contents


* [About](#about)
* [Maintainer](#maintainer)
* [Table of Contents](#table-of-contents)
* [Installation](#installation)
  * [Prebuilt Images](#prebuilt-images)
  * [Quick Start](#quick-start)
  * [Persistent Storage](#persistent-storage)
* [Configuration](#configuration)
  * [Environment Variables](#environment-variables)
    * [Base Images used](#base-images-used)
    * [Core Configuration](#core-configuration)
  * [Users and Groups](#users-and-groups)
  * [Networking](#networking)
* [Maintenance](#maintenance)
  * [Shell Access](#shell-access)
* [Support & Maintenance](#support--maintenance)
* [License](#license)

## Installation

### Prebuilt Images

Feature limited builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-z2m/pkgs/container/container-z2m) and [Docker Hub](https://hub.docker.com/r/nfrastack/z2m).

To unlock advanced features, one must provide a code to be able to change specific environment variables from defaults. Support the development to gain access to a code.

To get access to the image use your container orchestrator to pull from the following locations:

```
ghcr.io/nfrastack/container-z2m:(image_tag)
docker.io/nfrastack/z2m:(image_tag)
```

Image tag syntax is:

`<image>:<optional tag>`

Example:

`ghcr.io/nfrastack/container-z2m:latest` or

`ghcr.io/nfrastack/container-z2m:1.0` or

* `latest` will be the most recent commit
* An otpional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - These are the safest
* If there are multiple distribution variations it may include a version - see the registry for availability

Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

* Map persistent storage for access to configuration and data files for backup.
* Set various environment variables to understand the capabilities of this image.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory | Description |
| --------- | ----------- |
| `/data`   | Data        |
| `/logs`   | Logs        |

## Configuration

### Environment Variables

#### Base Images used

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                   | Description |
| ------------------------------------------------------- | ----------- |
| [OS Base](https://github.com/nfrastack/container-base/) | Base Image  |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Core Configuration

| Variable         | Description                                                                 | Default   |
|------------------|-----------------------------------------------------------------------------|-----------|
| SETUP_MODE       | Auto configure on startup, set to MANUAL to disable                         | `AUTO`      |
| ENABLE_NGINX     | Enable Nginx web server                                                     | `TRUE`      |
| Z2M_USER         | User to run Z2M                                                             | `z2m`       |
| Z2M_GROUP        | Group to run Z2M                                                            | `z2m`       |

#### Logging

| Variable             | Description                                 | Default           |
|----------------------|---------------------------------------------|-------------------|
| LOG_FILE             | Log file name                               | `z2m.log`           |
| LOG_TYPE             | Log type (console, file, both, none)        | `both`              |
| LOG_LEVEL            | Log level                                   | `info`              |
| LOG_PATH             | Log directory                               | `/logs/`            |
| LOG_TIMESTAMP_FORMAT | Log timestamp format                        | `YYYY-MM-DDTHH:mm:ss` |

#### Data & Configuration

| Variable     | Description                        | Default      |
|--------------|------------------------------------|--------------|
| CONFIG_FILE  | Main configuration file            | `configuration.yaml` |
| DATA_PATH    | Data directory                     | `/data/`       |

#### MQTT Configuration

| Variable                      | Description                                 | Default              |
|-------------------------------|---------------------------------------------|----------------------|
| MQTT_HOST                     | MQTT broker hostname                        | `mqtt://mqtt`          |
| MQTT_TOPIC_BASE               | Base topic for MQTT                         | `zigbee2mqtt`          |
| MQTT_REJECT_UNAUTHORIZED      | Reject unauthorized MQTT connections        | `true`          |
| MQTT_INCLUDE_DEVICE_INFORMATION| Include device info in MQTT                 | `false`                |
| MQTT_KEEPALIVE                | MQTT keepalive interval (seconds)           | `60`                   |
| MQTT_VERSION                  | MQTT protocol version                       | `4`                    |
| MQTT_FORCE_DISABLE_RETAIN     | Disable retain flag on MQTT messages        | `false`                |

#### Adapter/Coordinator

| Variable             | Description                                 | Default      |
|----------------------|---------------------------------------------|--------------|
| ADAPTER_LOCATION     | Zigbee adapter location                     | `(none)`       |
| ADAPTER_DISABLE_LED  | Disable adapter LED                         | `false`       |
| ADAPTER_BAUDRATE     | Adapter baudrate                            | `115200`       |
| ADAPTER_DRIVER       | Adapter driver                              | `ember`       |
| ADAPTER_RTSCTS       | Enable RTS/CTS flow control                 | `false`       |

#### Zigbee Network

| Variable                | Description                              | Default      |
|-------------------------|------------------------------------------|--------------|
| ZIGBEE_CHANNEL          | Zigbee channel                           | `25`           |
| ZIGBEE_TRANSMIT_POWER   | Zigbee transmit power                    | `20`           |
| ZIGBEE_NETWORK_KEY      | Zigbee network key                       | (none)       |
| ZIGBEE_EXT_PAN_ID       | Zigbee extended PAN ID                   | (none)       |
| ZIGBEE_PAN_ID           | Zigbee PAN ID                            | (none)       |

#### Home Assistant Integration

| Variable                          | Description                                 | Default      |
|-----------------------------------|---------------------------------------------|--------------|
| ENABLE_HOMEASSISTANT              | Enable Home Assistant integration           | `false`        |
| HOMEASSISTANT_MQTT_TOPIC_DISCOVERY| Home Assistant MQTT discovery topic         | `homeassistant` |
| HOMEASSISTANT_MQTT_TOPIC_STATUS   | Home Assistant MQTT status topic            | `hass/status`  |
| HOMEASSISTANT_LEGACY_ENTITY_ATTRIBUTES | Use legacy entity attributes           | `false`        |
| HOMEASSISTANT_LEGACY_TRIGGERS     | Use legacy triggers                         | `false`        |

#### Frontend (Web Interface)

| Variable             | Description                                 | Default      |
|----------------------|---------------------------------------------|--------------|
| ENABLE_FRONTEND      | Enable Z2M frontend web interface           | `true`         |
| FRONTEND_LISTEN_PORT | Frontend listen port                        | `8080`         |
| FRONTEND_LISTEN_IP   | Frontend listen IP                          | `0.0.0.0`      |

#### OTA (Over-the-Air Updates)

| Variable                        | Description                                 | Default      |
|---------------------------------|---------------------------------------------|--------------|
| ENABLE_OTA                      | Enable OTA updates                          | `TRUE`         |
| OTA_ENABLE_AUTO_UPDATE_CHECK    | Enable auto OTA update check                | `false`        |
| OTA_AUTO_UPDATE_CHECK_INTERVAL  | OTA update check interval (minutes)         | `1440`         |

#### Device Availability

| Variable                             | Description                                 | Default      |
|--------------------------------------|---------------------------------------------|--------------|
| ENABLE_DEVICE_AVAILABILITY           | Enable device availability tracking         | `false`        |
| DEVICE_AVAILABILITY_ACTIVE_TIMEOUT   | Active timeout (seconds)                    | `10`           |
| DEVICE_AVAILABILITY_PASSIVE_TIMEOUT  | Passive timeout (seconds)                   | `1500`         |

#### Watchdog

| Variable           | Description                                 | Default      |
|--------------------|---------------------------------------------|--------------|
| ENABLE_WATCHDOG    | Enable watchdog monitoring                  | `TRUE`         |
| WATCHDOG_INTERVAL  | Watchdog interval(s)                        | `0.5,1,1,1,1,5,5` |

## Users and Groups

| Type  | Name  | ID   |
| ----- | ----- | ---- |
| User  | `z2m` | 2323 |
| Group | `z2m` | 2323 |

### Networking

| Port | Protocol | Description |
| ---- | -------- | ----------- |

* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.


## Support & Maintenance

* For community help, tips, and community discussions, visit the Discussions board.
* For personalized support or a support agreement, see Nfrastack Support.
* To report bugs, submit a Bug Report. Usage questions will be closed as not-a-bug.
* Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
* Updates are best-effort, with priority given to active production use and support agreements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

