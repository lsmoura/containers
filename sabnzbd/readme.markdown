# Sabnzbd Docker


## About

This repository is a lightweight alpine build of the [sabnzbd](https://github.com/sabnzbd/sabnzbd) project. It aims to keep the images as small as possible
while retaining full functionality.


## Usage

Uses port 8080

mount config volume on `/config`. ini file full path is `/config/sabnzbd.ini`. If ini file is not present, sabnzbd install wizard will be shown on browser.

Example start:

```
docker run --rm --read-only -p 8080:8080 --tmpfs /tmp -v $(pwd)/config:/config -v $(pwd)/data:/media ghcr.io/lsmoura/sabnzbd:3.2.0
```
