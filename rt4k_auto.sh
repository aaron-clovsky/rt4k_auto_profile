#!/bin/bash
################################################################################
# Automatically Set RetroTink 4K Profile on Input Change
#
# Copyright (c) 2025 Aaron Clovsky
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
################################################################################

########################################
# Configuration
########################################

# Paths to dependencies
READHDMI=/home/pi/ctrl_monoprice_4067
READSCART=/home/pi/read_gscartsw.sh

# All errors exit immediately
set -e

# Determine which serial device is the HDMI switch
if ! $READHDMI /dev/ttyUSB0 >/dev/null 2>&1; then
  DEV_HDMI=/dev/ttyUSB1
  DEV_RT4K=/dev/ttyUSB0
else
  DEV_HDMI=/dev/ttyUSB0
  DEV_RT4K=/dev/ttyUSB1
fi

if ! $READHDMI $DEV_HDMI >/dev/null 2>&1; then
  echo "Error: Failed to read HDMI Switch Input from $DEV_HDMI"
  exit 1
fi

# Initialize the RetroTink 4K's serial connection
stty -F $DEV_RT4K 115200 cs8 -cstopb -parenb

# This is not a valid command, but without it the first remote command may fail
echo "test" > $DEV_RT4K

# Log Startup
echo "Init Complete"
echo "RT4K is $DEV_RT4K"
echo "HDMI Switch is $DEV_HDMI"

########################################
# Main loop
########################################
last_hdmi_input=0
last_scart_input=0

while true; do
  ####################
  # HDMI
  ####################
  hdmi_input=$($READHDMI $DEV_HDMI)

  # echo "HDMI: Input is '$hdmi_input' (last was '$last_hdmi_input')"

  if [ $hdmi_input -ne 0 ] && [ $hdmi_input -ne $last_hdmi_input ]
  then
    echo "remote prof${hdmi_input}" > $DEV_RT4K
    # Log command
    echo "remote prof${hdmi_input}"
  fi

  last_hdmi_input=$hdmi_input

  ####################
  # SCART
  ####################
  scart_input=$($READSCART)

  # echo "SCART: Input is '$scart_input' (last was '$last_scart_input')"

  if [ $scart_input -ne 0 ] && [ $scart_input -ne $last_scart_input ]; then
    if [ $scart_input -le 4 ]; then
      echo "remote prof$((${scart_input}+8))" > $DEV_RT4K
      # Log command
      echo "remote prof$((${scart_input}+8))"
    fi
  fi

  last_scart_input=$scart_input

  ####################
  # Delay
  ####################
  sleep 2
done
