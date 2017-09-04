function SetNightvision(player, nightvisionOn){
	if(player != null && player.IsValid() && "player" == player.GetClassname().tolower() && nightvisionOn != null && typeof(nightvisionOn) == "bool"){
		if(nightvisionOn){
			NetProps.SetPropInt(player,"m_bNightVisionOn",1)
		} else {
			NetProps.SetPropInt(player,"m_bNightVisionOn",0)
		}
		return true
	} else {
		return false
	}
}

function ToggleNightvision(player){
	if(player != null && player.IsValid() && "player" == player.GetClassname().tolower()){
		if(NetProps.GetPropInt(player,"m_bNightVisionOn") == 1){
			NetProps.SetPropInt(player,"m_bNightVisionOn",0)
		} else {
			NetProps.SetPropInt(player,"m_bNightVisionOn",1)
		}
		return true
	} else {
		return false
	}
}

function SetIncapacitated(player, bool){
	if(player != null && player.IsValid() && "player" == player.GetClassname().tolower() && typeof(bool) == "bool"){
		if(bool){
			NetProps.SetPropInt(player,"m_isIncapacitated",1)
		} else {
			NetProps.SetPropInt(player,"m_isIncapacitated",0)
		}
		return true
	} else {
		return false
	}
}