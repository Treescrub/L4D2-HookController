//make sure the inputs for register functions are correct (correct type, etc)
//make OnEquipped and OnUnequipped for non-custom weapons?
//make more options
//more listeners somehow?

/*options
fire custom weapon while restricted (default is off)
print debug info (default is on)
*/

printl("Hook Controller loaded. (Made by Daroot Leafstorm)")

local custom_weapons = []
local hook_scripts = []
local tick_scripts = []
local ent_move_listeners = []
local ent_create_listeners = []
local players = []
local tasks = []

// options
local debugprint = true
local fire_while_restricted = false

local timer = null

function Start(){
	if(timer == null){
		timer = SpawnEntityFromTable("logic_timer",{targetname = "think_timer",RefireTime = 0.01}) //spawns in index 0, 0 is supposed to be null
		timer.ValidateScriptScope()
		timer.GetScriptScope()["scope"] <- this
		timer.GetScriptScope()["func"] <- function(){
			scope.Think()
		}
		timer.ConnectOutput("OnTimer", "func")
		EntFire("!self","Enable",null,0,timer)
	}
}


const ATTACK = 1
const JUMP = 2
const CROUCH = 4
const FORWARD = 8
const BACKWARD = 16
const USE = 32
const LEFT = 512
const RIGHT = 1024
const ATTACK2 = 2048
const RELOAD = 8192
const SHOWSCORES = 65536
const WALK = 131072
const ZOOM = 524288

const PRINT_START = "Hook Controller: "

class PlayerInfo {
	constructor(ent){
		entity = ent
	}
	
	function IsDead(){
		if(entity.IsValid()){
			return entity.IsDead()
		}
		return false
	}
	
	
	function SetDisabled(isDisabled){
		disabled = isDisabled
	}
	function GetDisabled(){
		return disabled
	}
	
	
	function GetId(){
		return entity.GetPlayerUserId()
	}
	
	
	function GetActiveWeapon(){
		return entity.GetActiveWeapon()
	}
	
	
	function GetButtonMask(){
		return entity.GetButtonMask()
	}
	
	
	function GetEntity(){
		return entity
	}
	
	
	function GetAttack(){
		return attack
	}
	function SetAttack(bool){
		attack = bool
	}
	
	
	function GetAttack2(){
		return attack2
	}
	function SetAttack2(bool){
		attack2 = bool
	}
	
	
	function GetCrouch(){
		return crouch
	}
	function SetCrouch(bool){
		crouch = bool
	}
	
	
	function GetForward(){
		return forward
	}
	function SetForward(bool){
		forward = bool
	}
	
	
	function GetBackward(){
		return backward
	}
	function SetBackward(bool){
		backward = bool
	}
	
	
	function GetLeft(){
		return left
	}
	function SetLeft(bool){
		left = bool
	}
	
	
	function GetRight(){
		return right
	}
	function SetRight(bool){
		right = bool
	}
	
	
	function GetUse(){
		return use
	}
	function SetUse(bool){
		use = bool
	}
	
	
	function GetShowscores(){
		return showscores
	}
	function SetShowscores(bool){
		showscores = bool
	}
	
	
	function GetWalk(){
		return walk
	}
	function SetWalk(bool){
		walk = bool
	}
	
	
	function GetZoom(){
		return zoom
	}
	function SetZoom(bool){
		zoom = bool
	}
	
	
	function GetReload(){
		return reload
	}
	function SetReload(bool){
		reload = bool
	}
	
	
	function GetJump(){
		return jump
	}
	function SetJump(bool){
		jump = bool
	}
	
	
	function GetLastWeapon(){
		return lastweapon
	}
	
	
	function SetLastWeapon(ent){
		lastweapon = ent
	}
	
	function GetLastWeaponsArray(){
		return lastweapons
	}
	function SetLastWeaponsArray(array){
		lastweapons = array
	}
	
	entity = null
	disabled = false
	attack = false
	attack2 = false
	crouch = false
	forward = false
	backward = false
	reload = false
	left = false
	right = false
	use = false
	showscores = false
	walk = false
	zoom = false
	jump = false
	
	lastweapon = null
	lastweapons = null
}

class CustomWeapon {
	constructor(vmodel, wmodel, scriptscope){
		viewmodel = vmodel
		worldmodel = wmodel
		scope = scriptscope
	}
	
	function GetViewModel(){
		return viewmodel
	}
	
	function GetWorldModel(){
		return worldmodel
	}
	
