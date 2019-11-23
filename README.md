# Firmware for Micronucleus
Since the [micronucleus repository](https://github.com/micronucleus/micronucleus) seems to be abandoned, I forked the firmware part and try to add all improvements and bug fixes I am aware of.<br/>
To make the code better understandable, I **added around 50 comment lines**.

You can easily build your own configuration by adding a new configuration directory and adjusting the arduino binaries path in the `firmware/SetPath.cmd` file.

## This repository contains an avrdude config file in `windows_exe` with **ATtiny87** and **ATtiny167** data added.

## Driver installation
For Windows you must install the **Digispark driver** before you can program the board. Download it [here](https://github.com/digistump/DigistumpArduino/releases/download/1.6.7/Digistump.Drivers.zip), open it and run `InstallDrivers.exe`.

## `START_WITHOUT_PULLUP` and `ENTRY_POWER_ON` configuration flags
The `START_WITHOUT_PULLUP` configurations adds an an additional check and specify `ENTRY_POWER_ON` as entrymode giving a bootloader size of 1626 bytes for an ATtiny85.
This configuration only adds 16 to 18 bytes for an additional check (contained by default in all pre 2.0 versions) and can therefore also be used for boards with a pullup.
ENTRY_POWER_ON adds 18 bytes to the ATtiny85 default configuration, but is what you normally need if you use a Digispark board, since it is programmed by attaching to the USB port resulting in power up.

# Memory footprint
The actual memory footprint for each configuration can be found in the file [*firmware/build.log*](https://github.com/ArminJo/micronucleus-firmware/blob/master/firmware/build.log).<br/>
Bytes used by the mironucleus bootloader can be computed by taking the data size value in *build.log*, 
and rounding it up to the next multiple of the page size which is e.g. 64 bytes for ATtiny85.<br/>
Subtracting this (+ 6 byte for postscript) from the total amount of memory will result in the free bytes numbers.
- Postscript are the few bytes at the end of programmable memory which store tinyVectors.

E.g. for *t85_default.hex* with the new compiler we get 1592 as data size. The next multiple of 64 is 1600 (25 * 64) => (8192 - (1600 + 6)) = 6586.<br/>
In this case we have 8 bytes left for configuration extensions before using another 64 byte page.
So the `START_WITHOUT_PULLUP` and `ENTRY_POWER_ON` configurations are reducing the free bytes amount by 64.

## Bootloader memory comparison of different releases for [*t85_default.hex*](https://github.com/ArminJo/micronucleus-firmware/blob/master/firmware/releases/t85_default.hex).
- V1.6  6012 Byte free
- V1.11 6330 Byte free
- V2.3  6522 Byte free
- V2.4  6586 Byte free (6522 for all other t85 variants)

# Revision History
### Version 2.4
- ATtiny167 support with MCUSR bug/problem at `ENTRY_EXT_RESET` workaround.
- `MCUSR` handling improved.
- no_pullup targets for low energy applications forever loop fixed.
- `USB_CFG_PULLUP_IOPORTNAME` disconnect bug fixed.
- new `ENTRY_POWER_ON` configuration switch, which enables the program to start immediately after a reset.
