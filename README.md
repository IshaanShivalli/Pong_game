# Pong Game (LÖVE2D)

A simple Pong game built using **Lua** and the **LÖVE2D** framework.
Includes basic gameplay, AI opponent, sound effects, and game states.

---

## Features

* Player vs AI gameplay
* Smooth paddle movement
* Ball physics with collision detection
* Sound effects (paddle, wall, scoring)
* Game states: Start → Serve → Play → End
* Score tracking with win condition

---

## Controls

| Key      | Action                  |
| -------- | ----------------------- |
| `W`      | Move paddle up          |
| `S`      | Move paddle down        |
| `Enter`  | Start / Serve / Restart |
| `Escape` | Quit game               |

---

## Game Logic

* First player to reach **10 points** wins
* Ball direction depends on serving player
* AI tracks ball with slight randomness
* Ball speed increases after paddle hits

## Requirements

* LÖVE2D (version 11.x recommended)

Download: https://love2d.org/

---

## How to Run

1. Install LÖVE2D
2. Download or clone this project
3. Run using one of the following:

### Option 1:

Drag the project folder onto the LÖVE executable

### Option 2:

```bash
love .
```

### Option 3:
```
& "C:/Program Files/LOVE/love.exe" .
```

## License

This project is for learning purposes. Feel free to modify and expand.

---

## Author

Created by Ishaan Shivalli