	function GetScope(){
		return scope
	}
	
	viewmodel = null
	worldmodel = null
	scope = null
}

class EntityCreateListener {
	constructor(className, scriptscope){
		classname = className
		scope = scriptscope
	}
	
	function GetClassname(){
		return classname
	}
	
	function GetScope(){
		return scope
	}
	
	function GetLastEntities(){
		return last_entities
	}
	function SetLastEntities(array){
		last_entities = array
	}
	
	last_entities = []
	scope = null
	classname = null
}

class EntityMoveListener {
	constructor(ent, scriptscope){
		entity = ent
		scope = scriptscope
		last_position = entity.GetOrigin()
	}
	
	function GetScope(){
		return scope
	}
	
	function GetEntity(){
		return entity
	}
	
	function GetLastPosition(){
		return last_position
	}
	
	function SetLastPosition(vector){
		last_position = vector
	}
	
	last_position = null
	entity = null
	scope = null
}

class Task{
	constructor(callFunction, time, scriptscope){
		func = callFunction
		end_time = time
		scope = scriptscope
	}
	
	function GetEndTime(){
		return end_time
	}
	
	function GetFunction(){
		return func
	}
	
	function GetScope(){
		return scope
	}
	
	end_time = null
	func = null
	scope = null
}





local function GetSurvivors()
{
	local array = []
	local ent = null
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			if (ent.IsSurvivor()){
				array.append(ent)
			}
		}
	}

	return array
}

local function FindPlayerObject(playerId){
	foreach(player in players){
		if(player.GetId() == playerId){
			return player
		}
	}
	return null
}

local function FindCustomWeapon(weaponmodel){ // make this so it won't break really easy
	foreach(weapon in custom_weapons){
		if(weapon.GetViewModel() == weaponmodel){
			return weapon
		}
	}
	return null
}

local function CallFunction(scope,funcName,ent = null,player = null){ // if parameters has entity (or ent), pass ent, if has player, pass player
	if(scope != null && funcName in scope && typeof(scope[funcName]) == "function"){
		local params = scope[funcName].getinfos().parameters
		local index_offset = 0 // sometimes it contains "this" sometimes it doesn't?
		if(params.find("this") != null){
			index_offset = -1
		}
		if(params.find("player") != null){
			if(params.find("ent") != null){
				if(params.find("ent") + index_offset == 0){
					scope[funcName](ent,player)
				} else {
					scope[funcName](player,ent)
				}
			} else if(params.find("entity") != null) {
				if(params.find("entity") + index_offset == 0){
					scope[funcName](ent,player)
				} else {
					scope[funcName](player,ent)
				}
			} else {
				scope[funcName](player)
			}
		} else if(params.find("ent") != null || params.find("entity") != null){
			scope[funcName](ent)
		} else {
			scope[funcName]()
		}
	}
}

