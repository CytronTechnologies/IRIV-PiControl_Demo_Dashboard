#!/bin/bash

# Make sure the script is run as root.
if [ $(id -u) -eq 0 ]; then
    echo
    echo
    echo "Please do not run as root."
    exit 1
fi



# Download script.
#curl -LO https://raw.githubusercontent.com/CytronTechnologies/IRIV-PI-CONTROL_Script/main/background_script.py


# Configure the config.txt file.
echo "###############################"
echo "Configuring the config.txt file"
echo "###############################"

config_file="/boot/config.txt"

# Disable USB OTG.
grep "#otg_mode=1" $config_file >/dev/null
if [ $? -ne 0 ]; then
    sudo sed -i "s/^otg_mode=1/#otg_mode=1/g" $config_file
fi

# Enable USB host.
grep "dtoverlay=dwc2,dr_mode=host" $config_file >/dev/null
if [ $? -ne 0 ]; then
    echo "dtoverlay=dwc2,dr_mode=host" | sudo tee -a $config_file >/dev/null
fi

#Enable I2C1.
grep "dtparam=i2c_arm=on" $config_file >/dev/null
if [ $? -ne 0 ]; then
    echo "dtparam=i2c_arm=on" | sudo tee -a $config_file >/dev/null
else
    grep "#dtparam=i2c_arm=on" $config_file >/dev/null
    if [ $? -eq 0 ]; then
        sudo sed -i "s/^#dtparam=i2c_arm=on/dtparam=i2c_arm=on/g" $config_file
    fi
fi

# Enable I2C0 for RTC.
grep "dtparam=i2c_vc=on" $config_file >/dev/null
if [ $? -ne 0 ]; then
    echo "dtparam=i2c_vc=on" | sudo tee -a $config_file >/dev/null
    echo "dtoverlay=i2c-rtc,pcf85063a,i2c_csi_dsi" | sudo tee -a $config_file >/dev/null
fi

# Enable UART and serial console.
grep "enable_uart=1" $config_file >/dev/null
if [ $? -ne 0 ]; then
    echo "enable_uart=1" | sudo tee -a $config_file >/dev/null
fi

# Change to external antenna.
grep "dtparam=ant2" $config_file >/dev/null
if [ $? -ne 0 ]; then
    echo "dtparam=ant2" | sudo tee -a $config_file >/dev/null
fi



# Install Node-RED.
echo
echo
echo "###################"
echo "Installing Node-RED"
echo "###################"
echo

printf 'Y\nY\nN\n' | bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)



# Install nodes.
echo
echo
echo "################"
echo "Installing Nodes"
echo "################"
echo

cd /home/pi/.node-red
npm install node-red-contrib-oled
npm install node-red-dashboard
npm install node-red-contrib-ads1x15_i2c

# Modify oled.js to rotate screen 180 degrees.
oled_js_file = "/home/pi/.node-red/node_modules/oled-i2c-bus/oled.js"
sed -i "s/this.SEG_REMAP = 0xA1; \/\/ using 0xA0 will flip screen/this.SEG_REMAP = 0xA0; \/\/ using 0xA0 will flip screen/g" $oled_js_file
sed -i "s/this.COM_SCAN_DEC, \/\/ screen orientation change to INC to flip/this.COM_SCAN_INC, \/\/ screen orientation change to INC to flip/g" $oled_js_file



# Download flows
echo
echo
echo "#################"
echo "Downloading Flows"
echo "#################"
echo

curl -LO https://raw.githubusercontent.com/CytronTechnologies/IRIV-PiControl_Demo_Dashboard/main/flows.json



# Setup autorun service
echo
echo
echo "#####################"
echo "Setup Autorun Service"
echo "#####################"
echo

sudo systemctl enable nodered.service
sudo systemctl enable NetworkManager



echo
echo
echo "#####################################"
echo "Cytron IRIV PiControl Setup Completed"
echo "#####################################"
echo
echo "Please reboot for the changes to take effect."
