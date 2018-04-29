#!/bin/bash
URL=$1
OUTPUT="$(curl --proto-default http http://cd.cs.odu.edu/cd/$URL |  grep estimated-creation-date)"
echo "${OUTPUT}"
