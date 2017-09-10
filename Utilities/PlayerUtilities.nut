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
		local val = NetProps.GetPropInt(player,"movetype")
		if(val != 8){
			NetProps.SetPropInt( player, "movetype", 8)
		} else {
			NetProps.SetPropInt( player, "movetype", 2)
		}
	}
}

