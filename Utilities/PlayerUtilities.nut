local function IsPlayer(ent){
	if(ent != null && ent.IsValid() && ent.GetClassname().tolower() == "player"){
		return true
	} else {
		return false
	}
}

local function TogglePropBoolean(ent, flag){
	if(ent != null && typeof(ent) == "instance" && ent.IsValid() && flag != null && typeof(flag) == "string"){
		local value = NetProps.GetPropInt(ent,flag)
		if(value == 0){
			NetProps.SetPropInt(ent,flag,1)
		} else if(value == 1){
			NetProps.SetPropInt(ent,flag,0)
		}
	}
}

function SetNightvision(player, bool){
	if(IsPlayer(player) && bool != null && typeof(bool) == "bool"){
		if(bool){
			NetProps.SetPropInt(player,"m_bNightVisionOn",1)
		} else {
			NetProps.SetPropInt(player,"m_bNightVisionOn",0)
		}
	}
}

function ToggleNightvision(player){
	if(IsPlayer(player)){
		TogglePropBoolean(player,"m_bNightVisionOn")
	}
}

function SetIncapacitated(player, bool){
	if(IsPlayer(player) && typeof(bool) == "bool"){
		if(bool){
			NetProps.SetPropInt(player,"m_isIncapacitated",1)
		} else {
			NetProps.SetPropInt(player,"m_isIncapacitated",0)
		}
	}
}

function ToggleIncapacitated(player){
	if(IsPlayer(player)){
		TogglePropBoolean(player, "m_isIncapacitated")
	}
}

function SetNoclipping(player,bool){
	if(IsPlayer(player) && typeof(bool) == "bool"){
		if(bool){
			NetProps.SetPropInt( player, "movetype", 8)
		} else {
			NetProps.SetPropInt( player, "movetype", 2)
		}
	}
}

function ToggleNoclipping(player){
	if(IsPlayer(player)){
		local movetype = NetProps.GetPropInt(player,"movetype")
		if(movetype != 8){
			NetProps.SetPropInt( player, "movetype", 8)
		} else {
			NetProps.SetPropInt( player, "movetype", 2)
		}
	}
}

function ResetFallDamage(player){
	if(IsPlayer(player)){
		NetProps.SetPropFloat(player,"m_Local.m_flFallVelocity",0)
	}
}

function ToggleMiscHud(player){
	if(IsPlayer(player)){
		if(NetProps.GetPropInt(player,"m_Local.m_iHideHUD") & 64 == 64){
			NetProps.SetPropInt(player,"m_Local.m_iHideHUD",NetProps.GetPropInt(player,"m_Local.m_iHideHUD") & ~64)
		} else {
			NetProps.SetPropInt(player,"m_Local.m_iHideHUD",NetProps.GetPropInt(player,"m_Local.m_iHideHUD") | 64)
		}
	}
}

function SetCurrentWeaponAmmo(clip, ){
	
}

// do some stuff with setting ammo