local function HandleCallback(scope, weaponmodel, player){ // scope = scope of custom weapon, model = model of current weapon
	if(player.GetLastWeapon() != null && NetProps.GetPropString(player.GetLastWeapon(), "m_ModelName") != weaponmodel){ //we changed weapons!
		foreach(weapon in custom_weapons){
			if(NetProps.GetPropString(player.GetLastWeapon(), "m_ModelName") == weapon.GetViewModel()){
				CallFunction(weapon.GetScope(),"OnUnequipped",player.GetLastWeapon(),player.GetEntity())
			} else if(weaponmodel == weapon.GetViewModel()){
				CallFunction(weapon.GetScope(),"OnEquipped",player.GetLastWeapon(),player.GetEntity())
			}
		}
	}
	
	
	if(player.GetButtonMask() & ATTACK){
		if(player.GetAttack()){
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressTick_Attack",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressTick_Attack",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		} else {
			player.SetAttack(true)
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressStart_Attack",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressStart_Attack",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
	} else if(player.GetAttack()){
		player.SetAttack(false)
		foreach(script in hook_scripts){
			CallFunction(script,"OnKeyPressEnd_Attack",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
		CallFunction(scope,"OnKeyPressEnd_Attack",player.GetEntity().GetActiveWeapon(),player.GetEntity())
	}
	
	if(player.GetButtonMask() & ATTACK2){ // will act weirdly and will start on shove start, and end when the weapon returns to the normal position
		if(player.GetAttack2()){
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressTick_Attack2",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressTick_Attack2",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		} else {
			player.SetAttack2(true)
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressStart_Attack2",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressStart_Attack2",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
	} else if(player.GetAttack2()){
		player.SetAttack2(false)
		foreach(script in hook_scripts){
			CallFunction(script,"OnKeyPressEnd_Attack2",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
		CallFunction(scope,"OnKeyPressEnd_Attack2",player.GetEntity().GetActiveWeapon(),player.GetEntity())
	}
	
	if(player.GetButtonMask() & CROUCH){
		if(player.GetCrouch()){
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressTick_Crouch",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressTick_Crouch",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		} else {
			player.SetCrouch(true)
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressStart_Crouch",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressStart_Crouch",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
	} else if(player.GetCrouch()){
		player.SetCrouch(false)
		foreach(script in hook_scripts){
			CallFunction(script,"OnKeyPressEnd_Crouch",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
		CallFunction(scope,"OnKeyPressEnd_Crouch",player.GetEntity().GetActiveWeapon(),player.GetEntity())
	}
	
	if(player.GetButtonMask() & LEFT){
		if(player.GetLeft()){
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressTick_Left",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressTick_Left",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		} else {
			player.SetLeft(true)
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressStart_Left",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressStart_Left",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
	} else if(player.GetLeft()){
		player.SetLeft(false)
		foreach(script in hook_scripts){
			CallFunction(script,"OnKeyPressEnd_Left",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
		CallFunction(scope,"OnKeyPressEnd_Left",player.GetEntity().GetActiveWeapon(),player.GetEntity())
	}
	
	if(player.GetButtonMask() & RIGHT){
		if(player.GetRight()){
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressTick_Right",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressTick_Right",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		} else {
			player.SetRight(true)
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressStart_Right",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressStart_Right",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
	} else if(player.GetRight()){
		player.SetRight(false)
		foreach(script in hook_scripts){
			CallFunction(script,"OnKeyPressEnd_Right",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
		CallFunction(scope,"OnKeyPressEnd_Right",player.GetEntity().GetActiveWeapon(),player.GetEntity())
	}
	
	if(player.GetButtonMask() & FORWARD){
		if(player.GetForward()){
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressTick_Forward",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressTick_Forward",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		} else {
			player.SetForward(true)
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressStart_Forward",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressStart_Forward",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
	} else if(player.GetForward()){
		player.SetForward(false)
		foreach(script in hook_scripts){
			CallFunction(script,"OnKeyPressEnd_Forward",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
		CallFunction(scope,"OnKeyPressEnd_Forward",player.GetEntity().GetActiveWeapon(),player.GetEntity())
	}
	
	if(player.GetButtonMask() & BACKWARD){
		if(player.GetBackward()){
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressTick_Backward",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressTick_Backward",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		} else {
			player.SetBackward(true)
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressStart_Backward",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressStart_Backward",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
	} else if(player.GetBackward()){
		player.SetBackward(false)
		foreach(script in hook_scripts){
			CallFunction(script,"OnKeyPressEnd_Backward",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
		CallFunction(scope,"OnKeyPressEnd_Backward",player.GetEntity().GetActiveWeapon(),player.GetEntity())
	}
	
	if(player.GetButtonMask() & USE){
		if(player.GetUse()){
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressTick_Use",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressTick_Use",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		} else {
			player.SetUse(true)
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressStart_Use",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressStart_Use",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
	} else if(player.GetUse()){
		player.SetUse(false)
		foreach(script in hook_scripts){
			CallFunction(script,"OnKeyPressEnd_Use",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
		CallFunction(scope,"OnKeyPressEnd_Use",player.GetEntity().GetActiveWeapon(),player.GetEntity())
	}
	
	if(player.GetButtonMask() & RELOAD){
		if(player.GetReload()){
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressTick_Reload",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressTick_Reload",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		} else {
			player.SetReload(true)
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressStart_Reload",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressStart_Reload",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
	} else if(player.GetReload()){
		player.SetReload(false)
		foreach(script in hook_scripts){
			CallFunction(script,"OnKeyPressEnd_Reload",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
		CallFunction(scope,"OnKeyPressEnd_Reload",player.GetEntity().GetActiveWeapon(),player.GetEntity())
	}
	
	if(player.GetButtonMask() & WALK){
		if(player.GetWalk()){
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressTick_Walk",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressTick_Walk",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		} else {
			player.SetWalk(true)
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressStart_Walk",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressStart_Walk",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
	} else if(player.GetWalk()){
		player.SetWalk(false)
		foreach(script in hook_scripts){
			CallFunction(script,"OnKeyPressEnd_Walk",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
		CallFunction(scope,"OnKeyPressEnd_Walk",player.GetEntity().GetActiveWeapon(),player.GetEntity())
	}
	
	if(player.GetButtonMask() & ZOOM){
		if(player.GetZoom()){
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressTick_Zoom",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressTick_Zoom",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		} else {
			player.SetZoom(true)
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressStart_Zoom",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressStart_Zoom",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
	} else if(player.GetZoom()){
		player.SetZoom(false)
		foreach(script in hook_scripts){
			CallFunction(script,"OnKeyPressEnd_Zoom",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
		CallFunction(scope,"OnKeyPressEnd_Zoom",player.GetEntity().GetActiveWeapon(),player.GetEntity())
	}
	
	if(player.GetButtonMask() & JUMP){
		if(player.GetJump()){
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressTick_Jump",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressTick_Jump",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		} else {
			player.SetJump(true)
			foreach(script in hook_scripts){
				CallFunction(script,"OnKeyPressStart_Jump",player.GetEntity().GetActiveWeapon(),player.GetEntity())
			}
			CallFunction(scope,"OnKeyPressStart_Jump",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
	} else if(player.GetJump()){
		player.SetJump(false)
		foreach(script in hook_scripts){
			CallFunction(script,"OnKeyPressEnd_Jump",player.GetEntity().GetActiveWeapon(),player.GetEntity())
		}
		CallFunction(scope,"OnKeyPressEnd_Jump",player.GetEntity().GetActiveWeapon(),player.GetEntity())
	}
}

function Think(){
	foreach(script in hook_scripts){
		CallFunction(script,"OnTick")
	}
	foreach(script in tick_scripts){
		CallFunction(script,"OnTick")
	}
	foreach(survivor in GetSurvivors()){
		if(players.len() == 0){
			players.append(PlayerInfo(survivor))
		} else {
			local found = false
			for(local i=0; i<players.len();i++){
				if(players[i].GetEntity() != null && players[i].GetEntity().IsValid()){
					if(survivor.GetPlayerUserId() == players[i].GetEntity().GetPlayerUserId()){
						found = true
					}
				} else {
					players.remove(i)
					i -= 1
				}
			}
			if(!found){
				players.append(PlayerInfo(survivor))
			}
		}
	}
	for(local i=0;i<tasks.len();i+=1){
		if(Time() >= tasks[i].GetEndTime()){
			if(tasks[i].GetScope() == null){ // if we're calling a function directly
				tasks[i].GetFunction()()
			} else {
				CallFunction(tasks[i].GetScope(),tasks[i].GetFunction())
			}
			tasks.remove(i)
			i -= 1
		}
	}
	foreach(listener in ent_move_listeners){
		local current_position = listener.GetEntity().GetOrigin()
		local old_position = listener.GetLastPosition()
		if(old_position != null && (current_position.x != old_position.x || current_position.y != old_position.y || current_position.z != old_position.z)){ //we moved, probably
			CallFunction(listener.GetScope(),"OnEntityMove",listener.GetEntity())
		}
		listener.SetLastPosition(listener.GetEntity().GetOrigin())
	}
	foreach(listener in ent_create_listeners){
		local ent = null
		local ent_array = []
		while((ent = Entities.FindByClassname(ent,listener.GetClassname())) != null){
			ent_array.append(ent)
		}
		if(listener.GetLastEntities() != null && listener.GetLastEntities().len() < ent_array.len()){ // this may miss entities if an entity of the same type is killed at the same time as one is spawned
			ent_array.sort(@(a,b) a.GetEntityIndex() <=> b.GetEntityIndex())
			local new_ents = ent_array.slice(listener.GetLastEntities().len())
			foreach(new_ent in new_ents){
				printl("OnEntCreate_"+listener.GetClassname())
				CallFunction(listener.GetScope(),"OnEntCreate_"+listener.GetClassname(),new_ent)
			}
		}
		listener.SetLastEntities(ent_array)
	}
	if(custom_weapons.len() > 0){
		foreach(player in players){
			if(player != null){
				if(!player.GetEntity().IsValid() || player.GetEntity().IsDead()){
					player.SetDisabled(true)
				} else {
					local weaponmodel = NetProps.GetPropString(player.GetActiveWeapon(), "m_ModelName")
					local custom_weapon = FindCustomWeapon(weaponmodel)
					if(custom_weapon != null){
						HandleCallback(custom_weapon.GetScope(),weaponmodel,player)
						player.SetLastWeapon(player.GetEntity().GetActiveWeapon())
					} else {
						HandleCallback(null,weaponmodel,player)
						player.SetLastWeapon(player.GetEntity().GetActiveWeapon())
					}
					
			
					local current_weapons = []
					local new_weapons = []
					local dropped_weapons = []
					
					local inventory_index = 0
					local item = null
					
					while(inventory_index < 5){
						item = NetProps.GetPropEntityArray(player.GetEntity(), "m_hMyWeapons", inventory_index)
						if(item != null){
							current_weapons.append(item)
							new_weapons.append(item)
						}
						inventory_index += 1
					}
					
					if(player.GetLastWeaponsArray() == null){
						player.SetLastWeaponsArray(current_weapons)
					}
					
					dropped_weapons.extend(player.GetLastWeaponsArray())
					
					for(local i=0;i < dropped_weapons.len();i+=1){
						for(local j=0;j < new_weapons.len();j+=1){
							if(dropped_weapons != null && i < dropped_weapons.len() && dropped_weapons[i] != null){
								if(new_weapons != null && dropped_weapons != null && new_weapons[j] != null && dropped_weapons[i] != null && new_weapons[j].IsValid() && dropped_weapons[i].IsValid() && new_weapons[j].GetEntityIndex() == dropped_weapons[i].GetEntityIndex()){
									new_weapons.remove(j)
									dropped_weapons.remove(i)
									if(i != 0){
										i -= 1
									}
									j -= 1
								}
							}
						}
					}
					
					if(new_weapons.len() > 0) {
						foreach(ent in new_weapons){
							foreach(weapon in custom_weapons){
								if(NetProps.GetPropString(ent, "m_ModelName") == weapon.GetViewModel()){
									CallFunction(weapon.GetScope(),"OnPickup",ent,player.GetEntity())
								}
							}
						}
					}
					if(dropped_weapons.len() > 0){
						foreach(ent in dropped_weapons){
							foreach(weapon in custom_weapons){
								if(NetProps.GetPropString(ent, "m_ModelName") == weapon.GetWorldModel()){
									CallFunction(weapon.GetScope(),"OnDrop",ent,player.GetEntity())
								}
							}
						}
					}

					player.SetLastWeaponsArray(current_weapons)
				}
			}
		}
	}
}

function SetOptions(table){
	if(table != null){
		foreach(key, value in table){
			if(key.tolower() == "debugprint"){
				if(value == 0){
					debugprint = false
				} else if(value == false){
					debugprint = false
				}
			}
		}
	} else {
		printl(PRINT_START + "Could not set options (Table is null)")
	}
}

function RegisterCustomWeapon(viewmodel, worldmodel, script){
	local failed = "Failed to register a custom weapon script "
	if(viewmodel != null && worldmodel != null && script != null){
		if(typeof(viewmodel) == "string" && typeof(worldmodel) == "string"){
			local script_scope = {}
			if(!IncludeScript(script, script_scope)){
				if(debugprint){
					printl(PRINT_START + failed + "(Could not include script)")
				}
				return false
			}
			if(viewmodel.slice(viewmodel.len()-4) != ".mdl"){
				viewmodel = viewmodel + ".mdl"
			}
			if(worldmodel.slice(worldmodel.len()-4) != ".mdl"){
				worldmodel = worldmodel + ".mdl"
			}
			custom_weapons.append(CustomWeapon(viewmodel,worldmodel,script_scope))
			if("OnInitialize" in script_scope){
				script_scope["OnInitialize"]()
			}
			if(debugprint){
				printl(PRINT_START + "Registered custom weapon script " + script)
			}
			return true
		} else {
			if(debugprint){
				printl(PRINT_START + failed + "(Viewmodel or worldmodel is not a string)")
			}
			return false
		}
	}
	if(debugprint){
		printl(PRINT_START + failed + "(Viewmodel, worldmodel, or script is null)")
	}
	return false
}

function RegisterHooks(scriptscope){ //basically listens for keypresses and calls hooks
	if(scriptscope != null){
		hook_scripts.append(scriptscope)
		if(debugprint){
			printl(PRINT_START + "Registered hooks")
		}
		return true
	}
	if(debugprint){
		printl(PRINT_START + "Failed to register hooks (The scope is null)")
	}
	return false
}

function RegisterOnTick(scriptscope){
	if(scriptscope != null){
		tick_scripts.append(scriptscope)
		if(debugprint){
			printl(PRINT_START + "Registered OnTick")
		}
		return true
	}
	if(debugprint){
		printl(PRINT_START + "Failed to register OnTick (The scope is null)")
	}
	return false
}

function RegisterEntityCreateListener(classname, scope){
	if(classname != null && scope != null){
		ent_create_listeners.append(EntityCreateListener(classname,scope))
		if(debugprint){
			printl(PRINT_START + "Registered entity create listener on " + classname + " entities")
		}
		return true
	}
	if(debugprint){
		printl(PRINT_START + "Failed to register an entity create listener for " + classname + " entities (Classname or scope is null)")
	}
	return false
}

function RegisterEntityMoveListener(ent,scope){
	if(ent != null && scope != null){
		ent_move_listeners.append(EntityMoveListener(ent,scope))
		if(debugprint){
			printl(PRINT_START + "Registered entity move listener on " + ent)
		}
		return true
	} else {
		if(debugprint){
			printl(PRINT_START + "Failed to register an entity move listener for " + ent + " (Entity or scope is null)")
		}
		return false
	}
}

function ScheduleTask(func, time, scope = null){ // can only check every 33 milliseconds so be careful
	local failed = "Failed to schedule a task "
	if(func != null && time != null){
		if(typeof(time) == "integer" || typeof(time) == "float"){
			if(time > 0){
				if(typeof(func) == "function"){
					tasks.append(Task(func,Time()+time,scope))
					if(debugprint){
						printl(PRINT_START + "Registered a task to execute at " + (Time()+time))
					}
					return true
				} else if(typeof(func) == "string") {
					if(scope != null){
						if(typeof(scope) == "table"){
							tasks.append(Task(func,Time()+time,scope))
							if(debugprint){
								printl(PRINT_START + "Registered a task to execute at " + (Time()+time))
							}
							return true
						} else {
							if(debugprint){
								printl(PRINT_START + failed + "(Scope has to be a table)")
							}
							return false
						}
					} else {
						if(debugprint){
							printl(PRINT_START + failed + "(Cannot call a function name without a scope)")
						}
						return false
					}
				}
			} else {
				if(debugprint){
					printl(PRINT_START + failed + "(Time cannot be less than or equal to zero)")
				}
				return false
			}
		} else {
			if(debugprint){
				printl(PRINT_START + failed + "(Time has to be an integer or a float)")
			}
			return false
		}
	}
	if(debugprint){
		printl(PRINT_START + failed + "(Function or time is null)")
	}
	return false
}



function OnGameEvent_tongue_grab(params)
{
	PlayerRestricted(params.victim)	
}
function OnGameEvent_choke_start(params)
{
	PlayerRestricted(params.victim)	
}
function OnGameEvent_lunge_pounce(params)
{
	PlayerRestricted(params.victim)	
}
function OnGameEvent_charger_carry_start(params)
{
	PlayerRestricted(params.victim)	
}
function OnGameEvent_charger_pummel_start(params)
{
	PlayerRestricted(params.victim)	
}
function OnGameEvent_jockey_ride(params)
{
	PlayerRestricted(params.victim)	
}

function OnGameEvent_tongue_release(params)
{
	if("victim" in params)
	{
		PlayerReleased(params.victim)
	}
}
function OnGameEvent_choke_end(params)
{
	if("victim" in params)
	{
		PlayerReleased(params.victim)
	}
}
function OnGameEvent_pounce_end(params)
{
	if("victim" in params)
	{
		PlayerReleased(params.victim)
	}
}
function OnGameEvent_pounce_stopped(params)
{
	if("victim" in params)
	{
		PlayerReleased(params.victim)
	}
}
function OnGameEvent_charger_carry_end(params)
{
	if("victim" in params)
	{
		PlayerReleased(params.victim)
	}
}
function OnGameEvent_charger_pummel_end(params)
{
	if("victim" in params)
	{
		PlayerReleased(params.victim)
	}
}
function OnGameEvent_jockey_ride_end(params)
{
	if("victim" in params)
	{
		PlayerReleased(params.victim)
	}
}

function PlayerRestricted(playerId){
	local player = FindPlayerObject(playerId)
	if(player != null){
		player.SetDisabled(true)
	}
}

function PlayerReleased(playerId){
	local player = FindPlayerObject(playerId)
	if(player != null){
		player.SetDisabled(false)
	}
}
__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)