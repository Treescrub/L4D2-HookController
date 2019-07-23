/*
	make OnEquipped and OnUnequipped for non-custom weapons?
	make hooked functions use tables? (like VSLib)
	use multiple timers to reduce long hangs?
*/

/*options
fire custom weapon while restricted (default is off)
print debug info (default is on)
*/


enum Keys {
	ATTACK = 1
	JUMP = 2
	CROUCH = 4
	FORWARD = 8
	BACKWARD = 16
	USE = 32
	LEFT = 512
	RIGHT = 1024
	ATTACK2 = 2048
	RELOAD = 8192
	ALT1 = 16384
	ALT2 = 32768
	SHOWSCORES = 65536
	SPEED = 131072
	WALK = 262144
	ZOOM = 524288
	GRENADE1 = 8388608
	GRENADE2 = 16777216
	LOOKSPIN = 33554432
}

enum VariableTypes {
	INTEGER = "integer"
	FLOAT = "float"
	BOOLEAN = "bool"
	STRING = "string"
	TABLE = "table"
	ARRAY = "array"
	FUNCTION = "function"
	CLASS = "class"
	INSTANCE = "instance"
	THREAD = "thread"
	NULL = "null"
}

const CHAR_SPACE = 32
const CHAR_NEWLINE = 10

const PRINT_START = "Hook Controller: "

class PlayerInfo {
	entity = null
	disabled = false
	disabledLast = false
	heldButtonsMask = 0
	
	lastWeapon = null
	lastWeapons = []
	
	constructor(ent){
		entity = ent
	}
	
	function SetDisabled(isDisabled){
		disabledLast = disabled
		disabled = isDisabled
	}
	
	function IsDisabled(){
		return disabled
	}
	
	function WasDisabled(){
		return disabledLast
	}
	
	
	function GetEntity(){
		return entity
	}
	
	
	function GetHeldButtonsMask(){
		return heldButtonsMask
	}
	
	function SetHeldButtonsMask(mask){
		heldButtonsMask = mask
	}
	
	
	function GetLastWeapon(){
		return lastWeapon
	}
	
	
	function SetLastWeapon(ent){
		lastWeapon = ent
	}
	
	function GetLastWeaponsArray(){
		return lastWeapons
	}
	function SetLastWeaponsArray(array){
		lastWeapons = array
	}
}

class CustomWeapon {
	viewmodel = null
	worldmodel = null
	scope = null
	
	constructor(vmodel, wmodel, scriptscope){
		viewmodel = vmodel
		worldmodel = wmodel
		scope = scriptscope
	}
	
	function GetViewmodel(){
		return viewmodel
	}
	
	function GetWorldModel(){
		return worldmodel
	}
	
	function GetScope(){
		return scope
	}
}

class EntityCreateListener {
	oldEntities = []
	scope = null
	classname = null
	
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
	
	function GetOldEntities(){
		return oldEntities
	}
	function SetOldEntities(array){
		oldEntities = array
	}
}

class EntityMoveListener {
	lastPosition = null
	entity = null
	scope = null
	
	constructor(ent, scriptScope){
		entity = ent
		scope = scriptScope
		lastPosition = entity.GetOrigin()
	}
	
	function GetScope(){
		return scope
	}
	
	function GetEntity(){
		return entity
	}
	
	function GetLastPosition(){
		return lastPosition
	}
	
	function SetLastPosition(position){
		lastPosition = position
	}
}

class ThrowableExplodeListener {
	scope = null
	
	constructor(scope){
		this.scope = scope
	}
	
	function GetScope(){
		return scope
	}
}

class Task {
	functionKey = null
	args = null
	endTime = null
	
	/*
		We place the function in a table with the arguments so that the function can access the arguments
	*/
	constructor(func, arguments, time){
		functionKey = UniqueString("TaskFunction")
		args = arguments
		args[functionKey] <- func
		endTime = time
	}
	
	function CallFunction(){
		args[functionKey]()
	}
	
	function ReachedTime(){
		return Time() >= endTime
	}
}

class Timer {
	constructor(hudField, time, callFunction, countDown, formatTime){
		this.hudField = hudField
		this.time = time
		this.callFunction = callFunction
		this.countDown = countDown
		this.formatTime = formatTime
		
		start = Time()
	}
	
	function FormatTime(time){
		local seconds = ceil(time) % 60
		local minutes = floor(ceil(time) / 60)
		if(seconds < 10){
			return minutes.tointeger() + ":0" + seconds.tointeger()
		} else {
			return minutes.tointeger() + ":" + seconds.tointeger()
		}
	}
	
	function Update(){
		local timeRemaining = -1
		
		if(countDown){
			timeRemaining = time - (Time() - start)
		} else {
			timeRemaining = Time() - start
		}
		
		if(formatTime){
			hudField.dataval = FormatTime(timeRemaining)
		} else {
			if(countDown){
				timeRemaining = ceil(timeRemaining).tointeger()
			} else {
				timeRemaining = floor(timeRemaining).tointeger()
			}
			hudField.dataval = timeRemaining
		}
		
		return (countDown && timeRemaining <= 0) || (!countDown && timeRemaining >= time)
	}
	
	function CallFunction(){
		callFunction()
	}
	
	function GetHudField(){
		return hudField
	}
	
	hudField = null
	start = -1
	time = -1
	callFunction = null
	countDown = true
	formatTime = false
}

class ChatCommand {
	inputCommand = false
	commandString = null
	commandFunction = null
	
	constructor(command, func, isInput){
		commandString = command
		commandFunction = func
		inputCommand = isInput
	}
	
	function CallFunction(ent, input = null){
		if(inputCommand){
			commandFunction(ent, input)
		} else {
			commandFunction(ent)
		}
	}
	
	function GetCommand(){
		return commandString
	}
	
	function IsInputCommand(){
		return inputCommand
	}
}

class ConvarListener {
	convar = null
	type = null
	lastValue = null
	scope = null
	
	/*
		type should be either "string" or "float"
	*/
	constructor(convar, type, scope){
		this.convar = convar
		this.type = type
		this.scope = scope
	}
	
	function GetScope(){
		return scope
	}
	
	function GetConvar(){
		return convar
	}
	
	function GetCurrentValue(){
		if(type == "string"){
			return Convars.GetStr(convar)
		} else if(type == "float"){
			return Convars.GetFloat(convar)
		}
	}
	
	function GetLastValue(){
		return lastValue
	}
	
	function SetLastValue(){
		if(type == "string"){
			lastValue = Convars.GetStr(convar)
		} else if(type == "float"){
			lastValue = Convars.GetFloat(convar)
		}
	}
}

class FunctionListener {
	checkFunctionTable = null
	checkFunctionKey = null
	callFunction = null
	singleUse = false
	
	constructor(checkFunction, callFunction, args, singleUse){
		checkFunctionTable = args
		checkFunctionKey = UniqueString()
		checkFunctionTable[checkFunctionKey] <- checkFunction
		this.callFunction = callFunction
		this.singleUse = singleUse
	}
	
	function CheckValue(){
		if(checkFunctionTable[checkFunctionKey]()){
			callFunction()
			return true
		}
		return false
	}
	
	function IsSingleUse(){
		return singleUse
	}
}

class LockedEntity {
	entity = null
	angles = null
	origin = null
	
	constructor(entity, angles, origin){
		this.entity = entity
		this.angles = angles
		this.origin = origin
	}
	
	function DoLock(){
		entity.SetAngles(angles)
		entity.SetOrigin(origin)
	}
}

class ThrownGrenade {
	entity = null
	thrower = null
	startPosition = null
	lastPosition = null
	lastVelocity = null
	
	constructor(entity, thrower, startPosition, lastPosition, lastVelocity){
		this.entity = entity
		this.thrower = thrower
		this.startPosition = startPosition
		this.lastPosition = lastPosition
		this.lastVelocity = lastVelocity
	}
	
	function CheckRemoved(){
		return entity == null || !entity.IsValid()
	}
	
	function GetStartPosition(){
		return startPosition
	}
	
	function SetLastPosition(){
		this.lastPosition = entity.GetOrigin()
	}
	
	function GetLastPosition(){
		return lastPosition
	}
	
	function SetLastVelocity(){
		this.lastVelocity = entity.GetVelocity()
	}
	
	function GetLastVelocity(){
		return lastVelocity
	}
	
	function GetThrower(){
		return thrower
	}
	
	function GetEntity(){
		return entity
	}
}

printl("Hook Controller loaded. (Made by Daroot Leafstorm)")

// options
local debugPrint = true

local customWeapons = []
local hookScripts = []
local tickScripts = []
local tickFunctions = []
local entityMoveListeners = []
local entityCreateListeners = []
local bileExplodeListeners = []
local molotovExplodeListeners = []
local convarListeners = []
local functionListeners = []
local chatCommands = []
local timers = []
local tasks = []
local lockedEntities = []

local bileJars = []
local molotovs = []

local players = []

local improvedMethods = false


// This initializes the timer responsible for the calls to the Think function
local timer = SpawnEntityFromTable("logic_timer",{RefireTime = 0.01})
timer.ValidateScriptScope()
timer.GetScriptScope()["scope"] <- this
timer.GetScriptScope()["func"] <- function(){
	scope.Think()
}
timer.ConnectOutput("OnTimer", "func")
EntFire("!self","Enable",null,0,timer)

/**
 * Prints a message to the console with PRINT_START prepended
 */
local function PrintInfo(message){
	if(debugPrint){
		printl(PRINT_START + message)
	}
}

