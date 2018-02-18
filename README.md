# mboard-build
automates building of the mboard server software

## requirements

* ubuntu x86 or armvl
* ssh keys are configured for github
* golang
* electron binary
* web assets:  font-awesome, material-components-web

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

from ./mboard directory

`dpkg-deb —build debian`
`mv debian.deb mboard-armv7l-0.1.deb`

## test package

`deb -i mboard-armv7l-0.1.deb`

