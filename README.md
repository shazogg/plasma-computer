# __Plasma Computer__

Computer Core and OS in Plasma Sandbox

_Note: This is a work in progress and is not finished yet. If you detect any bugs, please report them._

## How to use the computer

1. Turn On.
2. Place the Plasma OS Disk or yours on the Disk reader.
3. Press the button of the Disk reader.
4. Enyoy the result.

### Disks

Disks are used to store programs and data. They are used by the Disk Reader to load programs and data. If you want to create one, place a "NFC TAG" and put data if you want.

### Operating System

If you want to create your own OS, you can use the Plasma OS as a base. You can find it in the "OS" folder and read the API below.

## __Code__

## Core

The Core consists of all the lua files used by the Plasma computer.

### Disk Reader

The disk reader is a program that reads the disk and loads programs into the computer and also reads and writes to disks.

### Display Lines

The Display Lines is a program that display lines of text on the screen and change the background color of it.

### Network Emiter

The Network Emiter is a program that sends and receive data from the network.

### Load World

The Load World is a program that emit a signal when the world is loaded.

## OS

The OS is the operating system of the Plasma computer. It can use the Core to do things.

## __API__

### Inputs

Keyboard :
Use "V1" to get the key pressed.
Split the string with the __!§!__ separator to get the key pressed.
[1] = Key pressed or type, [2] = Key char or nil.

```lua
function keyboardEvent()
    -- Called when a key is pressed
end
```
  
Network :
Use "V2" to get data from network.

```lua
function networkEvent()
    -- Called when data arrives from the network
end
```

Disk :
Use "V3" To get data from the disk.

```lua
function readDiskEvent()
    -- Called when data from the disk is readed
end
```
To request the read of the disk use :
```lua
output(nil, 3)
```
