#!/bin/bash
 
# To use important variables from command line use the following code:
COMMAND=$0    # Zero argument is shell command
PTEMPDIR=$1   # First argument is temp folder during install
PSHNAME=$2    # Second argument is Plugin-Name for scipts etc.
PDIR=$3       # Third argument is Plugin installation folder
PVERSION=$4   # Forth argument is Plugin version
#LBHOMEDIR=$5 # Comes from /etc/environment now. Fifth argument is
              # Base folder of LoxBerry
PTEMPPATH=$6  # Sixth argument is full temp path during install (see also $1)
 
# Combine them with /etc/environment
PCGI=$LBPCGI/$PDIR
PHTML=$LBPHTML/$PDIR
PTEMPL=$LBPTEMPL/$PDIR
PDATA=$LBPDATA/$PDIR
PLOG=$LBPLOG/$PDIR # Note! This is stored on a Ramdisk now!
PCONFIG=$LBPCONFIG/$PDIR
PSBIN=$LBPSBIN/$PDIR
PBIN=$LBPBIN/$PDIR
 
if [ -e "$PDATA/fhem.pl" ]; then
	echo "<INFO> Found existing FHEM installation from old installation. Migrating to new installation..."
	echo "<INFO> Copying files from existing FHEM installation..."
	chown -R fhem:dialout $PDATA/*
	cp -an $PDATA/* /opt/fhem
	mkdir $PDATA/oldinstall
	mv $PDATA/* $PDATA/oldinstall
	cp $PCONFIG/fhem.cfg /opt/fhem
	mv $PCONFIG/fhem.cfg $PCONFIG/fhem.cfg.oldinstall
	echo "<INFO> Adjust FHEM config to some default values..."
	/bin/sed -i 's:^define initialUsbCheck notify:#define initialUsbCheck notify:g' /opt/fhem/fhem.cfg
	/bin/sed -i 's:/loxberry/log/plugins/fhem/fhem.log:/fhem/log/fhem-%Y-%m.log:g' /opt/fhem/fhem.cfg
	/bin/sed -i 's:/loxberry/data/plugins/fhem/fhem.save:/fhem/fhem.save:g' /opt/fhem/fhem.cfg
	/bin/sed -i 's:/loxberry/log/plugins/fhem/%NAME.log:/fhem/log/%NAME.log:g' /opt/fhem/fhem.cfg
	/bin/sed -i 's:/loxberry/data/plugins/fhem/eventTypes.txt:/fhem/eventTypes.txt:g' /opt/fhem/fhem.cfg
else
	echo "<INFO> Adjust FHEM config to some default values..."
	/bin/sed -i 's:^define initialUsbCheck notify:#define initialUsbCheck notify:g' /opt/fhem/fhem.cfg
fi
chown fhem:dialout /opt/fhem/fhem.cfg

exit 0
