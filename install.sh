#!/bin/sh

SCRIPT=`readlink -f $0`
DIR=`dirname $SCRIPT`
echo "[`date '+%Y-%M-%D %H:%M:%S'`]" > $DIR/install.log
set -ex

{
	UNITSDIR=systemd/user
	echo -n "Customising files based on user name: "
	for UNIT in autostart/akj.desktop $UNITSDIR/akj.service \
		$UNITSDIR/ardour.service $UNITSDIR/pd.service
	do
		sed -i "s|/placeholder|$HOME|g" $DIR/$UNIT
	done	
	echo "ok"

	echo -n "Installing systemd units: "
	install -d $DIR/$UNITSDIR/ $HOME/.config/$UNITSDIR
	install -m 0644 $DIR/$UNITSDIR/*.service $HOME/.config/$UNITSDIR
	echo "ok"

	echo -n "Installing desktop entry for autostart: "
	install -d $DIR/autostart $HOME/.config/autostart
	install $DIR/autostart/akj.desktop $HOME/.config/autostart
	echo "ok"

	echo -n "Installing scripts: "
	install -d $DIR/bin $HOME/bin
	install $DIR/bin/* $HOME/bin
	echo "ok"

	echo -n "Reload systemd services: "
	systemctl --user daemon-reload
	echo "ok"
} 2>> $DIR/install.log
