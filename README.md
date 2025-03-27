# Setup IRIV PiControl Demo Dashboard
1. Load the Raspberry Pi OS (32-bit Bullseye) to the eMMC using Raspberry Pi Imager.<br>
   We can preset the following configuration:
    - Hostname: iriv
    - Enable SSH
    - Username: pi
    - Password: raspberry
    - WiFi credential (If we want to use the WiFi for internet connection during setup)
2. Boot up the IRIV PiControl and run this command from the console (or SSH).
   - Instal Node-RED
     ```
     bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
     ```
   - Run the configuration script
     ```
     curl -L tinyurl.com/setup-iriv-picontrol-dashboard | bash
     ```
   - Apply the patch to fix the ADC bug in Node-RED
     ```
     curl -L tinyurl.com/iriv-picontrol-adc-patch | bash
     ```
**What the setup script does?**
- Add the following settings to /boot/config.txt
  - Disable USB OTG and enable the USB Host.
  - Enable I2C for RTC and I2C1.
  - Enable UART and serial console.
  - Changed the WiFi/Bluetooth antenna to external antenna.
- Install Node-RED and these nodes:
  - node-red-contrib-oled
  - node-red-dashboard
  - node-red-contrib-ads1x15_i2c
- Modify the /home/pi/.node-red/node_modules/oled-i2c-bus/oled.js file to rotate the OLED screen 180 degrees.
- Download the demo flows.
- Enable the Node-RED and NetworkManager service for autorun.

# How to Disable the WiFi AP and Node-RED Demo.
We can use the serial console by connecting the USB-C to the computer and use the software such as Putty to access the console.
<br><br>
The WiFi AP is turned on in the Node-RED demo. We just need to disable the Node-RED service with this command:
```
systemctl disable nodered.service
```
Reboot the IRIV PiControl and the Node-RED will not autorun, WiFi AP will not be enabled too.<br><br>
If we want to run the Node-RED without running the demo flows, use this command:
```
node-red -safe
```
After that, we can modify the flows accordingly and deploy to run it.<br><br>

If we want to connect the IRIV PiControl to the other WiFi network, we can use this command:
```
sudo nmcli --ask dev wifi connect <ssid>
```
Use this to list out the available WiFi networks.
```
sudo nmcli dev wifi list
```