/**
 * Prints an error to the console with PRINT_START prepended
 */
local function PrintError(message){
	print("\n" + PRINT_START)
	error(message + "\n\n")
}

/**
 * Prints an error to the console including caller, source file, variable type, and expected type with PRINT_START prepended
 */
local function PrintInvalidVarType(message, parameterName, expectedType, actualType){
	local infos = getstackinfos(3)
	PrintError(message + "\n\n\tParameter \"" + parameterName + "\" has an invalid type '" + actualType + "' ; expected: '" + expectedType + "'\n\n\tCALL\n\t\tFUNCTION: " + infos.func + "\n\t\tSOURCE: " + infos.src + "\n\t\tLINE: " + infos.line)
}


/**
 * Checks the type of var, returns true if type matches, false otherwise
 */
local function CheckType(var, type){
	return typeof(var) == type
}

/**
 * Returns an array of all survivors, dead or alive
 */
local function GetSurvivors(){
	local array = []
	local ent = null
	while (ent = Entities.FindByClassname(ent, "player")){
		if(ent.IsValid() && ent.IsSurvivor()){
			array.append(ent)
		}
	}

	return array
}

/**
 * Returns the PlayerInfo instance corresponding to the given entity if it exists, otherwise returns null
 */
local function FindPlayerObject(entity){
	foreach(player in players){
		if(player.GetEntity() == entity){
			return player
		}
	}
}

/**
 * Returns the CustomWeapon instance corresponding to the given viewmodel if it exists, otherwise returns null
 */
local function FindCustomWeapon(viewmodel){
	foreach(weapon in customWeapons){
		if(weapon.GetViewmodel().tolower() == viewmodel.tolower()){
			return weapon
		}
	}
}

/**
 * Calls a specified function by name in the provided scope with optional parameters
 * If the function has entity or ent, it will pass the ent parameter to it
 * If the function has player, it will pass the player parameter to it
 */
