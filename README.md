# Godot-Gesture-Recognition-Magic-System
An extension of Minananami's Gesture Recognizer plugin that sets up a scene with an easily usable multi-glyph magic system. This repository contains two options: One with a player character and one without.  

Draw spells directly to the screen and have them recognized using a template based gesture recognition algorithm. Pressing left click starts drawing a spell and pressing right click attempts to cast it.

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

A major goal of this project was to streamline the creation of spells. Several examples of spells can be seen in game as well to aid this explanation. To create a new spell, create a new script and have it extend SpellResource. That script must then implement the cast function. The arguments of the cast function depend on whether the player or playerless version is being used. In the player version, the cas function takes in as parameters a CharacterBody2D (representing the player), a Vector2 (representing the location), a float (representing spell power), a float (representing duration boost), and a string (which can be used to implement any aditional spell modifiers). In the playerless version, the cast function is identicial except that the CharacterBody2D is replaced with a Node2D representing the root node of the scene.  

If you want the spell to have a cooldown, all operations inside the cast function must be inside of an if statement checking the SpellResource variable ready_to_cast. The cooldown functionality is already implemented, and the duration of the cooldown can be edited once a resource is created for the spell.  

Next, create a new resource that uses the newly created script. With the current structure of this project, this resource must be placed inside the spells folder, although this can easily be changed with edits to the SpellManager script. If you want this spell to be immediately accessible, add it into SpellManager as a dictionary entry such that the key is the spell name and the value is the preloaded spell resource.  

Then, use the plugin UI panel to draw what you want the spell to look like. Press add spell and enter the exact name used in the dictionary entry. Multiple templates can be added under the same spell to increase accuracy.

## Other Spell Features

Many properties of a spell can be directly changed in the editor panel associated with that spell's resource, such as whether it is a castable spell or a multi-cast buff, or the spell's cooldown.

Another technique that can be used is demonstrated in the ShrinkToggle spell. The cast function of a spell can create a temporary node and attach it to an object (in this case the player). This is useful for implementing spells with durations because you simply need to attach a timer to the new node and implement a revert function when the timer expires.

### Making Multi Symbol Spells
To make a spell require multiple gestures, make only the final gesture castable in the resource and all the other ones not castable. Then, inside of the spell dictionary, instead make the value associated with the preliminary syumbols a new dictionary. So you will have a chain of dictionaries that eventually ends in a castable spell.
