# mboard-build
bash script that automates building of the mboard server packages

## requirements

* ubuntu x86 or arm
* all repositories are updated (via git pull)
* golang 1.8+
* electron binary 1.7.10+
* node 8.9+
* web assets:  font-awesome, material-components-web stored to directory $HOME/web
```
$HOME/web/material-components-web/material-components-web.min.css
$HOME/web/material-components-web/material-components-web.min.js
$HOME/web/font-awesome/font-awesome.min.css"
```
* electron binaries `$HOME/electron`

## notes

* build go binaries
* copy all sources to package directory
* build debian package

## package layout

* mboard/debian/home/mboard/bin/mboard-go
* mboard/debian/home/mboard/bin/mboard-www/
* mboard/debian/home/mboard/bin/electron/
* mboard/debian/home/mboard/conf/settings.json
* mboard/debian/home/mboard/data
* mboard/debian/home/mboard/data/mboard.db
* mboard/debian/home/mboard/log
* mboard/debian/etc/systemd/system
* mboard/debian/etc/systemd/system/mboard-go.service
* mboard/debian/home/mboard/.config/autostart
* mboard/debian/home/mboard/.config/autostart/mboard-electron.desktop

## build package

`sh build.sh`

## test package

`sudo deb -i mboard.deb`

