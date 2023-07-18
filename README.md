# flycast-scripts
Lua Scripts for Flycast, particularly for Sonic Adventure.

# Installation
Place these files in your Flycast config folder (probably `flycast/`), next to `emu.cfg`.
In Flycast, go to `Settings > Advanced > Lua Scripting` and set the filename to a script, then restart your emulator.

# Scripts

## SACX
Short for Sonic Adventure "Cutscene Cut" (even though DX stands for Deluxe, wasn't my idea), this is a port of Codebreaker codes used to skip cutscenes in SA1. Also included are optional codes to enable skipping Sky Chase and Chaos 4, dubbed "Fast SA1".

### Usage
SACX works for all major versions of SA1 (JP 1.0, US 1.0, US 1.1, PAL, and JP International), and detects your game version automatically.
When launched, CX will be enabled by default (press Start to skip cutscenes), and the level skips (Sky Chase, Chaos 4) will be disabled.

To toggle settings, a window should appear in the upper left corner of the screen with the options available.
Click `Hide Window` to close the window. Once the window is closed you may re-open it by pressing your controller's `C` button (this can be bound in Settings).

### Credits
While the script is of my own making, the original CX codes were written by [Speeps](https://speeps-highway.tumblr.com/post/163805669335/cutscene-skip-for-sa1-dc), and the Fast SA1 codes were written by [SQeefy](https://twitch.tv/sqeefy).

## Codebreaker
Flycast's built-in cheat system can be restrictive, as it uses the Retroarch cheat format that lacks several features that older cheat tools had. This script emulates the features of Codebreaker, and can run any unencrypted cheat codes written for it.

### Installation
The Codebreaker script requires two lua files, `codebreaker.lua` and `codes.lua`. The first should be loaded by Flycast in settings, and the codes file should be located in the same folder. A template `codes.lua` file has been provided, with a few cheats for Sonic Adventure pre-loaded.

### Usage
When a game is launched, a window should appear in the upper left corner of the screen showing the available cheat codes, if any are loaded. Click the buttons to enable and disable them. Similar to SACX, the final button allows you to hide the window from your screen. Should you do so, press the controller's `C` button to re-open the menu.
If the `codes.lua` file is updated, you may press the `Reload Codes` button to refresh.

### Adding new codes
Follow the layout shown in `codes.lua` to add new codes. The codes are structured such that:
- The top level identifier is the game's ID and Version number string.
  - To find this string, launch the game with Codebreaker loaded and it will appear at the top of the window.
  - This string is always 16 characters long. If you're having trouble getting a game to appear, make sure there's enough spaces between the ID and Version number to be 16 characters total.
- `name` is an optional string to identify the game. This appears in the Codebreaker window to show that the codes have been loaded.
- Codes are arrays of hexadecimal words. Their identifier is the name that will be used to display the code.
  - When copying codes into `codes.lua`, each value must be prefixed by `0x` and separated by commas.
  - The line breaks are just for visual clarity, and only the commas are necessary to separate each value. Be aware that some codes use three words for one line, so if you have an odd number of values it doesn't necessarily mean the code is broken.

If `codes.lua` fails to load after making changes, make sure to double-check all your commas, brackets, and quotes. If anything is missing or malformed the entire list will fail to load.

## SA1 Trainer
Still under development, this script will give useful tools for working with Sonic Adventure. Currently its feature include:
- Respawn: instantly respawn your character, useful for skipping cutscenes
- Clear level: Instantly exits the current level and progresses the story.
- Level select: Activates the debug level select.
  - Changing levels is prone to crashes or undesired behavior, I recommend resetting first and activating this from the title screen.
  - Level names are only visible on JP 1.0, but the menu is still fully functional on all versions.
- Free movement: Enables debug flight.
  - Only Sonic, Knuckles, and Amy have access to debug flight.
