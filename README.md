# Plasma Computer
Computer Core and OS in Plasma Sandbox

Note: This is a work in progress and is not finished yet. If you detect any bugs, please report them.

# How to use the computer
1. Turn On.
2. Place the Plasma OS Disk or yours on the Disk reader.
3. Press the button of the Disk reader, 4. Enyoy the result.

### Disks:
Disks are used to store programs and data. They are used by the Disk Reader to load programs and data. If you want to create one, place a "NFC TAG" and put data if you want.

### OS :
If you want to create your own OS, you can use the Plasma OS as a base. You can find it in the "OS" folder and read the API below.

# Code

## Core
### What is it ?
The Core consists of all the lua files used by the Plasma computer.

#### Disk Reader :
The disk reader is a program that reads the disk and loads programs into the computer and also reads and writes to disks.

#### Display Lines :
The Display Lines is a program that display lines of text on the screen and change the background color of it.

#### Network Emiter :
The Network Emiter is a program that sends and receive data from the network.

#### Load World :
The Load World is a program that emit a signal when the world is loaded.

## OS
### What is it ?
The OS is the operating system of the Plasma computer. It can use the Core to do things.

# API :