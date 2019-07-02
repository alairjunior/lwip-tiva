# lwip-tiva

This is a port of lwIP 2.1.2 to the Texas Instruments TM4C1294NCPDT microcontroller. The goal is to offer a project that can compile without modifying any of the source codes provided in lwIP nor the Tivaware driver library. 

----

# Platform

We are using the EK-TM4C1294XL to implement and test the port. If you are using another platform, you may be required to change some files in order to get the port to work.

----

# Development Environment Setup

We are using Ubuntu 16.04 in the development environment and the following instructions were executed only for this enviroment.


## Required Packages


If you are in a **64 bit system**, you have to first execute:

```
sudo dpkg --add-architecture i386
```

Then, **for all systems**, execute:

```
sudo apt-get update
sudo apt-get install flex bison libgmp3-dev libmpfr-dev \
    libncurses5-dev libmpc-dev autoconf texinfo build-essential \
    libftdi-dev python-yaml zlib1g-dev libtool
```

Then again, just for **64 bit architectures**, execute:

```
sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386
```

And for **all systems**, to flash using USB, you need to install libusb as follows:

```
sudo apt-get install libusb-1.0-0 libusb-1.0-0-dev
```

### Cross Compiler

We need a cross-compiler to compile the code to the target ARM processor. We are
going to use the [GNU Arm Embedded Toolchain](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm).
The version used in this case study is **8-2018-q4-major**. You can download it from
[here](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads).

Extract the content of the archive to the folder where you want to store
the toolchain. We are going to assume that it is going to be extracted
to `~/embedded`.

```
mkdir ~/embedded
tar -xvf gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2 -C ~/embedded
export PATH=$PATH:$HOME/embedded/gcc-arm-none-eabi-8-2018-q4-major/bin
```

You probably would like to add the last line to your `~/.bashrc` so you don't
need to execute it every time.

### Flashing Tool

To flash the MCU we are going to use [lm4tools](https://github.com/utzig/lm4tools):

```
cd ~/embedded
git clone git://github.com/utzig/lm4tools.git
cd lm4tools/lm4flash/
make
export PATH=$PATH:$HOME/embedded/lm4tools/lm4flash
```

You probably would like to add the last line to your `~/.bashrc` so you don't
need to execute it every time.

### Udev Rules

Download `` from [here](https://gist.github.com/alairjunior/a172fc07e102cb84976e3587108e1fd1)
and execute the following command.

```
sudo cp 71-ti-permissions.rules /etc/udev/rules.d/
```

You will need to unplug the board and restart `udev` in order to the changes to take place:

```
sudo udevadm control --reload-rules && udevadm trigger
```

### Tivaware

Texas Instruments provides a set of resources for the Tiva C MCU family and we are
going to use it to make it simple to configure the MCU. You can get Tivaware
for free [here](http://www.ti.com/tool/sw-tm4c). When writing this tutorial, the
available version of Tivaware was **2.1.4.178**. To setup Tivaware, use the following:

```
cd ~/embedded
mkdir tivaware
cd tivaware/
mv ~/Downloads/SW-TM4C-2.1.4.178.exe . 
unzip SW-TM4C-2.1.4.178.exe
make
```

After executing `make` you will probably stumble on a problem with one or more of the `.ld`
files. If the command issue an error like `arm-none-eabi-ld: section .ARM.exidx overlaps section .data`, you must edit the corresponding `.ld` file (probably from qs-logger example) and change the start of the `.data` section. You can do this by finding the following line:

```
.data : AT(ADDR(.text) + SIZEOF(.text))
```

and replacing it by:

```
.data : AT(ADDR(.text) + SIZEOF(.text) + SIZEOF(.ARM.exidx))
```

Compile again using `make`. This change should settle the problem. 