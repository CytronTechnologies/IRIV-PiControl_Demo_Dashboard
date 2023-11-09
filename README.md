# Setup IRIV PiControl Demo Dashboard
1. Load the Raspberry Pi OS (32-bit Bullseye) to the eMMC using Raspberry Pi Imager.<br>
   We can preset the following configuration:
    - Hostname: iriv
    - Enable SSH
    - Username: pi
    - Password: raspberry
    - WiFi credential (If we want to use the WiFi for internet connection during setup)
2. Boot up the IRIV PiControl and run this command from the console (or SSH).
```
curl -L tinyurl.com/setup-iriv-picontrol-dashboard | bash
```
