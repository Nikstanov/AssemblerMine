# TinyMinecraft

## Description

TinyMinecraft is a small-scale project written in FASM (Flat Assembler), utilizing OpenGL and WinAPI to create a simplified version of Minecraft. This application allows users to place and delete blocks, customize block colors, toggle between game modes, and save/load their creations.

## Features

1. **Block Placement and Deletion:** Users can interactively place and delete blocks in specific locations within the game environment.

2. **Block Color Customization:** Pressing the 'E' key opens a menu, allowing users to change the color of the selected block using arrow keys.

3. **Game Modes:** Toggle between different game modes by pressing the 'R' key. Modes include a standard mode and a fly mode, providing the ability to navigate freely.

4. **Save and Load Functionality:** Save your creations by pressing 'F9', creating a save file named 'save0' in the game directory. Load a save using 'F11'.

## Project Structure

- The project is written in FASM, utilizing WinAPI for window creation and OpenGL for 3D graphics rendering.
- Input handling captures key presses ('E', 'R', 'F9', 'F11') for various functionalities.
- The main loop manages game logic, rendering, and user input.
- Save and load functionality involves reading and writing to a save file ('save0') in the game directory.

## Building and Running

- Compilation is done using FASM. Ensure dependencies, including FASM, OpenGL, and WinAPI, are properly set up.
- Execute the compiled binary to launch TinyMinecraft.

## Note

This project, authored by Nikstanov, is a learning exercise and a demonstration of basic graphics programming using FASM, OpenGL, and WinAPI. It serves as a foundation for further exploration and development.

