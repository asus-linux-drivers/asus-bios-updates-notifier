# Asus BIOS Updates Notifier

[![License: GPL v2](https://img.shields.io/badge/License-GPLv2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
![Maintainer](https://img.shields.io/badge/maintainer-ldrahnik-blue)
[![Ask Me Anything !](https://img.shields.io/badge/Ask%20about-anything-1abc9c.svg)](https://github.com/asus-linux-drivers/asus-bios-updates-notifier/issues/new/choose)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fasus-linux-drivers%2Fasus-bios-updates-notifier&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)

Script whether is current BIOS version up-to-date may be run separately or every laptop start via provided systemctl service.

If you find this project useful, do not forget to give it a [![GitHub stars](https://img.shields.io/github/stars/asus-linux-drivers/asus-bios-updates-notifier.svg?style=social&label=Star&maxAge=2592000)](https://github.com/asus-linux-drivers/asus-bios-updates-notifier/stargazers) People already did!

## Features

- Notifier is installed for current user and does not run under `$ sudo`

## Installation

Get latest dev version using `git`

```bash
$ git clone https://github.com/asus-linux-drivers/asus-bios-updates-notifier
$ cd asus-bios-updates-notifier
```

and install

```bash
$ bash install.sh
```

or run separately parts of the install script

- run notifier every time the user log in (do NOT run as `$ sudo`, works via `systemctl --user`)

```bash
$ bash install_service.sh
```

## Tests

To run tests

```bash
$ bash tests/script.sh
```

## Existing similar projects

I do not know any.

**Why was this project created?** As a notifier about any released BIOS version.
