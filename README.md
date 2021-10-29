# Retroverse

### By Tony Lukasavage, aka BloodSweatAndCode

An ambitious attempt to create NES combo world randos with an arbitrary number of games.

## Patch format

Patches can be a single python file or a directory containing a `patch.py` file as its entry point.

### Single File Patch Format

The python file should share the same name as the patch. For example, a patch named `mycoolpatch` should be contained in a file called `mycoolpatch.py`. The file has 2 requirements

1. A function named `execute(data)`, where the `data` parameter is a reference to a `bytearray` containing the ROM data on which you are hacking.
2. a `patch` dictionary containing the following properties:
	* `name` - The name of the patch
	* `desc` - A brief description of the patch
	* `deps` - A list of patch names upon which this patch relies. Those patches will be executed _before_ this patch.
	* `execute` - A reference to the `execute(data)` function, #1 in the list list.

Here's a simple annotated example for Castlevania 2, used only in testing:

```
def execute(data):
	# This list of hex values represents the letter "Z" on the CV2 title screen
	bytes = [0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A]

	# The loc variable represents the location in the ROM data to which we are going
	* to write the above bytes
    	loc = 0x0101A2

	# Write the bytes to the location
	data[loc: loc + len(bytes)] = bytes


patch = {
	'name': 'Z\'s',
	'desc': 'Write a bunch of Z\'s to the title screen',
	'deps': [],
	'execute': execute
}
```
