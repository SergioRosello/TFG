#!/bin/bash
# Helper script to configure PAM modules.

# Default settings for program.
DIRECTORY="/etc/pam.d/"
FILE="common-auth"
# Estas dos variables tienen que ser arrays de USB's
USBSERIAL=""
USBPRODUCT=""

# TODO: Save every device in variables, not last device only.
listUSBDevices () {
  for DEV in /sys/bus/usb/devices/* ; do
    if [ -e "${DEV}/bDeviceClass" ]; then
      CLASS=$(cat "${DEV}/bDeviceClass")
      if [ "${CLASS}" = "00" ] || [ "${CLASS}" = "08" ]; then
        USBPRODUCT=$(cat "${DEV}/product" 2> /dev/null)
        USBSERIAL=$(cat "${DEV}/serial" 2> /dev/null)
	if [ ! -z "${USBPRODUCT}" ] && [ ! -z "${USBSERIAL}" ]; then
	  echo "serial= ${USBSERIAL} product= ${USBPRODUCT}"
	fi
      fi
    fi
  done
}
# Function that prints usage of program/script
printHelp () {
  echo "This is a configuration helper script for PAM"
  echo "With this script you will be able to:"
  echo "  1. View available configuration files and their content"
  echo "  2. Configure the file you need with the pam_usbkey.so module"
  echo "     in order to authenticate with a USB stick."
  echo "  3. Remove the pam_usbkey.so configuration from the file specified"
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
echo
echo "--------------------Disclaimer--------------------"
echo "The program will now operate with theese settings:"
echo "If these settings are wrong, exit the program and"
echo "Set the settings correctly. A bad configuration"
echo "May lock you out from your computer"
echo "--------------------Disclaimer--------------------"
echo 
echo "----------------Script settings----------------"
echo PAM Configuration directoy: "${DIRECTORY}"
echo PAM Configuration file: "${FILE}"
echo "----------------Script settings----------------"
echo
# Ask user if he wants to continue
read -p "Do you want to continue? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then # Main program
  COMPLETEFILE="${DIRECTORY}${FILE}"
  read -p "Enter your USB stick now. Press RETURN when it's done."
  listUSBDevices
  echo " USB devices ->  "${USBSERIAL}" "${USBPRODUCT}""
#  read -p "You are going to view the contents of "${COMPLETEFILE}"
#  Press (q) to exit view (Press RETURN to continue)"
#  less $COMPLETEFILE

fi
