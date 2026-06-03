# Godot-Gesture-Recognition-Magic-System
An extension of Minananami's Gesture Recognizer plugin that sets up a scene with an easily usable multi-glyph magic system. This repository contains two options: One with a player character and one without.  

Draw spells directly to the screen and have them recognized using a point cloud gesture recognition algorithm. Pressing left click starts drawing a spell and pressing right click attempts to cast it.

The original repository can be found here: https://github.com/Minananami/Multistroke-Gesture-Recognizer-Plugin-for-Godot-Engine

## Setting Up
Place the Gesture_recognizer folder into a folder called addons inside of your godot project
Enable the pluggin in Project Settings->Plugins  
The plugin interface should appear on the left side of the editor  

The interface allows you to draw gestures and save them to be recognized for later. You may also save multiple templates to a single gesture for improved accuracy.  
When naming a new gesture, you must give it the exact name of the spell you would like it to correspond to. More about this later.  

If you would like your game to have a player character who is the "caster" of the spells, open the PlayerVersion folder and drag the spells and scripts folders into your project.  
Then, open up main.tscn to open the example scene, showing the structure of a game using this system. The difference between this and the non-player version is that spell signals  
carry a 'caster' attribute, which is assigned to the player by default. This is useful for wizard games where spells can directly affect the player character. in this example, drawing an upwards facing arrow activates the "jump" spell and drawing a Z activates the boost spell, which will boos the height of your jump.

If you would like your game to not have a player character, open the NonPlayerVersion folder and drag the spells and scripts folders into your project. Then, open main.tscn to open a blank project. The main difference between this and the player version is that the spell signal carries a main_node parameter for accessing the root node of the tree. This is useful for games without a main character, for example a spell crafting game. In this example scene, drawing a circle will activate the spawn_block spell, which spawns a gray rectangle at the mouse's position at the moment of casting.

## Creating New Spells
