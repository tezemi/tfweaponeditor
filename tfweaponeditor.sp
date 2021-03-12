#pragma semicolon 1

#include <tf2>
#include <cw3>
#include <menus>
#include <files>
#include <tf2items>
#include <tf2_stocks>
#include <tf2wearables>
#include <tf2attributes>
#include <cw3-attributes>

#define DEFAULT_STRING_SIZE 64

public Plugin:myinfo = 
{
	name = "TF Weapon Editor",
	author = "Tezemi",
	description = "For rebalancing weapons.",
	version = "0.1",
	url = ""
};

public void OnPluginStart()
{
    HookEvent("post_inventory_application", OnPlayerRefreshed);    
}

public Action OnPlayerRefreshed(Event event, const char[] name, bool dontBroadcast)
{
    int userID = event.GetInt("userid");                                  
    int clientID = GetClientOfUserId(userID);
 
    if (!ClientIsValid(clientID))
    {
        return Plugin_Continue;
    }

    int activeWeaponEID = GetEntPropEnt(clientID, Prop_Send, "m_hActiveWeapon");

    if (!IsValidEntity(activeWeaponEID))
    {
        return Plugin_Continue;
    }

    //
    //  Get Primary Weapon
    //
    int primarySlotIDI = -1;
    int primarySlotEID = TF2_GetPlayerLoadoutSlot(clientID, TF2LoadoutSlot_Primary);
    if (primarySlotEID != -1)
    {
        primarySlotIDI = GetEntProp(primarySlotEID, Prop_Send, "m_iItemDefinitionIndex");
    }

    //
    //  Get Secondary Weapon
    //
    int secondarySlotIDI = -1;
    int secondarySlotEID = TF2_GetPlayerLoadoutSlot(clientID, TF2LoadoutSlot_Secondary);
    if (secondarySlotEID != -1)
    {
        secondarySlotIDI = GetEntProp(secondarySlotEID, Prop_Send, "m_iItemDefinitionIndex");
    }

    //
    //  Get Melee Weapon
    //
    int meleeSlotIDI = -1;
    int meleeSlotEID = TF2_GetPlayerLoadoutSlot(clientID, TF2LoadoutSlot_Melee);
    if (meleeSlotEID != -1)
    {
        meleeSlotIDI = GetEntProp(meleeSlotEID, Prop_Send, "m_iItemDefinitionIndex");
    }

    //
    //  TODO: Get other slots
    //
    
    char dir[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, dir, sizeof(dir), "scripting/tfweaponeditor/configs");

    if (!DirExists(dir))
    {
        SetFailState("There is no configs/tfweaponeditor directory. Create a folder in configs called tfweaponeditor to fix.");

        return Plugin_Continue;
    }

    FileType type;
    char file[PLATFORM_MAX_PATH];
    Handle openedDir = OpenDirectory(dir, false, NULL_STRING);

    while (ReadDirEntry(openedDir, file, sizeof(file), type))
    {
        if (type != FileType_File)
        {
            continue;
        } 

        Format(file, sizeof(file), "%s/%s", dir, file);

        Handle KVPs = CreateKeyValues("");

        if (!FileToKeyValues(KVPs, file))
		{
			PrintToServer("[TF Constructor] Could not parse '%s'. File won't be loaded.", dir);
			CloseHandle(KVPs);

			continue;
		}

        bool loaded_weapon = false;
        int weaponID = KvGetNum(KVPs, "base_weapon", 0);
        if (primarySlotIDI == weaponID)
        {
            ApplyWeaponConfig(KVPs, primarySlotEID);
            loaded_weapon = true;
        }
        else if (secondarySlotIDI == weaponID)
        {
            ApplyWeaponConfig(KVPs, secondarySlotEID);
            loaded_weapon = true;
        }
        else if (meleeSlotIDI == weaponID)
        {
            ApplyWeaponConfig(KVPs, meleeSlotEID);
            loaded_weapon = true;
        }

        if (loaded_weapon)
        {
            char weapon_desc[DEFAULT_STRING_SIZE];
            KvGetString(KVPs, "description", weapon_desc, sizeof(weapon_desc), "");
            if (strcmp(weapon_desc, "", false) != 0)
            {
                PrintToChat(clientID, weapon_desc);
            }
        }

        CloseHandle(KVPs);  
    }

    CloseHandle(openedDir);

    /*
    
    */
    
    return Plugin_Continue;
}

static bool ClientIsValid(int clientID)
{
    if (clientID >= 0 && clientID <= MaxClients && IsClientInGame(clientID))
    {      
        return true;
    }

    return false;
}

static void ApplyWeaponConfig(Handle KVPs, int weaponEID)
{
    ApplyAttributesFromKey(KVPs, "mod_attributes", weaponEID);
    ApplyAttributesFromKey(KVPs, "add_attributes", weaponEID);
}

static void ApplyAttributesFromKey(Handle KVPs, char[] key, int weaponEID)
{
    if (KvJumpToKey(KVPs, key))
    {
        KvGotoFirstSubKey(KVPs);
        do 
        {
            char attribute[DEFAULT_STRING_SIZE];
            KvGetSectionName(KVPs, attribute, sizeof(attribute));
            float value = KvGetFloat(KVPs, "value", 0.0);
            
            TF2Attrib_SetByName(weaponEID, attribute, value);
        } 
        while (KvGotoNextKey(KVPs));

        KvRewind(KVPs);
    }
}