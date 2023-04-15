# __Plasma Computer__

Computer and OS in Plasma

- Plasma Computer is a computer that can run an OS and interact with the world.
- Plasma OS is integrated by default but if you want to update the computer with a new version of Plasma OS or your custom OS you will have to use the devices below
- For a custom OS you can use Plasma OS as a base and read the code to understand how it works.

_Note: If you detect any bugs, please report them._

---

## Devices

### Computer

STEAM ID: __2962708844__\
The computer is the main device, it is used to run programs and interact with the world, there is two version: laptop and desktop.

__how to use :__

1. Turn On.
2. Enyoy the result.

### Disks

Disks are used to store programs and data. They are used by the Wireless Disk Reader to load OS, software and data.

__how to use :__

1. Create a "NFC TAG" and put data if you want.

### Wireless Disk Reader

STEAM ID: __2962710912__\
The Wireless Disk Reader is used to read and write data on disks.

__how to use :__

1. Place a Disk on it.
2. To load an OS, press the button on it.

### Plasma OS

STEAM ID: __2960539673__\
The Plasma OS is the operating system of the Plasma computer.

__how to use :__

1. Type "help" on the terminal to get the list of commands.

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

__Keyboard__ :
Use "V1" to get the key pressed.
Split the string with the __!§!__ separator to get the key pressed.
[1] = Key pressed or type, [2] = Key char or nil.

"V1" type: String

```lua
function keyboardEvent()
    -- Called when a key is pressed
end
```
  
__Network__ :
Use "V2" to get data from network.

"V1" type: Any

```lua
function networkEvent()
    -- Called when data arrives from the network
end
```

__Disk__ :
Use "V3" to get data from the disk.

"V1" type: Any

```lua
function readDiskEvent()
    -- Called when data from the disk is readed
end
```

To request the read of the disk use :

```lua
output(nil, 3)
```

__Memory__ :
Use "V4" to get data from the internal memory.

```lua
function readMemoryEvent()
    -- Called when data from the internal memory is readed
end
```

To request the read of the internal memory use :

```lua
output(nil, 5)
```

### Outputs

__Display__ :
To display text on the screen.

Data: String

Data examples :

- "Hello world"
- "Hello world!§!Line 2", Lines are separated by the __!§!__ separator
- "0,0,0!display§!Hello world!§!Line 2" , The first part is the background color with r,g,b, the second part is the text. Two are separated by the __!display§!__ separator.

```lua
output(data, 1)
```

__Network__ :
To send data to the network.

Data: Any

```lua
output(data, 2)
```

__Disk__ :
To write data to the disk.

Data: Any

```lua
output(data, 4)
```

__Memory__ :
To write data to the internal memory.

Data: Any

```lua
output(data, 6)
```

__Keyboard__ :
To set the color of the keyboard keys or indicator.

Data: Color

Data examples :

- color(0,0,0)
- color (255, 0, 0)

```lua
output(data, 7) -- To set the color of the keyboard indicator
```

```lua
output(data, 8) -- To set the color of the keyboard keys
```