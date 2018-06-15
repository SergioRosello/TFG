#!/bin/bash




printHelp () {
  echo "This is a configuration helper script for PAM"
  echo "With this script you will be able to:"
  echo "1. View available configuration files and their content"
  echo "2. Configure the file you need with the pam_usbkey.so module"
  echo "   in order to authenticate with a USB stick."
  echo "3. Remove the pam_usbkey.so configuration from the file specified"
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    printHelp
    shift
    ;;
    -c|--config)
    EXTENSION="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--searchpath)
    SEARCHPATH="$2"
    shift # past argument
    shift # past value
    ;;
    -l|--lib)
    LIBPATH="$2"
    shift # past argument
    shift # past value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

#echo CONFIGURATION FILE  = "${CONFIG}"
#echo LIBRARY PATH    = "${LIBPATH}"
#echo DEFAULT         = "${DEFAULT}"
#echo "Number files in SEARCH PATH with EXTENSION:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)
#if [[ -n $1 ]]; then
#    echo "Last line of file specified as non-opt/last argument:"
#    tail -1 "$1"
#fi

