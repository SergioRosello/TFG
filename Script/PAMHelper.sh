#!/bin/bash
# Helper script to configure PAM modules.

# Default settings for program.
DIRECTORY="/etc/pam.d/"
FILE="common-auth"
# Estas dos variables tienen que ser arrays de USB's
USBSERIALS=()
USBPRODUCTS=()

# Prints the script settings, to check with user that data is correct
printScriptSettings () {
  echo   
  echo "----------------Script settings----------------"
  echo PAM Configuration directoy: "${DIRECTORY}"
  echo PAM Configuration file: "${FILE}"
  echo "----------------Script settings----------------"
  echo
}
# Lists USB devices
listUSBDevices () {
  for (( i=0; i<"${#USBSERIALS[@]}"; i++ )); do
    echo " "$i") Serial=${USBSERIALS["$i"]} Product=${USBPRODUCTS["$i"]}"
  done
}

# Stores USB devices present in the system
getUSBInfo () {
  for DEV in /sys/bus/usb/devices/* ; do
    if [ -e "${DEV}/bDeviceClass" ]; then
      CLASS=$(cat "${DEV}/bDeviceClass")
      if [ "${CLASS}" = "00" ] || [ "${CLASS}" = "08" ]; then
        usbproduct=$(cat "${DEV}/product" 2> /dev/null)
        usbserial=$(cat "${DEV}/serial" 2> /dev/null)
	if [ ! -z "${usbproduct}" ] && [ ! -z "${usbserial}" ]; then
	  # Add device specs to arrays.
	  USBPRODUCTS+=("$usbproduct")
	  USBSERIALS+=("$usbserial")
	fi
      fi
    fi
  done
}
# Function that prints usage of program/script
printHelp () {
  echo
  echo "This is a configuration helper script for PAM"
  echo "With this script you will be able to:"
  echo "  1. View available configuration files and their content"
  echo "  2. Configure the file you need with the pam_usbkey.so module"
  echo "     in order to authenticate with a USB stick."
  echo "  3. Remove the pam_usbkey.so configuration from the file specified"
  echo
}

# Function that prints disclaimer
printDisclaimer () {
  echo
  echo "--------------------Disclaimer--------------------"
  echo "The program will now operate with theese settings:"
  echo "If these settings are wrong, exit the program and"
  echo "Set the settings correctly. A bad configuration"
  echo "May lock you out from your computer"
  echo "--------------------Disclaimer--------------------"
  echo 
}

# Parse program arguments
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    printHelp
    exit 0
    shift
    ;;
    -d|--directory)
    DIRECTORY="$2"  
    shift # past argument
    shift # past value
    ;;
    -f|--file)
    FILE="$2"
    shift
    shift
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Start of program logic
printDisclaimer
printScriptSettings
# Ask user if he wants to continue
read -p "Do you want to continue? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then # Main program
  COMPLETEFILE="${DIRECTORY}${FILE}"
  read -p "Enter your USB stick now. Press RETURN when it's done."
  getUSBInfo
  listUSBDevices
#  echo " USB devices ->  "${USBSERIAL}" "${USBPRODUCT}""
#  read -p "You are going to view the contents of "${COMPLETEFILE}"
#  Press (q) to exit view (Press RETURN to continue)"
#  less $COMPLETEFILE

fi
