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

---

## __Code__

1. Devices code is in the "Devices" folder.
2. Plasma OS code is in the "OS" folder.
3. OS example is in the "OS" folder.
4. Software example is in the "Software" folder.

---

## __Computer API__

### _Note: don't send image in the Main Transceiver channel 2, this will reduces FPS_

### __Inputs :__

__Keyboard__ :
Use "V1" to get the key pressed.
Split the string with the __!§!__ separator to get the key pressed.\
[1] = Key pressed or type, [2] = Key char or nil.

"V1" type: String

```lua
function keyboardEvent()
    -- Called when a key is pressed
    print(V1)
end
```
  
__Network__ :
Use "V2" to get data from network.

"V2" type: String

```lua
function networkEvent()
    -- Called when data arrives from the network
    print(V2) -- Error if V2 not a string
end
```

__Disk__ :
Use "V3" to get data from the disk.

"V3" type: Any

```lua
function readDiskEvent()
    -- Called when data from the disk is readed
    print(V3) -- Error if V3 not a string
end
```

To request the read of the disk use :

```lua
output(nil, 3)
```

__Memory__ :

To read the internal memory use :

```lua
read_var("memory")
```

__OS__ :

To read the current OS :

```lua
read_var("os")
```

### __Outputs:__

__Display__ :\
To display text on the screen.

Data type : String

Data examples :

- "Hello world"
- "Hello world!§!Line 2", Lines are separated by the __!§!__ separator
- "0,0,0!display§!Hello world!§!Line 2" , The first part is the background color with r,g,b, the second part is the text. Two are separated by the __!display§!__ separator.

```lua
output(data, 1)
```

__Network__ :\
To send data to the network.

Data: Any

```lua
output(data, 2)
```

__Disk__ :\
To write data to the disk.

Data: Any

```lua
output(data, 4)
```

__Memory__ :\
To write data to the internal memory.

Data: String

```lua
write_var(data, "memory")
```

__OS__ :\
To update the current OS and reboot the computer.

```lua
output(nil, 5)
```

__Display override__ :

To enable the display override.

Data: Boolean

```lua
write_var(data, "override")
```

___To display an image on the screen send a signal on the Main Transceiver channel 3 with the image or another data.___

__Keyboard Indicator Color__ :\
To set the color of the keyboard indicator.

Data: Color

Data examples :

- color(0,0,0)
- color (255, 0, 0)

```lua
output(data, 6) -- To set the color of the keyboard indicator
```

__Display Override__ :\
To override the display.\
Make sure you dont output on the Display output 1.

Data: any

```lua
output(data, 7)
```

---

## __Plasma OS Software API__

To create a software for the Plasma OS.\
Use the "Software" folder as a base and replace all the values with your own.\
To load the software put the data in a disk, put on the Wireless Disk Reader and execute "software install" on the terminal.

put this on the top of the software code to make it work and replace the values with your own:

```lua
--!soft§!
--SOFTWARE_NAME!soft_data§!
```

### DATA

Put this in your software code to add information about it and replace the values with your own:

```lua
SOFTWARES["SOFTWARE_NAME"] = {
  ["version"] = "1.0.0",
  ["author"] = "shazogg",
  ["description"] = "DESCRIPTION",
  ["events"] = {
    {
      ["event"] = "KEYBOARD_INPUT",
      ["function"] = example1
    },
    {
      ["event"] = "NETWORK_INPUT",
      ["function"] = example2
    },
  }
}
```

### EVENTS

Events are used to make the software interact with Plasma OS.\
You can add events to your software by adding event in the "events" table in the data above.

__EVENTS LIST :__

- __"KEYBOARD_INPUT"__: On Keyboard input
- __"NETWORK_INPUT"__: On Network input
- __"DISK_INPUT"__: On Disk input
- __"SETUP"__: On Setup
- __"LOOP"__: On Loop

### HELP PAGES

```lua
to add pages to the help command, add this to the software code and replace the values with your own:

```lua
SOFTWARES_HELP_PAGES["SOFTWARE_NAME"] = {
  {
    "example software, page 1",
    "- example2: to test this too, page 1"
  },
  {
    "example software, page 2",
    "- example2: to test this too"
  }
}
```

### INTERNAL FUNCTIONS

You can access all the variables and functions inside Plasma OS, to use outputs read the "Computer API" section above.
