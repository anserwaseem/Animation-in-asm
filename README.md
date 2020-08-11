# Animation-in-asm

### PART1:
Animation of infinite length with following requirements:
- [Objects’ Printing] Image will have following objects:
- Sky
- Three Mountains (one print triangle function called three times with different coordinates)
- A Road
- Any object on the road
- A River having at least one fish
- [Objects’ Movements] You have to move the background leftward and foreground rightward, giving an impression that object on road is moving ahead. The fish has to move constantly left to right and right to left in middle 40 columns of your video memory in river.
- For 5 seconds there should be daytime and next 5 seconds will be nighttime in a loop.
  
### PART2:
  Add new feature “Welcome Screen” with following requirements:
- Upon entering “animation.com” on DOSBOX, user should be asked to enter his name.
- After getting user name, a formal welcome screen should appear showing following information:
Welcome Abc Xyz,
Instructions for animation are as follows:
- Some dummy instruction
- Some dummy instruction
- Press Enter to Continue and Esc to Exit
Note: Assume user entered name “Abc Xyz”.
- If user enters Esc, exit the application
- If user presses Enter, Continue with your main window i.e. the functionality of part 1.
  
### PART3:
  Add new feature “Car Jump and Background Music” with following requirements:
- During the execution of your animation, if user presses ESC, your game should terminate.
- If user presses ↑ key (up key): 
- Your car will move one cell upward (keep the forward movement as it is) and it will come back at it normal position as soon as user releases the key.
  • On releasing the key, car comes back to its original position.
- A background music should be played as long as the key is pressed.
