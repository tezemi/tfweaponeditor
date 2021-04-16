#pragma semicolon 1

#include <tf2>
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
    //  Get Utility Slot
    //
    int utilitySlotIDI = -1;
    int utilitySlotEID = TF2_GetPlayerLoadoutSlot(clientID, TF2LoadoutSlot_Utility);
    if (utilitySlotEID != -1)
    {
        utilitySlotIDI = GetEntProp(utilitySlotEID, Prop_Send, "m_iItemDefinitionIndex");
    }

    //
    //  Get Building Slot
    //
    int buildingSlotIDI = -1;
    int buildingSlotEID = TF2_GetPlayerLoadoutSlot(clientID, TF2LoadoutSlot_Building);
    if (buildingSlotEID != -1)
    {
        buildingSlotIDI = GetEntProp(buildingSlotEID, Prop_Send, "m_iItemDefinitionIndex");
    }

    //
    //  Get PDA2 Slot
    //
    int pdaSlotIDI = -1;
    int pdaSlotEID = TF2_GetPlayerLoadoutSlot(clientID, TF2LoadoutSlot_PDA2);
    if (pdaSlotEID != -1)
    {
        pdaSlotIDI = GetEntProp(pdaSlotEID, Prop_Send, "m_iItemDefinitionIndex");
    }

    char dir[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, dir, sizeof(dir), "scripting/tfweaponeditor/configs");
    if (!DirExists(dir))
    {
        SetFailState("[TFWE] There is no scripting/tfweaponeditor/configs directory. Create a folder in configs called scripting/tfweaponeditor/configs to fix.");

        return Plugin_Continue;
    }

    FileType type;
    char file[PLATFORM_MAX_PATH];
    Handle openedDir = OpenDirectory(dir, false, NULL_STRING);

    while (ReadDirEntry(openedDir, file, sizeof(file), type))
    {
        if (type != FileType_File)
            continue;

        Format(file, sizeof(file), "%s/%s", dir, file);

        Handle KVPs = CreateKeyValues("");

        if (!FileToKeyValues(KVPs, file))
		{
			PrintToServer("[TFWE] Could not parse '%s'. File won't be loaded.", dir);
			CloseHandle(KVPs);

			continue;
		}

        bool enabled = true;
        char enabled_string[DEFAULT_STRING_SIZE];
        if (KvGetString(KVPs, "enabled", enabled_string, sizeof(enabled_string), "true"))
        {
            if (strcmp(enabled_string, "true", false) == 0)
            {
                enabled = true;
            }
            else
            {
                enabled = false;
            }
        }

        if (!enabled)
        {
            CloseHandle(KVPs); 
            continue;
        }
        
        int weaponID = KvGetNum(KVPs, "base_weapon", 0);

        if (primarySlotIDI == weaponID)
        {
            ApplyWeaponConfig(KVPs, primarySlotEID);
            PrintWeaponDescription(clientID, KVPs, "Primary Weapon");
        }
        else if (secondarySlotIDI == weaponID)
        {
            ApplyWeaponConfig(KVPs, secondarySlotEID);
            PrintWeaponDescription(clientID, KVPs, "Secondary Weapon");
        }
        else if (meleeSlotIDI == weaponID)
        {
            ApplyWeaponConfig(KVPs, meleeSlotEID);
            PrintWeaponDescription(clientID, KVPs, "Melee Weapon");
        }
        else if (utilitySlotIDI == weaponID)
        {
            ApplyWeaponConfig(KVPs, utilitySlotEID);
            PrintWeaponDescription(clientID, KVPs, "Utility");
        }
        else if (buildingSlotIDI == weaponID)
        {
            ApplyWeaponConfig(KVPs, buildingSlotEID);
            PrintWeaponDescription(clientID, KVPs, "Building");
        }
        else if (pdaSlotIDI == weaponID)
        {
            ApplyWeaponConfig(KVPs, pdaSlotEID);
            PrintWeaponDescription(clientID, KVPs, "PDA");
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
    int clip = KvGetNum(KVPs, "clip", -1);
    if (clip != -1)
    {
        SetWeaponClip(weaponEID, clip);
    }

    int ammo = KvGetNum(KVPs, "ammo", -1);
    if (ammo != -1)
    {
        SetWeaponAmmo(weaponEID, ammo);
    }

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

static void PrintWeaponDescription(int clientID, Handle KVPs, char[] header)
{
    char weapon_desc[DEFAULT_STRING_SIZE];
    KvGetString(KVPs, "description", weapon_desc, sizeof(weapon_desc), "");
    if (strcmp(weapon_desc, "", false) != 0)
    {
        PrintToChat(clientID, "%s: %s", header, weapon_desc);
    }
}

static SetWeaponAmmo(weapon, ammo)
{
	int owner = GetEntPropEnt(weapon, Prop_Send, "m_hOwnerEntity");
	if (owner == -1)
        return;

	int offset = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType", 1)*4;
	int ammo_table = FindSendPropInfo("CTFPlayer", "m_iAmmo");
    
	SetEntData(owner, ammo_table + offset, ammo, 4, true);
}

static SetWeaponClip(weapon, newClip)
{
	int ammo_table = FindSendPropInfo("CTFWeaponBase", "m_iClip1");

	SetEntData(weapon, ammo_table, newClip, 4, true);
}