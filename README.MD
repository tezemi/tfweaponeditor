# TF Weapon Editor

TF Weapon Editor is a [SourceMod](https://www.sourcemod.net/) server plugin designed for developers. It was made to streamline the process of rebalancing weapons, by allowing developers to load weapon configuration files that redefine a weapons attributes, and allows developers to hook into certain weapon-specific callbacks to aid in modularization and code readability.



## Requirements

These are required on your server before you can use or develop with TF Weapon Editor:

- #### [SouceMod](https://www.sourcemod.net/index.php)

- #### [Metamod](https://www.sourcemm.net/)

- #### [tf2items](https://builds.limetech.io/?p=tf2items)

- #### [TF2Attributes](https://forums.alliedmods.net/showthread.php?t=210221)



## Usage

If you are not a developer, then you don't need to be concerned with this section. TF Weapon Editor works by loading configuration files that contain information about weapons that already exist in-game. If you want to design custom weapons, the check out [Custom Weapons 3](https://forums.alliedmods.net/showthread.php?t=285258). When a config file is loaded, it can several things:

- Add new attributes.
- Edit existing ones.
- Hook into weapon-specific calls, so you can easily script custom behavior that can't be handled with attributes.

This process is designed so players can use their old weapons, that might be strange or have skins, and still play with rebalanced mechanics.



