# Automatic Profiles for RetroTINK 4K using a Raspberry Pi

## MOTIVATION

The RetroTINK 4K can be controlled via USB serial connection which makes
it relatively easy to interface with using an SBC like a Raspberry Pi. This
project was created to interface the gscartsw and Monoprice
HRM-2218F with the RetroTINK 4K, enabling automatic profile switching
when a console is powered on.

## CREDIT

- [Arthrimus](https://arthrimus.com/) published
[this video](https://www.youtube.com/watch?v=e87yDrOlebA) and it inspired me
  - **You should probably just buy the [SVS](https://scalablevideoswitch.com/) once
it is released instead of using this software**
- [Mike Chi](https://www.retrotink.com/) made the incredible
[RetroTINK 4K](https://www.retrotink.com/product-page/retrotink-4k), and
made it very easy to interface with
- superg for the amazing [gscartsw](https://www.retrorgb.com/gscartsw.html)

## DESCRIPTION

This service detects input changes on the HRM-2218F and
gscartsw and automatically loads one of 12 profiles on the RetroTink 4K
(the same 12 profiles which are mapped to the 12 numbered buttons on the
remote). The 8 HRM-2218F HDMI inputs are mapped to profiles 1-8 and the lower 4
SCART inputs (the 4 inputs farthest from the 2 outputs) on the gscartsw are
mapped to profiles 9-12 while the upper 4 SCART inputs are not used.

## REQUIREMENTS

- A [[RetroTINK 4K]](https://www.retrotink.com/product-page/retrotink-4k)
(either PRO or CE should work)
- A [[gscartsw]](https://www.retrorgb.com/gscartsw.html)
- A [[Monoprice HRM-2218F]](https://www.amazon.com/gp/product/B003L14X3A)
(discontinued, try [eBay](https://www.ebay.com/sch/i.html?_nkw=HRM-2218F))
- A **[Raspberry Pi]**
  - I recommend [Raspberry Pi Zero WH](https://www.adafruit.com/product/3708)
or [Raspberry Pi Zero 2 WH](https://www.adafruit.com/product/6008)
  - Non-WiFi versions will also work, but SSH will make things easier
  - The pre-soldered header is nice to have, but not required
  - Any other Raspberry Pi (except for the Pico) should also work
  - Other SBCs should also work, but you may  need to modify the provided
  scripts
- A Micro SD card for the Raspberry Pi's OS
- A computer to program the Micro SD card
- A [soldering iron](https://pine64.com/product/pinecil-smart-mini-portable-soldering-iron/)
if connecting the Pi to the **[gscartsw]**
- Solder
- [Wire](https://www.amazon.com/TUOFENG-Electronic-Prototyping-Circuits-Breadboarding/dp/B07TX6BX47)
and [Wire Cutters](https://www.amazon.com/SE-JP11A-Flush-Cutter/dp/B0001X0G96)
or [DuPont Connectors](https://www.amazon.com/Hotop-Pack-Single-Header-Connector/dp/B06XR8CV8P)
and [DuPont Wire](https://www.amazon.com/Elegoo-EL-CP-004-Multicolored-Breadboard-arduino/dp/B01EV70C78) for the **[gscartsw]**'s
unpopulated EXT header
<br>(*READ
[this](https://github.com/aaron-clovsky/read_gscartsw?tab=readme-ov-file#notes)
before deciding how to proceed*)
- An [RS-232 to USB cable](https://www.amazon.com/gp/product/B01DYNNUS8)
to interface with the **[HRM-2218F]** (an FTDI chipset is recommended)
- A **[USB Hub]** that can be connected to the Pi
- A [USB-C Y Cable](https://www.amazon.com/dp/B0882Y5RWG) to power the
**[RetroTINK 4K]** and communicate with it over USB at the same time
<br>(make sure to connect the power-only side to the **[RetroTINK 4K]**'s USB-C
power supply)
- A *USB-C Cable* to connect the **[USB Hub]** to the  data side of the
*USB-C Y Cable*
- A *Micro USB* or *USB-C Cable* to power the Pi
- Two **[5v 2A USB PSUs]**

## BUILD INSTRUCTIONS

- Download and install
[Raspberry Pi Imager](https://github.com/raspberrypi/rpi-imager/releases)
(use [this link](https://snapcraft.io/rpi-imager) if on Ubuntu).
- Use Raspberry Pi Imager to install Raspberry Pi OS to a Micro SD card
(I used Debian Bookworm, the latest release as of 1/1/2025).
- Download [ctrl_monoprice_4067.c](https://github.com/aaron-clovsky/ctrl_monoprice_4067/blob/main/ctrl_monoprice_4067.c)
and [Makefile](https://github.com/aaron-clovsky/ctrl_monoprice_4067/blob/main/Makefile)
from [this repo](https://github.com/aaron-clovsky/ctrl_monoprice_4067), and
copy the files to ```/home/pi```, then run the following commands on the Pi:
  - ```cd /home/pi```
  - ```make```
- Download [read_gscartsw.sh](https://github.com/aaron-clovsky/read_gscartsw/blob/main/read_gscartsw.sh)
from [this repo](https://github.com/aaron-clovsky/read_gscartsw)
  - Follow the instructions in [README.md](https://github.com/aaron-clovsky/read_gscartsw/blob/main/README.md)
to connect your gscartsw to your device and edit ```read_gscartsw.sh``` if
required, then copy ```read_gscartsw.sh``` to ```/home/pi``` and run the
following commands on the Pi:
    - ```cd /home/pi```
    - ```chmod +x read_gscartsw.sh```
- Download [rt4k_auto.sh](https://tbd.tbd)
and [rt4k_auto.service](https://tbd.tbd) from this repo, and
copy the files to ```/home/pi```, then run the following commands on the Pi:
  - ```cd /home/pi```
  - ```chmod +x rt4k_auto.sh```
  - ```sudo -s```
  - ```cp rt4k_auto.service /etc/systemd/system```
  - ```systemctl enable rt4k_auto.service```
  - ```systemctl start rt4k_auto.service```
  - ```exit```
- Connect your **[Raspberry Pi]**, **[USB Hub]**, **[RetroTINK 4K]**,
**[gscartsw]**, **[HRM-2218F]** and both **[5v 2A USB PSUs]** as shown below in
the hookup diagram

## HOOKUP DIAGRAM
```
                PWR | <-------- USB Cable --------> [5v 2A USB PSU #1]
[Raspberry Pi] GPIO | <-------- 4x Wires ---------> [gscartsw]
                USB | <-------- USB Cable --------> [USB Hub]

                                 |--- Power ----> [5v 2A USB PSU #2]
          | <----- USB-C Y Cable |--- Data -----> [RetroTINK 4k]
[USB Hub] |
          | <------ USB to RS-232 Adapter ------> [HRM-2218F]
```

## DEBUGGING

Run ```sudo systemctl status rt4k_auto.service``` to view the service's logs

## EXTENDING THIS PROJECT

[rt4k_auto.sh](https://tbd.tbd) is relatively simple to extend, more devices
and more types of devices can be added as needed.
<br><br>
Both
[ctrl_monoprice_4067](https://github.com/aaron-clovsky/ctrl_monoprice_4067)
and [read_gscartsw.sh](https://github.com/aaron-clovsky/read_gscartsw) are
implemented to work the same way:
- Write a single number: \[0-8\] as output to stdout<br>
(all other output goes to stderr)
- 0 indicates: *NO ACTIVE INPUT*, all other values specify an active input
<br><br>
By writing additional programs or scripts that follow this protocol, new
sections can be added to the main loop of [rt4k_auto.sh](https://tbd.tbd). The
only current limitation is that no more than 12 profiles can currently be
selected.

## FUTURE DIRECTIONS

Using the new [SVS Commands](https://consolemods.org/wiki/AV:RetroTINK-4K#HD-15_Serial_Configuration)
would provide more than 12 automatic profile options.

## NOTES

Despite being discontinued, the HRM-2218F was used due to its excellent
MiSTer DirectVideo SPD Infoframe (DV1) compatibility

## License
This software is licensed under the
[MIT License](https://opensource.org/licenses/MIT).
