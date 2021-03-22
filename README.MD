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

## Config Example Walkthrough

```json
"the_shortstop"
{
	"enabled"           	"false"
	"base_weapon"			"220" 
	"description"			"The Shortstop: + It fires in spurts. - No downsides."
    "mod_attributes"
	{
		"clip size penalty"
        {
			"value"		"0.5"
        }
	}
	"add_attributes"
	{
		"provide on active"
        {
			"value"		"1"
        }
        "healing received bonus"
		{
			"value"		"3"
		}
		"weapon spread bonus"
		{
			"value"		".1"
		}
		"fire rate penalty"
		{
			"value"		"0.25"
		}
	}
}

```

Each config file is automatically searched for when placed in the proper directory. The name of the file is arbitrary, but should ultimately reflect the name of the weapon being changed.

1. `"the_shortstop"` - The name of the weapon in the config file is used for debugging. This does not effect the weapon in any way.
2. `"enabled"` - This it an optional field. Add it and set it to false to disable the config file. Otherwise, omit this field.
3. `"base_weapon"` - Probably the most important field, this is the ID of the weapon you're editing. A list of weapon IDs can be found [here](https://wiki.alliedmods.net/Team_fortress_2_item_definition_indexes#PDA_.5BSlot_3.5D).
4. `"description"` - An optional description of what the weapon's stats are, what the changes are, etc.
5. `"mod_attributes"` - This modifies an attribute that already exists on a weapon. Unfortunately, it is impossible to remove attributes from weapons, so the normal use of this field is to remove an attribute by changing its value to something that would negate it.
6. `"add_attributes"` - This adds a new attribute to a weapon. A list of attributes can be found [here](https://wiki.teamfortress.com/wiki/List_of_item_attributes).