local function CallFunction(scope, funcName, ent = null, player = null){ // if parameters has entity (or ent), pass ent, if has player, pass player
	if(scope != null && funcName in scope && typeof(scope[funcName]) == "function"){
		local params = scope[funcName].getinfos().parameters
		local index_offset = 0 // sometimes it contains "this" sometimes it doesn't?
		if(params.find("this") != null){
			index_offset = -1
		}
		if(params.find("player") != null){
			if(params.find("ent") != null){
				if(params.find("ent") + index_offset == 0){
					scope[funcName](ent, player)
				} else {
					scope[funcName](player, ent)
				}
			} else if(params.find("entity") != null) {
				if(params.find("entity") + index_offset == 0){
					scope[funcName](ent, player)
				} else {
					scope[funcName](player, ent)
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

/**
 * Calls the OnInventoryChange function in the specified scope with the ent, droppedWeapons, and newWeapons parameters
 */
local function CallInventoryChangeFunction(scope, ent, droppedWeapons, newWeapons){
	if(scope != null && "OnInventoryChange" in scope && CheckType(scope["OnInventoryChange"], VariableTypes.FUNCTION)){
		scope["OnInventoryChange"](ent, droppedWeapons, newWeapons)
	}
}

/**
 * Calls the OnKeyPressStart_, OnKeyPressTick_, and OnKeyPressEnd_ for the specified keyName within the specified scope
 */
local function CallKeyPressFunctions(player, scope, keyId, keyName){
	if(player.GetEntity().GetButtonMask() & keyId){
		if(player.GetHeldButtonsMask() & keyId){
			foreach(script in hookScripts){
				CallFunction(script, "OnKeyPressTick_" + keyName, player.GetEntity().GetActiveWeapon(), player.GetEntity())
			}
			CallFunction(scope, "OnKeyPressTick_" + keyName, player.GetEntity().GetActiveWeapon(), player.GetEntity())
		} else {
			player.SetHeldButtonsMask(player.GetHeldButtonsMask() | keyId)
			foreach(script in hookScripts){
				CallFunction(script, "OnKeyPressStart_" + keyName, player.GetEntity().GetActiveWeapon(), player.GetEntity())
			}
			CallFunction(scope, "OnKeyPressStart_" + keyName, player.GetEntity().GetActiveWeapon(), player.GetEntity())
		}
	} else if(player.GetHeldButtonsMask() & keyId){
		player.SetHeldButtonsMask(player.GetHeldButtonsMask() & ~keyId)
		foreach(script in hookScripts){
			CallFunction(script, "OnKeyPressEnd_" + keyName, player.GetEntity().GetActiveWeapon(), player.GetEntity())
		}
		CallFunction(scope, "OnKeyPressEnd_" + keyName, player.GetEntity().GetActiveWeapon(), player.GetEntity())
	}
}

/**
 * Calls OnEquipped or OnUnequipped in the custom weapon scope specified by the weaponModel parameter
 */
local function CallWeaponEquipFunctions(player, weaponModel){
	if(player.GetLastWeapon() != null && NetProps.GetPropString(player.GetLastWeapon(), "m_ModelName") != weaponModel){ //we changed weapons!
		foreach(weapon in customWeapons){
			if(NetProps.GetPropString(player.GetLastWeapon(), "m_ModelName") == weapon.GetViewmodel()){
				CallFunction(weapon.GetScope(),"OnUnequipped",player.GetLastWeapon(),player.GetEntity())
			} else if(weaponModel == weapon.GetViewmodel()){
				CallFunction(weapon.GetScope(),"OnEquipped",player.GetLastWeapon(),player.GetEntity())
			}
		}
	}
}

/**
 * Calls OnConvarChange_ in the specified scope with previousValue and newValue
 */
local function CallConvarChangeFunction(scope, convar, previousValue, newValue){
	local funcName = "OnConvarChange_" + convar
	if(scope != null && funcName in scope && CheckType(scope[funcName], VariableTypes.FUNCTION)){
		scope[funcName](previousValue, newValue)
	}
}

/**
 * This is just terrible code
 */
local function HandleCallback(scope, weaponModel, player){ // scope = scope of custom weapon, model = model of current weapon
	CallWeaponEquipFunctions(player, weaponModel)
	
	CallKeyPressFunctions(player, scope, Keys.ATTACK, "Attack")
	CallKeyPressFunctions(player, scope, Keys.JUMP, "Jump")
	CallKeyPressFunctions(player, scope, Keys.CROUCH, "Crouch")
	CallKeyPressFunctions(player, scope, Keys.FORWARD, "Forward")
	CallKeyPressFunctions(player, scope, Keys.BACKWARD, "Backward")
	CallKeyPressFunctions(player, scope, Keys.USE, "Use")
	CallKeyPressFunctions(player, scope, Keys.LEFT, "Left")
	CallKeyPressFunctions(player, scope, Keys.RIGHT, "Right")
	CallKeyPressFunctions(player, scope, Keys.ATTACK2, "Attack2")
	CallKeyPressFunctions(player, scope, Keys.RELOAD, "Reload")
	CallKeyPressFunctions(player, scope, Keys.ALT1, "Alt1")
	CallKeyPressFunctions(player, scope, Keys.ALT2, "Alt2")
	CallKeyPressFunctions(player, scope, Keys.SHOWSCORES, "Showscores")
	CallKeyPressFunctions(player, scope, Keys.SPEED, "Speed")
	CallKeyPressFunctions(player, scope, Keys.WALK, "Walk")
	CallKeyPressFunctions(player, scope, Keys.ZOOM, "Zoom")
	CallKeyPressFunctions(player, scope, Keys.GRENADE1, "Grenade1")
	CallKeyPressFunctions(player, scope, Keys.GRENADE2, "Grenade2")
	CallKeyPressFunctions(player, scope, Keys.LOOKSPIN, "Lookspin")
}

PrintInfo("HookController initialized at " + Time() + "\n\ttimer: " + timer)

/**
 * Called every tick, handles tasks, hooks, etc
 */
function Think(){
	if((improvedMethods && Time() > 0.034) || !improvedMethods){
		foreach(script in hookScripts){
			CallFunction(script, "OnTick")
		}
		foreach(script in tickScripts){
			CallFunction(script, "OnTick")
		}
		foreach(func in tickFunctions){
			func()
		}
		foreach(weapon in customWeapons){
			CallFunction(weapon.GetScope(), "OnTick")
		}
		foreach(survivor in GetSurvivors()){
			if(players.len() == 0){
				players.append(PlayerInfo(survivor))
			} else {
				local found = false
				for(local i=0; i<players.len();i++){
					local player = players[i]
					if(player.GetEntity() != null && player.GetEntity().IsValid()){
						if(survivor.GetPlayerUserId() == player.GetEntity().GetPlayerUserId()){
							found = true
						}
						
						if((NetProps.GetPropEntity(survivor, "m_tongueOwner") && (NetProps.GetPropInt(survivor, "m_isHangingFromTongue") || NetProps.GetPropInt(survivor, "m_reachedTongueOwner") || Time() >= NetProps.GetPropFloat(survivor, "m_tongueVictimTimer") + 1)) || NetProps.GetPropEntity(survivor, "m_jockeyAttacker") || NetProps.GetPropEntity(survivor, "m_pounceAttacker") || (NetProps.GetPropEntity(survivor, "m_pummelAttacker") || NetProps.GetPropEntity(survivor, "m_carryAttacker"))){
							player.SetDisabled(true)
						} else {
							player.SetDisabled(false)
						}
						
						if(player.WasDisabled() && !player.IsDisabled()){
							foreach(weapon in customWeapons){
								CallFunction(weapon.GetScope(), "OnReleased", player.GetEntity().GetActiveWeapon(), player.GetEntity())
							}
						}
						if(!player.WasDisabled() && player.IsDisabled()){
							foreach(weapon in customWeapons){
								CallFunction(weapon.GetScope(), "OnRestricted", player.GetEntity().GetActiveWeapon(), player.GetEntity())
							}
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
		
		if(bileExplodeListeners.len() > 0){
			for(local i = 0; i < bileJars.len(); i++){
				local bileJar = bileJars[i]
				if(bileJar.CheckRemoved()){
					foreach(listener in bileExplodeListeners){
						if("OnBileExplode" in listener.GetScope() && CheckType(listener.GetScope()["OnBileExplode"], VariableTypes.FUNCTION)){
							listener.GetScope()["OnBileExplode"](bileJar.GetThrower(), bileJar.GetStartPosition(), bileJar.GetLastPosition())
						}
					}
					bileJars.remove(i)
					i--
				} else {
					bileJar.SetLastPosition()
					bileJar.SetLastVelocity()
				}
			}
			
			local newBileJar = null
			while(newBileJar = Entities.FindByClassname(newBileJar, "vomitjar_projectile")){
				local foundInstance = false
				foreach(bileJar in bileJars){
					if(bileJar.GetEntity() == newBileJar){
						foundInstance = true
					}
				}
				if(!foundInstance){
					bileJars.append(ThrownGrenade(newBileJar, NetProps.GetPropEntity(newBileJar, "m_hThrower"), newBileJar.GetOrigin(), newBileJar.GetOrigin(), newBileJar.GetVelocity()))
				}
			}
		}
		
		if(molotovExplodeListeners.len() > 0){
			for(local i = 0; i < molotovs.len(); i++){
				local molotov = molotovs[i]
				if(molotov.CheckRemoved()){
					foreach(listener in molotovExplodeListeners){
						if("OnMolotovExplode" in listener.GetScope() && CheckType(listener.GetScope()["OnMolotovExplode"], VariableTypes.FUNCTION)){
							listener.GetScope()["OnMolotovExplode"](molotov.GetThrower(), molotov.GetStartPosition(), molotov.GetLastPosition())
						}
					}
					molotovs.remove(i)
					i--
				} else {
					molotov.SetLastPosition()
					molotov.SetLastVelocity()
				}
			}
			
			local newMolotov = null
			while(newMolotov = Entities.FindByClassname(newMolotov, "molotov_projectile")){
				local foundInstance = false
				foreach(molotov in molotovs){
					if(molotov.GetEntity() == newMolotov){
						foundInstance = true
					}
				}
				if(!foundInstance){
					molotovs.append(ThrownGrenade(newMolotov, NetProps.GetPropEntity(newMolotov, "m_hThrower"), newMolotov.GetOrigin(), newMolotov.GetOrigin(), newMolotov.GetVelocity()))
				}
			}
		}
		
		for(local i=0; i < timers.len(); i++){
			if(timers[i].Update()){
				local timer = timers[i]
				timer.CallFunction()
				for(local j = 0; j < timers.len(); j++){
					if(timer.GetHudField() == timers[i].GetHudField()){
						timers.remove(j)
						i--
						break
					}
				}
			}
		}
		
		for(local i=0; i < functionListeners.len(); i+=1){
			if(functionListeners[i].CheckValue() && functionListeners[i].IsSingleUse()){
				functionListeners.remove(i)
				i -= 1
			}
		}
		
		foreach(lockedEntity in lockedEntities){
			lockedEntity.DoLock()
		}
		
		foreach(listener in entityMoveListeners){
			local currentPosition = listener.GetEntity().GetOrigin()
			local oldPosition = listener.GetLastPosition()
			if(oldPosition != null && currentPosition != oldPosition){
				CallFunction(listener.GetScope(),"OnEntityMove",listener.GetEntity())
			}
			listener.SetLastPosition(listener.GetEntity().GetOrigin())
		}
		
		foreach(listener in entityCreateListeners){
			local ent = null
			local entityArray = []
			while((ent = Entities.FindByClassname(ent,listener.GetClassname())) != null){
				entityArray.append(ent)
			}
			if(listener.GetOldEntities() != null && listener.GetOldEntities().len() < entityArray.len()){ // this may miss entities if an entity of the same type is killed at the same time as one is spawned
				entityArray.sort(@(a, b) a.GetEntityIndex() <=> b.GetEntityIndex())
				local newEntities = entityArray.slice(listener.GetOldEntities().len())
				foreach(newEntity in newEntities){
					CallFunction(listener.GetScope(), "OnEntCreate_" + listener.GetClassname(), newEntity)
				}
			}
			listener.SetOldEntities(entityArray)
		}
		
		foreach(listener in convarListeners){
			if(listener.GetCurrentValue() != listener.GetLastValue){
				CallConvarChangeFunction(listener.GetScope(), listener.GetConvar(), listener.GetLastValue(), listener.GetCurrentValue())
			}
			
			listener.SetLastValue()
		}
		
		if(customWeapons.len() > 0 || hookScripts.len() > 0){
			foreach(player in players){
				if(player.GetEntity() == null || !player.GetEntity().IsValid() || player.GetEntity().IsDead()){
					player.SetDisabled(true)
				} else {
					local weaponModel = NetProps.GetPropString(player.GetEntity().GetActiveWeapon(), "m_ModelName")
					local customWeapon = FindCustomWeapon(weaponModel)
					if(customWeapon != null){
						HandleCallback(customWeapon.GetScope(), weaponModel, player)
						player.SetLastWeapon(player.GetEntity().GetActiveWeapon())
					} else {
						HandleCallback(null,weaponModel, player)
						player.SetLastWeapon(player.GetEntity().GetActiveWeapon())
					}
					
			
					local currentWeapons = []
					local newWeapons = []
					local droppedWeapons = player.GetLastWeaponsArray()
					
					local inventoryIndex = 0
					local item = null
					
					while(inventoryIndex < 5){
						item = NetProps.GetPropEntityArray(player.GetEntity(), "m_hMyWeapons", inventoryIndex)
						if(item != null){
							currentWeapons.append(item)
							newWeapons.append(item)
						}
						inventoryIndex += 1
					}
					
					if(player.GetLastWeaponsArray() == null){
						droppedWeapons = currentWeapons
					}
					
					for(local i=0;i < droppedWeapons.len();i+=1){
						for(local j=0;j < newWeapons.len();j+=1){
							if(i < droppedWeapons.len() && droppedWeapons[i] != null){
								if(newWeapons != null && droppedWeapons != null && newWeapons[j] != null && droppedWeapons[i] != null && newWeapons[j].IsValid() && droppedWeapons[i].IsValid() && newWeapons[j].GetEntityIndex() == droppedWeapons[i].GetEntityIndex()){
									newWeapons.remove(j)
									droppedWeapons.remove(i)
									if(i != 0){
										i -= 1
									}
									j -= 1
								}
							}
						}
					}
					
					if(newWeapons.len() > 0) {
						foreach(ent in newWeapons){
							foreach(weapon in customWeapons){
								if(NetProps.GetPropString(ent, "m_ModelName") == weapon.GetViewmodel()){
									CallFunction(weapon.GetScope(), "OnPickup", ent, player.GetEntity())
								}
							}
						}
					}
					if(droppedWeapons.len() > 0){
						foreach(ent in droppedWeapons){
							foreach(weapon in customWeapons){
								if(NetProps.GetPropString(ent, "m_ModelName") == weapon.GetWorldModel()){
									CallFunction(weapon.GetScope(), "OnDrop", ent, player.GetEntity())
								}
							}
						}
					}
					if(newWeapons.len() > 0 || droppedWeapons.len() > 0){
						foreach(scope in hookScripts){
							CallInventoryChangeFunction(scope, player.GetEntity(), droppedWeapons, newWeapons)
						}
					}
					
					player.SetLastWeaponsArray(currentWeapons)
				}
			}
		}
	}
	
	for(local i=0; i<tasks.len(); i+=1){
		if(tasks[i].ReachedTime()){
			try{
				tasks[i].CallFunction()
			} catch(e){
				printl(e)
			}
			tasks.remove(i)
			i -= 1
		}
	}
}

/**
 * Adds various useful methods to common classes such as CBaseEntity and CTerrorPlayer
 */
function IncludeImprovedMethods(){
	improvedMethods = true
	
	local func = function(){
		CBaseEntity["HasProp"] <- function(propertyName){return NetProps.HasProp(this, propertyName)}
		CBaseEntity["GetPropType"] <- function(propertyName){return NetProps.GetPropType(this, propertyName)}
		CBaseEntity["GetPropArraySize"] <- function(propertyName){return NetProps.GetPropArraySize(this, propertyName)}

		CBaseEntity["GetPropInt"] <- function(propertyName){return NetProps.GetPropInt(this, propertyName)}
		CBaseEntity["GetPropEntity"] <- function(propertyName){return NetProps.GetPropEntity(this, propertyName)}
		CBaseEntity["GetPropString"] <- function(propertyName){return NetProps.GetPropString(this, propertyName)}
		CBaseEntity["GetPropFloat"] <- function(propertyName){return NetProps.GetPropFloat(this, propertyName)}
		CBaseEntity["GetPropVector"] <- function(propertyName){return NetProps.GetPropVector(this, propertyName)}
		CBaseEntity["SetPropInt"] <- function(propertyName, value){return NetProps.SetPropInt(this, propertyName, value)}
		CBaseEntity["SetPropEntity"] <- function(propertyName, value){return NetProps.SetPropEntity(this, propertyName, value)}
		CBaseEntity["SetPropString"] <- function(propertyName, value){return NetProps.SetPropString(this, propertyName, value)}
		CBaseEntity["SetPropFloat"] <- function(propertyName, value){return NetProps.SetPropFloat(this, propertyName, value)}
		CBaseEntity["SetPropVector"] <- function(propertyName, value){return NetProps.SetPropVector(this, propertyName, value)}

		CBaseEntity["GetPropIntArray"] <- function(propertyName, index){return NetProps.GetPropIntArray(this, propertyName, index)}
		CBaseEntity["GetPropEntityArray"] <- function(propertyName, index){return NetProps.GetPropEntityArray(this, propertyName, index)}
		CBaseEntity["GetPropStringArray"] <- function(propertyName, index){return NetProps.GetPropStringArray(this, propertyName, index)}
		CBaseEntity["GetPropFloatArray"] <- function(propertyName, index){return NetProps.GetPropFloatArray(this, propertyName, index)}
		CBaseEntity["GetPropVectorArray"] <- function(propertyName, index){return NetProps.GetPropVectorArray(this, propertyName, index)}
		CBaseEntity["SetPropIntArray"] <- function(propertyName, index, value){return NetProps.SetPropIntArray(this, propertyName, value, index)}
		CBaseEntity["SetPropEntityArray"] <- function(propertyName, index, value){return NetProps.SetPropEntityArray(this, propertyName, value, index)}
		CBaseEntity["SetPropStringArray"] <- function(propertyName, index, value){return NetProps.SetPropStringArray(this, propertyName, value, index)}
		CBaseEntity["SetPropFloatArray"] <- function(propertyName, index, value){return NetProps.SetPropFloatArray(this, propertyName, value, index)}
		CBaseEntity["SetPropVectorArray"] <- function(propertyName, index, value){return NetProps.SetPropVectorArray(this, propertyName, value, index)}

		CBaseEntity["GetModelIndex"] <- function(){return GetPropInt("m_nModelIndex")}
		CBaseEntity["GetModelName"] <- function(){return GetPropString("m_ModelName")}
		CBaseEntity["SetName"] <- function(name){SetPropString("m_iName", name)}

		CBaseEntity["GetFriction"] <- function(){return GetFriction(this)}
		CBaseEntity["GetPhysVelocity"] <- function(){return GetPhysVelocity(this)}

		CBaseEntity["GetFlags"] <- function(){return GetPropInt("m_fFlags")}
		CBaseEntity["SetFlags"] <- function(flag){SetPropInt("m_fFlags", flag)}
		CBaseEntity["AddFlag"] <- function(flag){SetPropInt("m_fFlags", GetPropInt("m_fFlags") | flag)}
		CBaseEntity["RemoveFlag"] <- function(flag){SetPropInt("m_fFlags", GetPropInt("m_fFlags") & ~flag)}

		CBaseEntity["GetMoveType"] <- function(){return GetPropInt("movetype")}
		CBaseEntity["SetMoveType"] <- function(type){SetPropInt("movetype", type)}

		CBaseEntity["GetSpawnflags"] <- function(){return GetPropInt("m_spawnflags")}
		CBaseEntity["SetSpawnFlags"] <- function(flags){SetPropInt("m_spawnflags", flags)}

		CBaseEntity["GetGlowType"] <- function(){return GetPropInt("m_Glow.m_iGlowType")}
		CBaseEntity["SetGlowType"] <- function(type){SetPropInt("m_Glow.m_iGlowType", type)}

		CBaseEntity["GetGlowRange"] <- function(){return GetPropInt("m_Glow.m_nGlowRange")}
		CBaseEntity["SetGlowRange"] <- function(range){SetPropInt("m_Glow.m_nGlowRange", range)}

		CBaseEntity["GetGlowRangeMin"] <- function(){return GetPropInt("m_Glow.m_nGlowRangeMin")}
		CBaseEntity["SetGlowRangeMin"] <- function(range){SetPropInt("m_Glow.m_nGlowRangeMin", range)}

		CBaseEntity["GetGlowColor"] <- function(){return GetPropInt("m_Glow.m_glowColorOverride")}
		CBaseEntity["SetGlowColor"] <- function(r, g, b){
			local color = r
			color += 256 * g
			color += 65536 * b
			SetPropInt("m_Glow.m_glowColorOverride", color)
		}
		CBaseEntity["SetGlowColorVector"] <- function(vector){
			local color = vector.x
			color += 256 * vector.y
			color += 65536 * vector.z
			SetPropInt("m_Glow.m_glowColorOverride", color)
		}
		CBaseEntity["ResetGlowColor"] <- function(){SetPropInt("m_Glow.m_glowColorOverride", -1)}

		CBaseEntity["SetTeam"] <- function(team){SetPropInt("m_iTeamNum", team.tointeger())}
		CBaseEntity["GetTeam"] <- function(){return GetPropInt("m_iTeamNum")}

		CBaseEntity["GetGlowFlashing"] <- function(){return GetPropInt("m_Glow.m_bFlashing")}
		CBaseEntity["SetGlowFlashing"] <- function(flashing){SetPropInt("m_Glow.m_bFlashing", flashing)}

		CBaseEntity["PlaySound"] <- function(soundName){EmitSoundOn(soundName, this)}
		CBaseEntity["StopSound"] <- function(soundName){StopSoundOn(soundName, this)}

		CBaseEntity["Input"] <- function(input, value = "", delay = 0, activator = null){DoEntFire("!self", input.tostring(), value.tostring(), delay.tofloat(), activator, this)}
		CBaseEntity["SetAlpha"] <- function(alpha){Input("Alpha", alpha)}
		CBaseEntity["GetValidatedScriptScope"] <- function(){
			ValidateScriptScope()
			return GetScriptScope()
		}



		CBaseAnimating["GetMoveType"] <- function(){return GetPropInt("movetype")}
		CBaseAnimating["SetMoveType"] <- function(type){SetPropInt("movetype", type)}

		CBaseAnimating["PlaySound"] <- function(soundName){EmitSoundOn(soundName, this)}
		CBaseAnimating["StopSound"] <- function(soundName){StopSoundOn(soundName, this)}

		CBaseAnimating["GetFlags"] <- function(){return GetPropInt("m_fFlags")}
		CBaseAnimating["SetFlags"] <- function(flag){SetPropInt("m_fFlags", flag)}
		CBaseAnimating["AddFlag"] <- function(flag){SetPropInt("m_fFlags", GetPropInt("m_fFlags") | flag)}
		CBaseAnimating["RemoveFlag"] <- function(flag){SetPropInt("m_fFlags", GetPropInt("m_fFlags") & ~flag)}

		CBaseAnimating["GetSpawnflags"] <- function(){return GetPropInt("m_spawnflags")}
		CBaseAnimating["SetSpawnFlags"] <- function(flags){SetPropInt("m_spawnflags", flags)}

		CBaseAnimating["GetGlowType"] <- function(){return GetPropInt("m_Glow.m_iGlowType")}
		CBaseAnimating["SetGlowType"] <- function(type){SetPropInt("m_Glow.m_iGlowType", type)}

		CBaseAnimating["GetGlowRange"] <- function(){return GetPropInt("m_Glow.m_nGlowRange")}
		CBaseAnimating["SetGlowRange"] <- function(range){SetPropInt("m_Glow.m_nGlowRange", range)}

		CBaseAnimating["GetGlowRangeMin"] <- function(){return GetPropInt("m_Glow.m_nGlowRangeMin")}
		CBaseAnimating["SetGlowRangeMin"] <- function(range){SetPropInt("m_Glow.m_nGlowRangeMin", range)}

		CBaseAnimating["GetGlowColor"] <- function(){return GetPropInt("m_Glow.m_glowColorOverride")}
		CBaseAnimating["SetGlowColor"] <- function(r, g, b){
			local color = r
			color += 256 * g
			color += 65536 * b
			SetPropInt("m_Glow.m_glowColorOverride", color)
		}
		CBaseAnimating["SetGlowColorVector"] <- function(vector){
			local color = vector.x
			color += 256 * vector.y
			color += 65536 * vector.z
			SetPropInt("m_Glow.m_glowColorOverride", color)
		}
		CBaseAnimating["ResetGlowColor"] <- function(){SetPropInt("m_Glow.m_glowColorOverride", -1)}

		CBaseAnimating["GetSequence"] <- function(){return GetPropInt("m_nSequence")}
		CBaseAnimating["GetValidatedScriptScope"] <- function(){
			ValidateScriptScope()
			return GetScriptScope()
		}

		CBaseAnimating["Input"] <- function(input, value = "", delay = 0, activator = null){DoEntFire("!self", input.tostring(), value.tostring(), delay.tofloat(), activator, this)}

		CBaseAnimating["GetMoveType"] <- function(){return GetPropInt("movetype")}
		CBaseAnimating["SetMoveType"] <- function(type){SetPropInt("movetype", type)}

		CBaseAnimating["GetModelIndex"] <- function(){return GetPropInt("m_nModelIndex")}
		CBaseAnimating["GetModelName"] <- function(){return GetPropString("m_ModelName")}
		CBaseAnimating["SetName"] <- function(name){SetPropString("m_iName", name)}

		CBaseAnimating["HasProp"] <- function(propertyName){return NetProps.HasProp(this, propertyName)}
		CBaseAnimating["GetPropType"] <- function(propertyName){return NetProps.GetPropType(this, propertyName)}
		CBaseAnimating["GetPropArraySize"] <- function(propertyName){return NetProps.GetPropArraySize(this, propertyName)}

		CBaseAnimating["GetPropInt"] <- function(propertyName){return NetProps.GetPropInt(this, propertyName)}
		CBaseAnimating["GetPropEntity"] <- function(propertyName){return NetProps.GetPropEntity(this, propertyName)}
		CBaseAnimating["GetPropString"] <- function(propertyName){return NetProps.GetPropString(this, propertyName)}
		CBaseAnimating["GetPropFloat"] <- function(propertyName){return NetProps.GetPropFloat(this, propertyName)}
		CBaseAnimating["GetPropVector"] <- function(propertyName){return NetProps.GetPropVector(this, propertyName)}
		CBaseAnimating["SetPropInt"] <- function(propertyName, value){return NetProps.SetPropInt(this, propertyName, value)}
		CBaseAnimating["SetPropEntity"] <- function(propertyName, value){return NetProps.SetPropEntity(this, propertyName, value)}
		CBaseAnimating["SetPropString"] <- function(propertyName, value){return NetProps.SetPropString(this, propertyName, value)}
		CBaseAnimating["SetPropFloat"] <- function(propertyName, value){return NetProps.SetPropFloat(this, propertyName, value)}
		CBaseAnimating["SetPropVector"] <- function(propertyName, value){return NetProps.SetPropVector(this, propertyName, value)}

		CBaseAnimating["GetPropIntArray"] <- function(propertyName, index){return NetProps.GetPropIntArray(this, propertyName, index)}
		CBaseAnimating["GetPropEntityArray"] <- function(propertyName, index){return NetProps.GetPropEntityArray(this, propertyName, index)}
		CBaseAnimating["GetPropStringArray"] <- function(propertyName, index){return NetProps.GetPropStringArray(this, propertyName, index)}
		CBaseAnimating["GetPropFloatArray"] <- function(propertyName, index){return NetProps.GetPropFloatArray(this, propertyName, index)}
		CBaseAnimating["GetPropVectorArray"] <- function(propertyName, index){return NetProps.GetPropVectorArray(this, propertyName, index)}
		CBaseAnimating["SetPropIntArray"] <- function(propertyName, index, value){return NetProps.SetPropIntArray(this, propertyName, value, index)}
		CBaseAnimating["SetPropEntityArray"] <- function(propertyName, index, value){return NetProps.SetPropEntityArray(this, propertyName, value, index)}
		CBaseAnimating["SetPropStringArray"] <- function(propertyName, index, value){return NetProps.SetPropStringArray(this, propertyName, value, index)}
		CBaseAnimating["SetPropFloatArray"] <- function(propertyName, index, value){return NetProps.SetPropFloatArray(this, propertyName, value, index)}
		CBaseAnimating["SetPropVectorArray"] <- function(propertyName, index, value){return NetProps.SetPropVectorArray(this, propertyName, value, index)}

		CBaseAnimating["SetClip"] <- function(clip){SetPropInt("m_iClip1", clip)}
		CBaseAnimating["GetClip"] <- function(){return GetPropInt("m_iClip1")}
		CBaseAnimating["SetReserveAmmo"] <- function(ammo){SetPropInt("m_iExtraPrimaryAmmo", ammo)}
		CBaseAnimating["GetReserveAmmo"] <- function(){return GetPropInt("m_iExtraPrimaryAmmo")}



		CTerrorPlayer["HasProp"] <- function(propertyName){return NetProps.HasProp(this, propertyName)}
		CTerrorPlayer["GetPropType"] <- function(propertyName){return NetProps.GetPropType(this, propertyName)}
		CTerrorPlayer["GetPropArraySize"] <- function(propertyName){return NetProps.GetPropArraySize(this, propertyName)}

		CTerrorPlayer["GetPropInt"] <- function(propertyName){return NetProps.GetPropInt(this, propertyName)}
		CTerrorPlayer["GetPropEntity"] <- function(propertyName){return NetProps.GetPropEntity(this, propertyName)}
		CTerrorPlayer["GetPropString"] <- function(propertyName){return NetProps.GetPropString(this, propertyName)}
		CTerrorPlayer["GetPropFloat"] <- function(propertyName){return NetProps.GetPropFloat(this, propertyName)}
		CTerrorPlayer["GetPropVector"] <- function(propertyName){return NetProps.GetPropVector(this, propertyName)}
		CTerrorPlayer["SetPropInt"] <- function(propertyName, value){return NetProps.SetPropInt(this, propertyName, value)}
		CTerrorPlayer["SetPropEntity"] <- function(propertyName, value){return NetProps.SetPropEntity(this, propertyName, value)}
		CTerrorPlayer["SetPropString"] <- function(propertyName, value){return NetProps.SetPropString(this, propertyName, value)}
		CTerrorPlayer["SetPropFloat"] <- function(propertyName, value){return NetProps.SetPropFloat(this, propertyName, value)}
		CTerrorPlayer["SetPropVector"] <- function(propertyName, value){return NetProps.SetPropVector(this, propertyName, value)}

		CTerrorPlayer["GetPropIntArray"] <- function(propertyName, index){return NetProps.GetPropIntArray(this, propertyName, index)}
		CTerrorPlayer["GetPropEntityArray"] <- function(propertyName, index){return NetProps.GetPropEntityArray(this, propertyName, index)}
		CTerrorPlayer["GetPropStringArray"] <- function(propertyName, index){return NetProps.GetPropStringArray(this, propertyName, index)}
		CTerrorPlayer["GetPropFloatArray"] <- function(propertyName, index){return NetProps.GetPropFloatArray(this, propertyName, index)}
		CTerrorPlayer["GetPropVectorArray"] <- function(propertyName, index){return NetProps.GetPropVectorArray(this, propertyName, index)}
		CTerrorPlayer["SetPropIntArray"] <- function(propertyName, index, value){return NetProps.SetPropIntArray(this, propertyName, value, index)}
		CTerrorPlayer["SetPropEntityArray"] <- function(propertyName, index, value){return NetProps.SetPropEntityArray(this, propertyName, value, index)}
		CTerrorPlayer["SetPropStringArray"] <- function(propertyName, index, value){return NetProps.SetPropStringArray(this, propertyName, value, index)}
		CTerrorPlayer["SetPropFloatArray"] <- function(propertyName, index, value){return NetProps.SetPropFloatArray(this, propertyName, value, index)}
		CTerrorPlayer["SetPropVectorArray"] <- function(propertyName, index, value){return NetProps.SetPropVectorArray(this, propertyName, value, index)}

		CTerrorPlayer["Input"] <- function(input, value = "", delay = 0, activator = null){DoEntFire("!self", input.tostring(), value.tostring(), delay.tofloat(), activator, this)}

		CTerrorPlayer["GetValidatedScriptScope"] <- function(){
			ValidateScriptScope()
			return GetScriptScope()
		}

		CTerrorPlayer["GetMoveType"] <- function(){return GetPropInt("movetype")}
		CTerrorPlayer["SetMoveType"] <- function(type){SetPropInt("movetype", type)}

		CTerrorPlayer["GetFlags"] <- function(){return GetPropInt("m_fFlags")}
		CTerrorPlayer["SetFlags"] <- function(flag){SetPropInt("m_fFlags", flag)}
		CTerrorPlayer["AddFlag"] <- function(flag){SetPropInt("m_fFlags", GetPropInt("m_fFlags") | flag)}
		CTerrorPlayer["RemoveFlag"] <- function(flag){SetPropInt("m_fFlags", GetPropInt("m_fFlags") & ~flag)}

		CTerrorPlayer["GetGlowType"] <- function(){return GetPropInt("m_Glow.m_iGlowType")}
		CTerrorPlayer["SetGlowType"] <- function(type){SetPropInt("m_Glow.m_iGlowType", type)}

		CTerrorPlayer["GetGlowRange"] <- function(){return GetPropInt("m_Glow.m_nGlowRange")}
		CTerrorPlayer["SetGlowRange"] <- function(range){SetPropInt("m_Glow.m_nGlowRange", range)}

		CTerrorPlayer["GetGlowRangeMin"] <- function(){return GetPropInt("m_Glow.m_nGlowRangeMin")}
		CTerrorPlayer["SetGlowRangeMin"] <- function(range){SetPropInt("m_Glow.m_nGlowRangeMin", range)}

		CTerrorPlayer["GetGlowColor"] <- function(){return GetPropInt("m_Glow.m_glowColorOverride")}
		CTerrorPlayer["SetGlowColor"] <- function(r, g, b){
			local color = r
			color += 256 * g
			color += 65536 * b
			SetPropInt("m_Glow.m_glowColorOverride", color)
		}
		CTerrorPlayer["SetGlowColorVector"] <- function(vector){
			local color = vector.x
			color += 256 * vector.y
			color += 65536 * vector.z
			SetPropInt("m_Glow.m_glowColorOverride", color)
		}
		CTerrorPlayer["ResetGlowColor"] <- function(){SetPropInt("m_Glow.m_glowColorOverride", -1)}

		CTerrorPlayer["GetModelIndex"] <- function(){return GetPropInt("m_nModelIndex")}
		CTerrorPlayer["GetModelName"] <- function(){return GetPropString("m_ModelName")}

		CTerrorPlayer["SetName"] <- function(name){SetPropString("m_iName", name)}

		CTerrorPlayer["GetInterp"] <- function(){return GetPropFloat("m_fLerpTime")}

		CTerrorPlayer["GetUpdateRate"] <- function(){return GetPropInt("m_nUpdateRate")}

		CTerrorPlayer["SetModelScale"] <- function(modelScale){SetPropFloat("m_flModelScale", modelScale.tofloat())}
		CTerrorPlayer["GetModelScale"] <- function(){return GetPropFloat("m_flModelScale")}

		CTerrorPlayer["GetTongueVictim"] <- function(){return GetPropEntity("m_tongueVictim")}
		CTerrorPlayer["GetTongueAttacker"] <- function(){return GetPropEntity("m_tongueOwner")}
		CTerrorPlayer["GetPounceVictim"] <- function(){return GetPropEntity("m_pounceVictim")}
		CTerrorPlayer["GetPounceAttacker"] <- function(){return GetPropEntity("m_pounceAttacker")}
		CTerrorPlayer["GetLeapVictim"] <- function(){return GetPropEntity("m_jockeyVictim")}
		CTerrorPlayer["GetLeapAttacker"] <- function(){return GetPropEntity("m_jockeyAttacker")}
		CTerrorPlayer["GetChargeVictim"] <- function(){return GetPropEntity("m_jockeyVictim")}
		CTerrorPlayer["GetChargeAttacker"] <- function(){return GetPropEntity("m_jockeyAttacker")}

		CTerrorPlayer["AddDisabledButton"] <- function(disabledButton){SetPropInt("m_afButtonDisabled", GetPropInt("m_afButtonDisabled") | disabledButton.tointeger())}
		CTerrorPlayer["RemoveDisabledButton"] <- function(disabledButton){SetPropInt("m_afButtonDisabled", GetPropInt("m_afButtonDisabled") & ~disabledButton.tointeger())}
		CTerrorPlayer["SetDisabledButtons"] <- function(disabledButtons){SetPropInt("m_afButtonDisabled", disabledButtons.tointeger())}
		CTerrorPlayer["GetDisabledButtons"] <- function(){return GetPropInt("m_afButtonDisabled")}

		CTerrorPlayer["AddForcedButton"] <- function(forcedButton){SetPropInt("m_afButtonForced", GetPropInt("m_afButtonForced") | disabledButton.tointeger())}
		CTerrorPlayer["RemoveForcedButton"] <- function(forcedButton){SetPropInt("m_afButtonForced", GetPropInt("m_afButtonForced") & ~disabledButton.tointeger())}
		CTerrorPlayer["SetForcedButtons"] <- function(forcedButtons){SetPropInt("m_afButtonForced", disabledButtons.tointeger())}
		CTerrorPlayer["GetForcedButtons"] <- function(){return GetPropInt("m_afButtonForced")}

		CTerrorPlayer["SetPresentAtSurvivalStart"] <- function(presentAtSurvivalStart){SetPropInt("m_bWasPresentAtSurvivalStart", presentAtSurvivalStart.tointeger())}
		CTerrorPlayer["WasPresentAtSurvivalStart"] <- function(){return GetPropInt("m_bWasPresentAtSurvivalStart")}

		CTerrorPlayer["SetGhost"] <- function(ghost){SetPropInt("m_isGhost", ghost.tointeger())}

		CTerrorPlayer["SetUsingMountedGun"] <- function(usingMountedGun){SetPropInt("m_usingMountedGun", usingMountedGun.tointeger())}
		CTerrorPlayer["IsUsingMountedGun"] <- function(){return GetPropInt("m_usingMountedGun")}

		CTerrorPlayer["IsFirstManOut"] <- function(){return GetPropInt("m_bIsFirstManOut")}

		CTerrorPlayer["GetReviveCount"] <- function(){return GetPropInt("m_currentReviveCount")}

		CTerrorPlayer["IsProneTongueDrag"] <- function(){return GetPropInt("m_isProneTongueDrag")}
		CTerrorPlayer["ReachedTongueOwner"] <- function(){return GetPropInt("m_reachedTongueOwner")}
		CTerrorPlayer["IsHangingFromTongue"] <- function(){return GetPropInt("m_isHangingFromTongue")}

		CTerrorPlayer["SetReviveTarget"] <- function(reviveTarget){SetPropEntity("m_reviveTarget", reviveTarget)}
		CTerrorPlayer["GetReviveTarget"] <- function(){return GetPropEntity("m_reviveTarget")}
		CTerrorPlayer["SetReviveOwner"] <- function(reviveOwner){SetPropEntity("m_reviveOwner", reviveOwner)}
		CTerrorPlayer["GetReviveOwner"] <- function(){return GetPropEntity("m_reviveOwner")}

		CTerrorPlayer["SetCurrentUseAction"] <- function(currentUseAction){SetPropInt("m_iCurrentUseAction", currentUseAction.tointeger())}
		CTerrorPlayer["GetCurrentUseAction"] <- function(){return GetPropInt("m_iCurrentUseAction")}
		CTerrorPlayer["SetUseActionTarget"] <- function(useActionTarget){SetPropEntity("m_useActionTarget", useActionTarget)}
		CTerrorPlayer["GetUseActionTarget"] <- function(){return GetPropEntity("m_useActionTarget")}
		CTerrorPlayer["SetUseActionOwner"] <- function(useActionOwner){SetPropEntity("m_useActionOwner", useActionOwner)}
		CTerrorPlayer["GetUseActionOwner"] <- function(){return GetPropEntity("m_useActionOwner")}

		CTerrorPlayer["SetNightvisionEnabled"] <- function(nightvisionEnabled){SetPropInt("m_bNightVisionOn", nightvisionEnabled.tointeger())}
		CTerrorPlayer["IsNightvisionEnabled"] <- function(){return GetPropInt("m_bNightVisionOn")}

		CTerrorPlayer["SetTimescale"] <- function(timescale){SetPropFloat("m_flLaggedMovementValue", timescale.tofloat())}
		CTerrorPlayer["GetTimescale"] <- function(){return GetPropFloat("m_flLaggedMovementValue")}

		CTerrorPlayer["SetDrawViewmodel"] <- function(drawViewmodel){SetPropInt("m_bDrawViewmodel", drawViewmodel.tointeger())}
		CTerrorPlayer["GetDrawViewmodel"] <- function(){return GetPropInt("m_bDrawViewmodel")}

		CTerrorPlayer["SetFallVelocity"] <- function(fallVelocity){SetPropFloat("m_flFallVelocity", fallVelocity)}
		CTerrorPlayer["GetFallVelocity"] <- function(){return GetPropFloat("m_flFallVelocity")}

		CTerrorPlayer["SetHideHUD"] <- function(hideHUD){SetPropInt("m_iHideHUD", hideHUD.tointeger())}
		CTerrorPlayer["GetHideHUD"] <- function(){return GetPropInt("m_iHideHUD")}

		CTerrorPlayer["SetViewmodel"] <- function(viewmodel){SetPropEntity("m_hViewModel", viewmodel)}
		CTerrorPlayer["GetViewmodel"] <- function(){return GetPropEntity("m_hViewModel")}

		CTerrorPlayer["SetZoom"] <- function(zoom){SetPropInt("m_iFOV", zoom.tointeger())}
		CTerrorPlayer["GetZoom"] <- function(){return GetPropInt("m_iFOV")}

		CTerrorPlayer["SetForcedObserverMode"] <- function(forcedObserverMode){SetPropInt("m_bForcedObserverMode", forcedObserverMode.tointeger())}
		CTerrorPlayer["IsForcedObserverMode"] <- function(){return GetPropInt("m_bForcedObserverMode")}
		CTerrorPlayer["SetObserverTarget"] <- function(observerTarget){SetPropEntity("m_hObserverTarget", observerTarget)}
		CTerrorPlayer["GetObserverTarget"] <- function(){return GetPropEntity("m_hObserverTarget")}
		CTerrorPlayer["SetObserverLastMode"] <- function(observerLastMode){SetPropInt("m_iObserverLastMode", observerLastMode.tointeger())}
		CTerrorPlayer["GetObserverLastMode"] <- function(){return GetPropInt("m_iObserverLastMode")}
		CTerrorPlayer["SetObserverMode"] <- function(observerMode){SetPropInt("m_iObserverMode", observerMode.tointeger())}
		CTerrorPlayer["GetObserverMode"] <- function(){return GetPropInt("m_iObserverMode")}

		CTerrorPlayer["SetSurvivorCharacter"] <- function(survivorCharacter){SetPropInt("m_survivorCharacter", survivorCharacter.tointeger())}
		CTerrorPlayer["GetSurvivorCharacter"] <- function(){return GetPropInt("m_survivorCharacter")}

		CTerrorPlayer["IsCalm"] <- function(){return GetPropInt("m_isCalm")}

		CTerrorPlayer["SetCustomAbility"] <- function(customAbility){SetPropEntity("m_customAbility", customAbility)}
		CTerrorPlayer["GetCustomAbility"] <- function(){return GetPropEntity("m_customAbility")}

		CTerrorPlayer["SetSurvivorGlowEnabled"] <- function(survivorGlowEnabled){SetPropInt("m_bSurvivorGlowEnabled", survivorGlowEnabled.tointeger())}

		CTerrorPlayer["GetIntensity"] <- function(){return GetPropInt("m_clientIntensity")}

		CTerrorPlayer["IsFallingFromLedge"] <- function(){return GetPropInt("m_isFallingFromLedge")}

		CTerrorPlayer["ClearJumpSuppression"] <- function(){SetPropFloat("m_jumpSupressedUntil", 0)}
		CTerrorPlayer["SuppressJump"] <- function(time){SetPropFloat("m_jumpSupressedUntil", Time() + time.tofloat())}

		CTerrorPlayer["SetMaxHealth"] <- function(maxHealth){SetPropInt("m_iMaxHealth", maxHealth.tointeger())}

		CTerrorPlayer["SetAirMovementRestricted"] <- function(airMovementRestricted){SetPropInt("m_airMovementRestricted", airMovementRestricted.tointeger())}
		CTerrorPlayer["GetAirMovementRestricted"] <- function(){return GetPropInt("m_airMovementRestricted")}

		CTerrorPlayer["GetCurrentFlowDistance"] <- function(){return GetCurrentFlowDistanceForPlayer(this)}
		CTerrorPlayer["GetCurrentFlowPercent"] <- function(){return GetCurrentFlowPercentForPlayer(this)}

		CTerrorPlayer["GetCharacterName"] <- function(){return GetCharacterDisplayName(this)}

		CTerrorPlayer["Say"] <- function(message, teamOnly = false){::Say(this, message, teamOnly)}

		CTerrorPlayer["IsBot"] <- function(){return IsPlayerABot(this)}

		CTerrorPlayer["PickupObject"] <- function(entity){PickupObject(this, entity)}

		CTerrorPlayer["SetAngles"] <- function(angles){
			local prevPlayerName = GetName()
			local playerName = UniqueString()
			SetName(playerName)
			local teleportEntity = SpawnEntityFromTable("point_teleport", {origin = GetOrigin(), angles = angles.ToKVString(), target = playerName, targetname = UniqueString()})
			DoEntFire("!self", "Teleport", "", 0, null, teleportEntity)
			DoEntFire("!self", "Kill", "", 0, null, teleportEntity)
			DoEntFire("!self", "AddOutput", "targetname " + prevPlayerName, 0.01, null, this)
		}

		CTerrorPlayer["GetLifeState"] <- function(){return GetPropInt("m_lifeState")}

		CTerrorPlayer["PlaySound"] <- function(soundName){EmitSoundOn(soundName, this)}
		CTerrorPlayer["StopSound"] <- function(soundName){StopSoundOn(soundName, this)}

		CTerrorPlayer["PlaySoundOnClient"] <- function(soundName){EmitSoundOnClient(soundName, this)}

		CTerrorPlayer["GetAmmo"] <- function(weapon){return GetPropIntArray("m_iAmmo", weapon.GetPropInt("m_iPrimaryAmmoType"))}
		CTerrorPlayer["SetAmmo"] <- function(weapon, ammo){SetPropIntArray("m_iAmmo", weapon.GetPropInt("m_iPrimaryAmmoType"), ammo)}
	}
	
	if(Time() > 0.034){
		func()
	} else {
		DoNextTick(func)
	}
}

/**
 * Registers a listener that will call a function when the given check function returns true
 */
function RegisterFunctionListener(checkFunction, callFunction, args, singleUse){
	local errorMessage = "Failed to register function listener"
	if(CheckType(checkFunction, VariableTypes.FUNCTION)){
		if(CheckType(callFunction, VariableTypes.FUNCTION)){
			if(CheckType(args, VariableTypes.TABLE)){
				if(CheckType(singleUse, VariableTypes.BOOLEAN)){
					functionListeners.append(FunctionListener(checkFunction, callFunction, args, singleUse))
					PrintInfo("Registered function listener")
					return true
				} else {
					PrintInvalidVarType(errorMessage, "singleUse", VariableTypes.BOOLEAN, typeof(singleUse))
				}
			} else {
				PrintInvalidVarType(errorMessage, "args", VariableTypes.TABLE, typeof(args))
			}
		} else {
			PrintInvalidVarType(errorMessage, "callFunction", VariableTypes.FUNCTION, typeof(callFunction))
		}
	} else {
		PrintInvalidVarType(errorMessage, "checkFunction", VariableTypes.FUNCTION, typeof(checkFunction))
	}
	return false
}

/**
 * Registers a custom weapon hook
 */
function RegisterCustomWeapon(viewmodel, worldmodel, script){
	local errorMessage = "Failed to register custom weapon"
	if(CheckType(viewmodel, VariableTypes.STRING)){
		if(CheckType(worldmodel, VariableTypes.STRING)){
			if(CheckType(script, VariableTypes.STRING)){
				local errorMessage = "Failed to register a custom weapon script "
				local scriptScope = {}
				if(!IncludeScript(script, scriptScope)){
					PrintError(errorMessage + "(Could not include script)")
					return false
				}
				if(viewmodel.slice(viewmodel.len()-4) != ".mdl"){
					viewmodel = viewmodel + ".mdl"
				}
				if(worldmodel.slice(worldmodel.len()-4) != ".mdl"){
					worldmodel = worldmodel + ".mdl"
				}
				customWeapons.append(CustomWeapon(viewmodel,worldmodel,scriptScope))
				if("OnInitialize" in scriptScope){
					scriptScope["OnInitialize"]()
				}
				PrintInfo("Registered custom weapon script " + script)
				return scriptScope
			} else {
				PrintInvalidVarType(errorMessage, "script", VariableTypes.STRING, typeof(script))
			}
		} else {
			PrintInvalidVarType(errorMessage, "worldmodel", VariableTypes.STRING, typeof(worldmodel))
		}
	} else {
		PrintInvalidVarType(errorMessage, "viewmodel", VariableTypes.STRING, typeof(viewmodel))
	}
	return false
}

/**
 * Registers various hooks
 */
function RegisterHooks(scriptScope){ //basically listens for keypresses and calls hooks
	if(CheckType(scriptScope, VariableTypes.TABLE)){
		hookScripts.append(scriptScope)
		PrintInfo("Successfully registered hooks")
		return true
	} else {
		PrintInvalidVarType("Failed to register hooks", "scriptScope", VariableTypes.TABLE, typeof(scriptScope))
	}
	return false
}

/**
 * Registers a function to be called every tick in scriptScope
 */
function RegisterOnTick(scriptScope){
	if(CheckType(scriptScope, VariableTypes.TABLE)){
		tickScripts.append(scriptScope)
		PrintInfo("Registered OnTick")
		return true
	} else {
		PrintInvalidVarType("Failed to register OnTick", "scriptScope", VariableTypes.TABLE, typeof(scriptScope))
	}
	return false
}

/**
 * Registers a function to be called every tick
 */
function RegisterTickFunction(func){
	if(CheckType(func, VariableTypes.FUNCTION)){
		tickFunctions.append(func)
		PrintInfo("Registered tick function")
		return true
	} else {
		PrintInvalidVarType("Failed to register a tick function", "func", VariableTypes.FUNCTION, typeof(func))
	}
	return false
}

/**
 * Registers a function to be called when an entity is created
 */
function RegisterEntityCreateListener(classname, scope){
	local errorMessage = "Failed to register entity create listener"
	if(CheckType(classname, VariableTypes.STRING)){
		if(CheckType(scope, VariableTypes.TABLE)){
			entityCreateListeners.append(EntityCreateListener(classname,scope))
			PrintInfo("Registered entity create listener on " + classname + " entities")
			return true
		} else {
			PrintInvalidVarType(errorMessage, "scope", VariableTypes.STRING, typeof(scope))
		}
	} else {
		PrintInvalidVarType(errorMessage, "classname", VariableTypes.STRING, typeof(classname))
	}
	return false
}

/**
 * Registers a function to be called when an entity moves
 */
function RegisterEntityMoveListener(ent, scope){
	local errorMessage = "Failed to register entity move listener"
	if(CheckType(ent, VariableTypes.INSTANCE)){
		if(CheckType(scope, VariableTypes.TABLE)){
			entityMoveListeners.append(EntityMoveListener(ent, scope))
			PrintInfo("Registered entity move listener on " + ent)
			return true
		} else {
			PrintInvalidVarType(errorMessage, "scope", VariableTypes.TABLE, typeof(scope))
		}
	} else {
		PrintInvalidVarType(errorMessage, "ent", VariableTypes.INSTANCE, typeof(ent))
	}
	return false
}

/**
 * Registers a timer to be updated on the HUD
 */
function RegisterTimer(hudField, time, callFunction, countDown = true, formatTime = false){
	local errorMessage = "Failed to register timer"
	if(CheckType(hudField, VariableTypes.TABLE)){
		if(CheckType(time, VariableTypes.INTEGER) || CheckType(time, VariableTypes.FLOAT)){
			if(CheckType(callFunction, VariableTypes.FUNCTION)){
				if(CheckType(countDown, VariableTypes.BOOLEAN)){
					if(CheckType(formatTime, VariableTypes.BOOLEAN)){
						timers.append(Timer(hudField, time, callFunction, countDown, formatTime))
						PrintInfo("Registered hud timer")
						return true
					} else {
						PrintInvalidVarType(errorMessage, "formatTime", VariableTypes.BOOLEAN, typeof(formatTime))
					}
				} else {
					PrintInvalidVarType(errorMessage, "countDown", VariableTypes.BOOLEAN, typeof(countDown))
				}
			} else {
				PrintInvalidVarType(errorMessage, "callFunction", VariableTypes.FUNCTION, typeof(callFunction))
			}
		} else {
			PrintInvalidVarType(errorMessage, "time", VariableTypes.FLOAT, typeof(time))
		}
	} else {
		PrintInvalidVarType(errorMessage, "hudField", VariableTypes.TABLE, typeof(hudField))
	}
	return false
}

/**
 * Stops a registered timer
 */
function StopTimer(hudField){
	if(CheckType(hudField, VariableTypes.TABLE)){
		for(local i=0; i < timers.len(); i++){
			if(timers[i].GetHudField() == hudField){
				timers.remove(i)
				PrintInfo("Stopped timer")
				return true
			}
		}
		PrintInfo("Timer already stopped")
		return false
	} else {
		PrintInvalidVarType(errorMessage, "hudField", VariableTypes.TABLE, typeof(hudField))
	}
	return false
}

/**
 * Schedules a function to be called later
 */
function ScheduleTask(func, time, args = {}){ // can only check every 33 milliseconds so be careful
	local errorMessage = "Failed to schedule task"
	if(CheckType(func, VariableTypes.FUNCTION)){
		if(CheckType(time, VariableTypes.INTEGER) || CheckType(time, VariableTypes.FLOAT)){
			if(CheckType(args, VariableTypes.TABLE)){
				if(time > 0){
					tasks.append(Task(func, args, Time() + time))
					PrintInfo("Registered a task to execute at " + (Time()+time))
					return true
				} else {
					PrintError("Failed to register task (Time has to be greater than 0)")
					return false
				}
			} else {
				PrintInvalidVarType(errorMessage, "args", VariableTypes.TABLE, typeof(args))
			}
		} else {
			PrintInvalidVarType(errorMessage, "time", VariableTypes.FLOAT, typeof(time))
		}
	} else {
		PrintInvalidVarType(errorMessage, "func", VariableTypes.FUNCTION, typeof(func))
	}
	return false
}

/**
 * Schedules a function to be called next tick
 */
function DoNextTick(func, args = {}){
	if(CheckType(func, VariableTypes.FUNCTION)){
		if(CheckType(args, VariableTypes.TABLE)){
			tasks.append(Task(func, args, Time() + 0.033))
			PrintInfo("Registered a task to execute next tick")
			return true
		} else {
			PrintInvalidVarType(errorMessage, "args", VariableTypes.TABLE, typeof(args))
		}
	} else {
		PrintInvalidVarType(errorMessage, "func", VariableTypes.FUNCTION, typeof(func))
	}
	return false
}

/**
 * Registers a function to be called when a command is typed in chat
 */
function RegisterChatCommand(command, func, isInputCommand = false){
	local errorMessage = "Failed to register chat command"
	if(CheckType(command, VariableTypes.STRING)){
		if(CheckType(func, VariableTypes.FUNCTION)){
			if(CheckType(isInputCommand, VariableTypes.BOOLEAN)){
				chatCommands.append(ChatCommand(command, func, isInputCommand))
				PrintInfo("Registered chat command (isInput=" + isInputCommand + ", command=" + command + ")")
				return true
			} else {
				PrintInvalidVarType(errorMessage, "isInputCommand", VariableTypes.BOOLEAN, typeof(isInputCommand))
			}
		} else {
			PrintInvalidVarType(errorMessage, "func", VariableTypes.FUNCTION, typeof(func))
		}
	} else {
		PrintInvalidVarType(errorMessage, "command", VariableTypes.STRING, typeof(command))
	}
	return false
}

/**
 * Registers a function to be called when a convar is changed
 */
function RegisterConvarListener(convar, convarType, scope){
	local errorMessage = "Failed to register convar listener"
	if(CheckType(convar, VariableTypes.STRING)){
		if(CheckType(convarType, VariableTypes.STRING)){
			if(CheckType(scope, VariableTypes.TABLE)){
				convarListeners.append(ConvarListener(convar, convarType, scope))
				PrintInfo("Registered convar listener")
				return true
			} else {
				PrintInvalidVarType(errorMessage, "scope", VariableTypes.TABLE, typeof(scope))
			}
		} else {
			PrintInvalidVarType(errorMessage, "convarType", VariableTypes.STRING, typeof(convarType))
		}
	} else {
		PrintInvalidVarType(errorMessage, "convar", VariableTypes.STRING, typeof(convar))
	}
	return false
}

/**
 * Registers a function to be called when a bile jar explodes on the ground
 */
function RegisterBileExplodeListener(scope){
	if(CheckType(scope, VariableTypes.TABLE)){
		bileExplodeListeners.append(ThrowableExplodeListener(scope))
		PrintInfo("Registered a bile explode listener")
		return true
	} else {
		PrintInvalidVarType("Failed to register bile explode listener", "scope", VariableTypes.TABLE, typeof(scope))
	}
	return false
}

/**
 * Registers a function to be called when a molotov explodes on the ground
 */
function RegisterMolotovExplodeListener(scope){
	if(CheckType(scope, VariableTypes.TABLE)){
		molotovExplodeListeners.append(ThrowableExplodeListener(scope))
		PrintInfo("Registered a molotov explode listener")
		return true
	} else {
		PrintInvalidVarType("Failed to register molotov explode listener", "scope", VariableTypes.TABLE, typeof(scope))
	}
	return false
}

/**
 * Locks an entity by constantly setting its position
 */
function LockEntity(entity){
	if(CheckType(entity, VariableTypes.INSTANCE)){
		lockedEntities.append(LockedEntity(entity, entity.GetAngles(), entity.GetOrigin))
		PrintInfo("Locked entity: " + entity)
		return true
	} else {
		PrintInvalidVarType("Failed to lock entity", "entity", VariableTypes.INSTANCE, typeof(entity))
	}
	return false
}

/**
 * Unlocks a previously locked entity
 */
function UnlockEntity(entity){
	if(CheckType(entity, VariableTypes.INSTANCE)){
		for(local i=0; i < lockedEntities.len(); i++){
			if(lockedEntities[i] == entity){
				lockedEntities.remove(i)
				return true
			}
		}
		return true
	} else {
		PrintInvalidVarType("Failed to unlock entity", "entity", VariableTypes.INSTANCE, typeof(entity))
	}
	return false
}

/*
function OnGameEvent_tongue_grab(params){
	PlayerRestricted(params.victim)	
}
function OnGameEvent_choke_start(params){
	PlayerRestricted(params.victim)	
}
function OnGameEvent_lunge_pounce(params){
	PlayerRestricted(params.victim)	
}
function OnGameEvent_charger_carry_start(params){
	PlayerRestricted(params.victim)	
}
function OnGameEvent_charger_pummel_start(params){
	PlayerRestricted(params.victim)	
}
function OnGameEvent_jockey_ride(params){
	PlayerRestricted(params.victim)	
}

function OnGameEvent_tongue_release(params){
	if("victim" in params)
	{
		PlayerReleased(params.victim)
	}
}
function OnGameEvent_choke_end(params){
	if("victim" in params)
	{
		PlayerReleased(params.victim)
	}
}
function OnGameEvent_pounce_end(params){
	if("victim" in params)
	{
		PlayerReleased(params.victim)
	}
}
function OnGameEvent_pounce_stopped(params){
	if("victim" in params)
	{
		PlayerReleased(params.victim)
	}
}
function OnGameEvent_charger_carry_end(params){
	if("victim" in params)
	{
		PlayerReleased(params.victim)
	}
}
function OnGameEvent_charger_pummel_end(params){
	if("victim" in params)
	{
		PlayerReleased(params.victim)
	}
}
function OnGameEvent_jockey_ride_end(params){
	if("victim" in params)
	{
		PlayerReleased(params.victim)
	}
}
function PlayerRestricted(playerId){
	local player = FindPlayerObject(GetPlayerFromUserID(playerId))
	if(player != null){
		player.SetDisabled(true)
	}
}
function PlayerReleased(playerId){
	local player = FindPlayerObject(GetPlayerFromUserID(playerId))
	if(player != null){
		player.SetDisabled(false)
	}
}
*/

/**
 * Returns true if the message matches the specified command
 */
local function IsCommand(msg, command){
	local message = ""
	local found_start = false
	local found_end = false
	local last_char = 0
	foreach(char in msg){
		if(char != CHAR_SPACE && char != CHAR_NEWLINE){
			if(!found_start){
				found_start = true
			}
			message += char.tochar()
		} else if(char == CHAR_SPACE){
			if(last_char != CHAR_SPACE){
				found_end = true
			}
			if(found_start && !found_end){
				message += char.tochar()
			}
		}
	}
	return message == command
}

/**
 * Returns input if the message matches the command, otherwise returns false
 */
local function GetInputCommand(msg, command){
	local message = ""
	local found_start = false
	local found_end = false
	local last_char = 0
	local index = 0
	foreach(char in msg){
		if(char != CHAR_SPACE && char != CHAR_NEWLINE){
			if(!found_start){
				found_start = true
			}
			message += char.tochar()
		} else if(char == CHAR_SPACE){
			if(last_char != CHAR_SPACE){
				found_end = true
				if(message != command || index == msg.len() - 1){
					return false
				}
				return msg.slice(index + 1, msg.len())
			}
			if(found_start && !found_end){
				message += char.tochar()
			}
		}
		index += 1
	}
	return false
}


function OnGameEvent_player_say(params){
	local text = params["text"]
	local ent = GetPlayerFromUserID(params["userid"])
	
	foreach(command in chatCommands){ 
		if(command.IsInputCommand()){
			local input = GetInputCommand(text, ent, command.GetCommand())
			if(input != false){
				command.CallFunction(ent, input)
			}
		} else {
			if(IsCommand(text, command.GetCommand())){
				command.CallFunction(ent)
			}
		}
	}
}

__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)