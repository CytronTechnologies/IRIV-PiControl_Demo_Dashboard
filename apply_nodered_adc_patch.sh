#!/bin/bash

# Make sure the script is not run as root.
if [ $(id -u) -eq 0 ]; then
    echo
    echo
    echo "Please do not run as root."
    exit 1
fi

# Make sure Node-RED is already installed.
nodered_dir="/home/pi/.node-red"
ls $nodered_dir >/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
    echo 'Please install Node-RED before running this script.'
	exit 1
fi



# Modified the ads1x15 module to fix the ADC bug (https://github.com/felixdrp/ads1x15/issues/3).
cd $nodered_dir

ads1x15_js_file=$nodered_dir"/node_modules/ads1x15/index.js"
sed -i "s/delayFineTune = 1,/delayFineTune = 2,/g" $ads1x15_js_file

echo
echo
echo "#######################################"
echo "Cytron IRIV PiControl ADC Patch Applied"
echo "#######################################"
echo
echo "Please reboot for the changes to take effect."
