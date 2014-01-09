StringEmitter
====

This early game prototype lets one travel around a small level by extending up to 3 springy strings in any direction.

The code is object oriented with many small object files that make up the game and one large file DC.as that does the work of placing all objects for the three different sample levels in the game. The code in DC could have been made much more modular, I admit this was an early project. A Level class, a Collision_controller class, and an Input_controller class could have been created for an easier application of such a monstrous file, and is something that could improve the readability of the project as a whole. For now, it works, even if DC.as is a more naive approach 

I'm sure we all look at our older code and realize how much we have learned, especially in 3 years.

    Controls:
    
    Point and click where you would like to emit a string.
    Hold down left "ctrl" and point to a red highlighted string and click to delete that string(down to a minimum of 1)
    

