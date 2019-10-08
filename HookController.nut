/* Copyright notice
 * Copyright (c) 2019 Daroot Leafstorm
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
*/


/* Ideas
	make OnEquipped and OnUnequipped for non-custom weapons?
	make hooked functions use tables? (like VSLib)
	use multiple timers to reduce long hangs?
	add response rule library?
	migrate to using EntFire?
*/

/* Options
fire custom weapon while restricted (default is off)
print debug info (default is on)
*/

/* Changelog
	v1.0.1 - 8/10/19
		Added SetPlayerAngles
		Made chat commands case insensitive
		Fixed input commands not being recognized
	v1.0.0 - 8/10/19
		Added checks to stop duplicate calls to hooks
*/

/* Documentation

table Keys - Contains all possible key inputs

table VariableTypes - Contains all possible variable types

table Characters - Contains a few characters for cleaner code

table Flags - Contains bit positions for m_fFlags

table RenderFX - Contains render effect types

table EntityEffects - Contains bit positions for entity effects

table RenderModes - Contains render modes

table MoveTypes - Contains player move types

table DamageTypes - Contains bit positions for damage types

table SolidTypes - Contains solidity types

table SolidFlags - Contains bit positions for solidity flags

table MoveCollide - Contains move collide types

table CollisionGroups - Contains collision group types

table TraceContent - Contains bit positions for trace content flags

table TraceMasks - Contains trace mask types

table BotCommands - Contains bot command types

table BotSense - Contains bit positions for bot sense flags

table HUDPositions - Contains enumerated HUD positions

table HUDFlags - Contains bit positions for HUD flags

table ZombieTypes - Contains zombie types

function ImprovedMethodsIncluded() - Checks if ImprovedMethods is fully included
	returns: bool included

function IncludeImprovedMethods() - Adds extra methods that can be called on entity handles

function RegisterFunctionListener(function checkFunction, function callFunction, table args, bool singleUse) - Registers a listener that waits for the checkFunction to return true
	returns: bool success
	calls: 
		callFunction()
	arguments:
		checkFunction - function called to check whether to return true or false
		callFunction - function called when checkFunction returns true
		args - table with args that checkFunction can use
		singleUse - should this listener be removed after calling callFunction
		
function RegisterCustomWeapon(string viewmodel, string worldmodel, string script) - Registers a custom weapon script
	returns: bool success
	calls: 
		OnInitialize() - called when done registering
		OnTick() - called every server tick
		OnReleased(entity playerWeapon, entity player) - called when a player is no longer restricted from using the custom weapon
		OnRestricted(entity playerWeapon, entity player) - called when a player becomes restricted from using the custom weapon
		OnPickup(entity newWeapon, entity player) - called when a player picks up the custom weapon
		OnDrop(entity droppedWeapon, entity player) - called when a player drops the custom weapon
		OnInventoryChange(entity player, array droppedWeapons, array newWeapons) - called when a player's inventory changes
		OnKeyPressStart_key(entity player, entity weapon)
		OnKeyPressTick_key(entity player, entity weapon)
		OnKeyPressEnd_key(entity player, entity weapon)
			see RegisterHooks for key names
	arguments:
		viewmodel - path to viewmodel file
		worldmodel - path to worldmodel file
		script - script name to include

function RegisterHooks(table scriptScope) - Registers various misc hooks
	returns: bool success
	calls:
		OnTick() - called every tick
		OnInventoryChange(entity player, array droppedWeapons, array newWeapons) - called when a player's inventory changes
		OnKeyPressStart_key(entity player, entity weapon) and OnKeyPressTick_key(entity player, entity weapon) and OnKeyPressEnd_key(entity player, entity weapon)
			keys:
				Attack
				Jump
				Crouch
				Forward
				Backward
				Use
				Cancel
				Left
				Right
				MoveLeft
				MoveRight
				Attack2
				Run
				Reload
				Alt1
				Alt2
				Showscores
				Speed
				Walk
				Zoom
				Weapon1
				Weapon2
				Bullrush
				Grenade1
				Grenade2
				Lookspin
	arguments:
		scriptScope - scope to call the functions in

function RegisterOnTick(table scriptScope) - Registers a hook called every tick
	returns: bool success
	calls: 
		OnTick() - called every tick
	arguments:
		scriptScope - scope to call the OnTick function in

function RegisterTickFunction(function func) - Registers a function to be called every tick
	returns: bool success
	calls:
		func()
	arguments:
		func - function to be called every tick
		
function RegisterEntityCreateListener(string classname, table scope) - Registers a listener to check for entity spawning/creation
	returns: bool success
	calls:
		OnEntCreate_classname(entity ent) - called when a new entity with the specified classname is created
	arguments:
		classname - the class name to listen for spawning
		scope - scope to call the OnEntCreate_classname function in
		
function RegisterEntityMoveListener(entity ent, table scope) - Registers a listener to watch for movement on ent
	returns: bool success
	calls:
		OnEntityMove(entity ent) - called when the ent moves
	arguments:
		ent - entity to watch for movement
		scope - scope to call the OnEntityMove function in

function RegisterTimer(table hudField, float time, function callFunction, bool countDown = true, bool formatTime = false) - Registers a HUD timer
	returns: bool success
	calls:
		callFunction()
	arguments:
		hudField - hud field to use as timer
		time - time to count down or up to
		callFunction - function called when time is reached
		countDown - should count down or up
		formatTime - should format time as mm:ss
		
function StopTimer(table hudField) - Stops a currently running timer
	returns: bool success
	arguments:
		hudField - hud field already used as a timer
		
function ScheduleTask(function func, float time, table args = {}, bool timestamp = false) - Registers a task to execute in the future
	returns: bool success
	calls:
		func()
	arguments: 
		func - function to be called when time is reached
		time - time to wait (or timestamp)
		args - table with variables that can be used by func
		timestamp - interpret time as a timestamp
		
function DoNextTick(function func, table args = {}) - Registers a task to execute next tick
	returns: bool success
	calls:
		func()
	arguments: 
		func - function to be called when time is reached
		args - table with variables that can be used by func
	
function RegisterChatCommand(string command, function func, bool isInputCommand = false) - Registers a chat command
	returns: bool success
	calls:
		func(entity ent) or func(entity ent, string input)
	arguments:
		command - text to respond to
		func - function to be called when someone types the chat command
		isInputCommand - if the command should check for input after the command string

function RegisterConvarListener(string convar, string convarType, table|instance scope) - Registers a listener for a convar
	returns: bool success
	calls:
		OnConvarChange_convar(string|float previousValue, string|float newValue)
	arguments:
		convar - convar to watch for changes
		convarType - type of convar (string or float)
		scope - scope to call the OnConvarChange_convar function in

function RegisterTankRockExplodeListener(table scope) - Registers a listener for tank rocks exploding
	returns: bool success
	calls: 
		OnRockExplode(entity thrower, vector startPosition, vector position)
	arguments:
		scope - scope to call the OnRockExplode function in

function RegisterBileExplodeListener(table scope) - Registers a listener for biles exploding
	returns: bool success
	calls:
		OnBileExplode(entity thrower, vector startPosition, vector position)
	arguments:
		scope - scope to call the OnBileExplode function in
		
function RegisterMolotovExplodeListener(table scope) - Registers a listener for molotovs exploding
	returns: bool success
	calls:
		OnMolotovExplode(entity thrower, vector startPosition, vector position)
	arguments:
		scope - scope to call the OnMolotovExplode function in

function LockEntity(entity ent) - Locks an entity by constantly setting its origin
	returns: bool success
	arguments:
		ent - entity to lock
		
function LockEntity(entity ent) - Unlocks an entity previously locked by LockEntity
	returns: bool success
	arguments:
		ent - entity to unlock

function SetTimescale(float timescale) - Sets global timescale
	returns: bool success
	arguments:
		timescale - desired timescale
		
function SendCommandToClient(entity client, string command) - Sends the command to the client's console
	returns: bool success
	arguments:
		client - client to send command to
		command - command to send to client's console
		
function SetPlayerAngles(entity player, qangle angles) - Sets the players' view angles
	arguments:
		player - player to set view angles of
		angles - angles to set the player's view to

function PlayerGenerator() - Generator function that returns players
	returns: entity player
	
function EntitiesByClassname(string classname) - Generator function that returns entities by classname
	returns: entity ent
	arguments:
		classname - classname to search for
		
function EntitiesByClassnameWithin(string classname, vector origin, float radius) - Generator function that returns entities by classname within a radius
	returns: entity ent
	arguments:
		classname - classname to search for
		origin - position to search around
		radius - radius around origin to search
		
function EntitiesByModel(string model) - Generator function that returns entities by model
	returns: entity ent
	arguments:
		model - model to search for
		
function EntitiesByName(string name) - Generator function that returns entities by name
	returns: entity ent
	arguments:
		name - name to search for
		
function EntitiesByNameWithin(string name, vector origin, float radius) - Generator function that returns entities by name within
	returns: entity ent
	arguments:
		name - name to search for
		origin - position to search around
		radius - radius around origin to search

function EntitiesByTarget(string targetname) - Generator function that returns entities by target
	returns: entity ent
	arguments:
		targetname - name of target

function EntitiesInSphere(vector origin, float radius) - Generator function that returns entities in the sphere
	returns: entity ent
	arguments:
		origin - position to search around
		radius - radius around origin to search

function EntitiesByOrder() - Generator function that returns entities ordered by ent index
	returns: entity ent

*/


if("HookController_Loaded" in this){
	return
}

Keys <- {
	ATTACK = 1
	JUMP = 2
	DUCK = 4
	FORWARD = 8
	BACKWARD = 16
	USE = 32
	CANCEL = 64
	LEFT = 128
	RIGHT = 256
	MOVELEFT = 512
	MOVERIGHT = 1024
	ATTACK2 = 2048
	RUN = 4096
	RELOAD = 8192
	ALT1 = 16384
	ALT2 = 32768
	SHOWSCORES = 65536
	SPEED = 131072
	WALK = 262144
	ZOOM = 524288
	WEAPON1 = 1048576
	WEAPON2 = 2097152
	BULLRUSH = 4194304
	GRENADE1 = 8388608
	GRENADE2 = 16777216
	LOOKSPIN = 33554432
}

VariableTypes <- {
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

Characters <- {
	SPACE = " "
	NEWLINE = "\n"
	TAB = "\t"
	RETURN = "\r"
}

CharacterCodes <- {
	SPACE = 32
	NEWLINE = 10
	TAB = 9
	RETURN = 13
}

Flags <- {
	ONGROUND = 1 // At rest / on the ground
	DUCKING = 2 // Player flag -- Player is fully crouched
	WATERJUMP = 4 // player jumping out of water
	ONTRAIN = 8 // Player is _controlling_ a train, so movement commands should be ignored on client during prediction.
	INRAIN = 16 // Indicates the entity is standing in rain
	FROZEN = 32 // Player is frozen for 3rd person camera
	ATCONTROLS = 64 // Player can't move, but keeps key inputs for controlling another entity
	CLIENT = 128 // Is a player
	FAKECLIENT = 256 // Fake client, simulated server side; don't send network messages to them
	INWATER = 512
	FLY = 1024 // Changes the SV_Movestep() behavior to not need to be on ground
	SWIM = 2048 // Changes the SV_Movestep() behavior to not need to be on ground (but stay in water)
	CONVEYOR = 4096
	NPC = 8192
	GODMODE = 16384
	NOTARGET = 32768
	AIMTARGET = 65536 // set if the crosshair needs to aim onto the entity
	PARTIALGROUND = 131072 // not all corners are valid
	STATICPROP = 262144
	GRAPHED = 524288 // worldgraph has this ent listed as something that blocks a connection
	GRENADE = 1048576
	STEPMOVEMENT = 2097152 // Changes the SV_Movestep() behavior to not do any processing
	DONTTOUCH = 4194304 // Doesn't generate touch functions, generates Untouch() for anything it was touching when this flag was set
	BASEVELOCITY = 8388608 // Base velocity has been applied this frame (used to convert base velocity into momentum)
	WORLDBRUSH = 16777216 // Not moveable/removeable brush entity (really part of the world, but represented as an entity for transparency or something)
	OBJECT = 33554432 // Terrible name. This is an object that NPCs should see. Missiles, for example.
	KILLME = 67108864 // This entity is marked for death -- will be freed by game DLL
	ONFIRE = 134217728
	DISSOLVING = 268435456
	TRANSRAGDOLL = 536870912 // In the process of turning into a client side ragdoll.
	UNBLOCKABLE_BY_PLAYER = 1073741824 // pusher that can't be blocked by the player
	FREEZING = 2147483648
}

RenderFX <- {
	NONE = 0
	PULSE_SLOW = 1
	PULSE_FAST = 2
	PULSE_SLOW_WIDE = 3
	PULSE_FAST_WIDE = 4
	FADE_SLOW = 5
	FADE_FAST = 6
	SOLID_SLOW = 7
	SOLID_FAST = 8
	STROBE_SLOW = 9
	STROBE_FAST = 10
	STROBE_FASTER = 11
	FLICKER_SLOW = 12
	FLICKER_FAST = 13
	NO_DISSIPATION = 14
	DISTORT = 15
	HOLOGRAM = 16
	EXPLODE = 17
	GLOWSHELL = 18
	CLAMP_MIN_SCALE = 19
	ENV_RAIN = 20
	ENV_SNOW = 21
	SPOTLIGHT = 22
	RAGDOLL = 23
	PULSE_FAST_WIDER = 24
}

EntityEffects <- {
	BONEMERGE = 1
	BRIGHT_LIGHT = 2
	DIM_LIGHT = 4
	NO_INTERP = 8
	NO_SHADOW = 16
	NO_DRAW = 32
	NO_RECEIVE_SHADOW = 64
	BONEMERGE_FASTCULL = 128
	ITEM_BLINK = 256
	PARENT_ANIMATES = 512
}

RenderModes <- {
	NORMAL = 0
	TRANS_COLOR = 1
	TRANS_TEXTURE = 2
	GLOW = 3
	TRANS_ALPHA = 4
	TRANS_ADD = 5
	ENVIRONMENTAL = 6
	TRANS_ADD_FRAME_BLEND = 7
	TRANS_ALPHA_ADD = 8
	WORLD_GLOW = 9
	NONE = 10
}

MoveTypes <- {
	NONE = 0
	ISOMETRIC = 1
	WALK = 2
	STEP = 3
	FLY = 4
	FLYGRAVITY = 5
	VPHYSICS = 6
	PUSH = 7
	NOCLIP = 8
	LADDER = 9
	OBSERVER = 10
	CUSTOM = 11
}

DamageTypes <- {
	GENERIC = 0
	CRUSH = 1
	BULLET = 2
	SLASH = 4
	BURN = 8
	VEHICLE = 16
	FALL = 32
	BLAST = 64
	CLUB = 128
	SHOCK = 256
	SONIC = 512
	ENERGYBEAM = 1024
	PREVENT_PHYSICS_FORCE = 2048
	NEVERGIB = 4096
	ALWAYSGIB = 8192
	DROWN = 16384
	PARALYZE = 32768
	NERVEGAS = 65536
	POISON = 131072
	RADIATION = 262144
	DROWNRECOVER = 524288
	ACID = 1048576
	MELEE = 2097152
	REMOVENORAGDOLL = 4194304
	PHYSGUN = 8388608
	PLASMA = 16777216
	STUMBLE = 33554432
	DISSOLVE = 67108864
	BLAST_SURFACE = 134217728
	DIRECT = 268435456
	BUCKSHOT = 536870912
	HEADSHOT = 1073741824
}

SolidTypes <- {
	NONE = 0
	BSP = 1
	BBOX = 2
	OBB = 3
	OBB_YAW = 4
	CUSTOM = 5
	VPHYSICS = 6
}

SolidFlags <- {
	CUSTOMRAYTEST = 1
	CUSTOMBOXTEST = 2
	NOT_SOLID = 4
	TRIGGER = 8
	NOT_STANDABLE = 16
	VOLUME_CONTENTS = 32
	FORCE_WORLD_ALIGNED = 64
	USE_TRIGGER_BOUNDS = 128
	ROOT_PARENT_ALIGNED = 256
	TRIGGER_TOUCH_DEBRIS = 512
}

MoveCollide <- {
	DEFAULT = 0
	FLY_BOUNCE = 1
	FLY_CUSTOM = 2
	FLY_SLIDE = 3
}

CollisionGroups <- {
	NONE = 0
	DEBRIS = 1
	DEBRIS_TRIGGER = 2
	INTERACTIVE_DEBRIS = 3
	INTERACTIVE = 4
	PLAYER = 5
	BREAKABLE_GLASS = 6
	VEHICLE = 7
	PLAYER_MOVEMENT = 8
	NPC = 9
	IN_VEHICLE = 10
	WEAPON = 11
	VEHICLE_CLIP = 12
	PROJECTILE = 13
	DOOR_BLOCKER = 14
	PASSABLE_DOOR = 15
	DISSOLVING = 16
	PUSHAWAY = 17
	NPC_ACTOR = 18
	NPC_SCRIPTED = 19
}

TraceContent <- {
	EMPTY = 0
	SOLID = 1
	WINDOW = 2
	AUX = 4
	GRATE = 8
	SLIME = 16
	WATER = 32
	MIST = 64
	OPAQUE = 128
	TESTFOGVOLUME = 256
	UNUSED5 = 512
	UNUSED6 = 1024
	TEAM1 = 2048
	TEAM2 = 4096
	IGNORE_NODRAW_OPAQUE = 8192
	MOVEABLE = 16384
	AREAPORTAL = 32768
	PLAYERCLIP = 65536
	MONSTERCLIP = 131072
	CURRENT_0 = 262144
	CURRENT_90 = 524288
	CURRENT_180 = 1048576
	CURRENT_270 = 2097152
	CURRENT_UP = 4194304
	CURRENT_DOWN = 8388608
	ORIGIN = 16777216
	MONSTER = 33554432
	DEBRIS = 67108864
	DETAIL = 134217728
	TRANSLUCENT = 268435456
	LADDER = 536870912
	HITBOX = 1073741824
}

TraceMasks <- {
	ALL = -1
	SOLID = 33570827
	PLAYERSOLID = 33636363
	NPCSOLID = 33701899
	WATER = 16432
	OPAQUE = 16513
	OPAQUE_AND_NPCS = 33570945
	VISIBLE = 24705
	VISIBLE_AND_NPCS = 33579137
	SHOT = 1174421507
	SHOT_HULL = 100679691
	SHOT_PORTAL = 16387
	SOLID_BRUSHONLY = 16395
	PLAYERSOLID_BRUSHONLY = 81931
	NPCSOLID_BRUSHONLY = 147467
	NPCWORLDSTATIC = 131083
	SPLITAREAPORTAL = 48
}

BotCommands <- {
	ATTACK = 0
	MOVE = 1
	RETREAT = 2
	RESET = 3
}

BotSense <- {
	CANT_SEE = 1
	CANT_HEAR = 2
	CANT_FEEL = 4
}

HUDPositions <- {
	LEFT_TOP = 0
	LEFT_BOT = 1
	MID_TOP = 2
	MID_BOT = 3
	RIGHT_TOP = 4
	RIGHT_BOT = 5
	TICKER = 6
	FAR_LEFT = 7
	FAR_RIGHT = 8
	MID_BOX = 9
	SCORE_TITLE = 10
	SCORE_1 = 11
	SCORE_2 = 12
	SCORE_3 = 13
	SCORE_4 = 14
}

HUDFlags <- {
	PRESTR = 1
	POSTSTR = 2
	BEEP = 4
	BLINK = 8
	AS_TIME = 16
	COUNTDOWN_WARN = 32
	NOBG = 64
	ALLOWNEGTIMER = 128
	ALIGN_LEFT = 256
	ALIGN_CENTER = 512
	ALIGN_RIGHT = 768
	TEAM_SURVIVORS = 1024
	TEAM_INFECTED = 2048
	TEAM_MASK = 3072
	NOTVISIBLE = 16384
}

ZombieTypes <- {
	COMMON = 0
	SMOKER = 1
	BOOMER = 2
	HUNTER = 3
	SPITTER = 4
	JOCKEY = 5
	CHARGER = 6
	WITCH = 7
	TANK = 8
	SURVIVOR = 9
	MOB = 10
	WITCHBRIDE = 11
	MUDMEN = 12
}


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
		if(type.tolower() == "string"){
			return Convars.GetStr(convar)
		} else if(type.tolower() == "float"){
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
	
	function GetCheckFunction(){
		return checkFunctionTable[checkFunctionKey]
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

class ClassListener {
	constructor(classname, func, args){
		this.classname = classname
		this.args = args
		functionKey = UniqueString("TaskFunction")
		args[functionKey] <- func
	}
	
	function GetClassname(){
		return classname
	}
	
	function CallFunction(){
		args[functionKey]()
	}
	
	classname = null
	args = null
	functionKey = null
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

// options
local debugPrint = true

local customWeapons = []
local hookScripts = []
local tickScripts = []
local tickFunctions = []
local entityMoveListeners = []
local entityCreateListeners = []
local bileExplodeListeners = []
local rockExplodeListeners = []
local molotovExplodeListeners = []
local convarListeners = []
local functionListeners = []
local classListeners = []
local chatCommands = []
local timers = []
local tasks = []
local lockedEntities = []

local rocks = []
local bileJars = []
local molotovs = []

local players = []

local clientCommand = SpawnEntityFromTable("point_clientcommand", {})

local improvedMethodsStarted = false
local improvedMethodsFinished = false


// This initializes the timer responsible for the calls to the Think function
local timer = SpawnEntityFromTable("logic_timer", {RefireTime = 0.01})
timer.ValidateScriptScope()
timer.GetScriptScope()["scope"] <- this
timer.GetScriptScope()["func"] <- function(){
	scope.Think()
}
timer.ConnectOutput("OnTimer", "func")
EntFire("!self","Enable",null,0,timer)

HookController_Loaded <- true

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
local function PrintInvalidVarType(message, parameterName, expectedType, actualType, stackLevel = 3){
	local infos = getstackinfos(stackLevel)
	
	if(typeof(expectedType) == VariableTypes.ARRAY){
		local newExpectedType = ""
		for(local i = 0; i < expectedType.len(); i++){
			if(i < expectedType.len() - 1){
				newExpectedType += expectedType[i] + " OR "
			} else {
				newExpectedType += expectedType[i]
			}
		}
		expectedType = newExpectedType
	}
	PrintError(message + "\n\n\tParameter \"" + parameterName + "\" has an invalid type '" + actualType + "' ; expected: '" + expectedType + "'\n\n\tCALL\n\t\tFUNCTION: " + infos.func + "\n\t\tSOURCE: " + infos.src + "\n\t\tLINE: " + infos.line)
}


/**
 * Checks the type of var, returns true if type matches, false otherwise
 */
local function CheckType(var, type, message = null, parameterName = null){
	if(message != null && parameterName != null && typeof(type) != VariableTypes.ARRAY && typeof(var) != type){
		PrintInvalidVarType(message, parameterName, type, typeof(var), 4)
		return false
	}
	
	if(typeof(type) == VariableTypes.ARRAY){
		local foundCorrectType = false
		foreach(typeElement in type){
			if(typeof(var) == typeElement){
				foundCorrectType = true
				break
			}
		}
		if(!foundCorrectType){
			PrintInvalidVarType(message, parameterName, type, typeof(var), 4)
			return false
		} else {
			return true
		}
	}
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
local function CallFunction(scope, funcName, ent = -1, player = -1){ // if parameters has entity (or ent), pass ent, if has player, pass player
	if(scope != null && funcName in scope && typeof(scope[funcName]) == "function"){
		/*local params = scope[funcName].getinfos().parameters
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
		}*/
		if(ent == -1 && player == -1){
			scope[funcName]()
		} else if(ent == -1){
			scope[funcName](player)
		} else if(player == -1){
			scope[funcName](ent)
		} else {
			scope[funcName](player, ent)
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

function SetImprovedMethodsFinished(){
	improvedMethodsFinished = true
}

/**
 * Called every tick, handles tasks, hooks, etc
 */
function Think(){
	if(improvedMethodsFinished || !improvedMethodsStarted){
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
		foreach(script in hookScripts){
			CallFunction(script, "OnTick")
			foreach(player in players){
				CallKeyPressFunctions(player, script, Keys.ATTACK, "Attack")
				CallKeyPressFunctions(player, script, Keys.JUMP, "Jump")
				CallKeyPressFunctions(player, script, Keys.DUCK, "Crouch")
				CallKeyPressFunctions(player, script, Keys.FORWARD, "Forward")
				CallKeyPressFunctions(player, script, Keys.BACKWARD, "Backward")
				CallKeyPressFunctions(player, script, Keys.USE, "Use")
				CallKeyPressFunctions(player, script, Keys.CANCEL, "Cancel")
				CallKeyPressFunctions(player, script, Keys.LEFT, "Left")
				CallKeyPressFunctions(player, script, Keys.RIGHT, "Right")
				CallKeyPressFunctions(player, script, Keys.MOVELEFT, "MoveLeft")
				CallKeyPressFunctions(player, script, Keys.MOVERIGHT, "MoveRight")
				CallKeyPressFunctions(player, script, Keys.ATTACK2, "Attack2")
				CallKeyPressFunctions(player, script, Keys.RUN, "Run")
				CallKeyPressFunctions(player, script, Keys.RELOAD, "Reload")
				CallKeyPressFunctions(player, script, Keys.ALT1, "Alt1")
				CallKeyPressFunctions(player, script, Keys.ALT2, "Alt2")
				CallKeyPressFunctions(player, script, Keys.SHOWSCORES, "Showscores")
				CallKeyPressFunctions(player, script, Keys.SPEED, "Speed")
				CallKeyPressFunctions(player, script, Keys.WALK, "Walk")
				CallKeyPressFunctions(player, script, Keys.ZOOM, "Zoom")
				CallKeyPressFunctions(player, script, Keys.WEAPON1, "Weapon1")
				CallKeyPressFunctions(player, script, Keys.WEAPON2, "Weapon2")
				CallKeyPressFunctions(player, script, Keys.BULLRUSH, "Bullrush")
				CallKeyPressFunctions(player, script, Keys.GRENADE1, "Grenade1")
				CallKeyPressFunctions(player, script, Keys.GRENADE2, "Grenade2")
				CallKeyPressFunctions(player, script, Keys.LOOKSPIN, "Lookspin")
			}
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
		
		if(rockExplodeListeners.len() > 0){
			for(local i = 0; i < rocks.len(); i++){
				local rock = rocks[i]
				if(rock.CheckRemoved()){
					foreach(listener in rockExplodeListeners){
						if("OnRockExplode" in listener.GetScope() && CheckType(listener.GetScope()["OnRockExplode"], VariableTypes.FUNCTION)){
							listener.GetScope()["OnRockExplode"](rock.GetThrower(), rock.GetStartPosition(), rock.GetLastPosition())
						}
					}
					rocks.remove(i)
					i--
				} else {
					rock.SetLastPosition()
					rock.SetLastVelocity()
				}
			}
			
			local newRock = null
			while(newRock = Entities.FindByClassname(newRock, "tank_rock")){
				local foundInstance = false
				foreach(rock in rocks){
					if(rock.GetEntity() == newRock){
						foundInstance = true
					}
				}
				if(!foundInstance){
					rocks.append(ThrownGrenade(newRock, NetProps.GetPropEntity(newRock, "m_hThrower"), newRock.GetOrigin(), newRock.GetOrigin(), newRock.GetVelocity()))
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
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.ATTACK, "Attack")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.JUMP, "Jump")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.DUCK, "Crouch")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.FORWARD, "Forward")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.BACKWARD, "Backward")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.USE, "Use")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.CANCEL, "Cancel")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.LEFT, "Left")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.RIGHT, "Right")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.MOVELEFT, "MoveLeft")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.MOVERIGHT, "MoveRight")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.ATTACK2, "Attack2")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.RUN, "Run")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.RELOAD, "Reload")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.ALT1, "Alt1")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.ALT2, "Alt2")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.SHOWSCORES, "Showscores")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.SPEED, "Speed")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.WALK, "Walk")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.ZOOM, "Zoom")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.WEAPON1, "Weapon1")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.WEAPON2, "Weapon2")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.BULLRUSH, "Bullrush")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.GRENADE1, "Grenade1")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.GRENADE2, "Grenade2")
						CallKeyPressFunctions(player, customWeapon.GetScope(), Keys.LOOKSPIN, "Lookspin")
						
						player.SetLastWeapon(player.GetEntity().GetActiveWeapon())
					} else {
						player.SetLastWeapon(player.GetEntity().GetActiveWeapon())
					}
					CallWeaponEquipFunctions(player, weaponModel)
					
			
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
	
	for(local i=0; i<tasks.len(); i++){
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
	
	for(local i=0; i < classListeners.len(); i++){
		if(classListeners[i].GetClassname() in getroottable()){
			classListeners[i].CallFunction()
			classListeners.remove(i)
			i--
		}
	}
	
	/*printl("improvedMethodsStarted: " + improvedMethodsStarted)
	printl("improvedMethodsFinished: " + improvedMethodsFinished)
	printl("CBaseEntity: " + ("CBaseEntity" in getroottable()))
	printl("CBaseAnimating: " + ("CBaseAnimating" in getroottable()))
	printl("CTerrorPlayer: " + ("CTerrorPlayer" in getroottable()))*/
	
	if(improvedMethodsStarted && !improvedMethodsFinished){
		foreach(ent in PlayerGenerator()){
			ent.GetOrigin()
			break
		}
		if("CBaseEntity" in getroottable() && "CBaseAnimating" in getroottable() && "CTerrorPlayer" in getroottable()){
			improvedMethodsFinished = true
		}
	}
}

function ImprovedMethodsIncluded(){
	return improvedMethodsFinished
}

/**
 * Adds various useful methods to common classes such as CBaseEntity and CTerrorPlayer
 */
function IncludeImprovedMethods(){
	improvedMethodsStarted = true
	
	local func_CBaseEntity = function(){
		CBaseEntity["HasProp"] <- function(propertyName){return NetProps.HasProp(this, propertyName)}
		CBaseEntity["GetPropType"] <- function(propertyName){return NetProps.GetPropType(this, propertyName)}
		CBaseEntity["GetPropArraySize"] <- function(propertyName){return NetProps.GetPropArraySize(this, propertyName)}

		CBaseEntity["GetPropInt"] <- function(propertyName){return NetProps.GetPropInt(this, propertyName)}
		CBaseEntity["GetPropEntity"] <- function(propertyName){return NetProps.GetPropEntity(this, propertyName)}
		CBaseEntity["GetPropString"] <- function(propertyName){return NetProps.GetPropString(this, propertyName)}
		CBaseEntity["GetPropFloat"] <- function(propertyName){return NetProps.GetPropFloat(this, propertyName)}
		CBaseEntity["GetPropVector"] <- function(propertyName){return NetProps.GetPropVector(this, propertyName)}
		CBaseEntity["SetPropInt"] <- function(propertyName, value){NetProps.SetPropInt(this, propertyName, value)}
		CBaseEntity["SetPropEntity"] <- function(propertyName, value){NetProps.SetPropEntity(this, propertyName, value)}
		CBaseEntity["SetPropString"] <- function(propertyName, value){NetProps.SetPropString(this, propertyName, value)}
		CBaseEntity["SetPropFloat"] <- function(propertyName, value){NetProps.SetPropFloat(this, propertyName, value)}
		CBaseEntity["SetPropVector"] <- function(propertyName, value){NetProps.SetPropVector(this, propertyName, value)}

		CBaseEntity["GetPropIntArray"] <- function(propertyName, index){return NetProps.GetPropIntArray(this, propertyName, index)}
		CBaseEntity["GetPropEntityArray"] <- function(propertyName, index){return NetProps.GetPropEntityArray(this, propertyName, index)}
		CBaseEntity["GetPropStringArray"] <- function(propertyName, index){return NetProps.GetPropStringArray(this, propertyName, index)}
		CBaseEntity["GetPropFloatArray"] <- function(propertyName, index){return NetProps.GetPropFloatArray(this, propertyName, index)}
		CBaseEntity["GetPropVectorArray"] <- function(propertyName, index){return NetProps.GetPropVectorArray(this, propertyName, index)}
		CBaseEntity["SetPropIntArray"] <- function(propertyName, index, value){NetProps.SetPropIntArray(this, propertyName, value, index)}
		CBaseEntity["SetPropEntityArray"] <- function(propertyName, index, value){NetProps.SetPropEntityArray(this, propertyName, value, index)}
		CBaseEntity["SetPropStringArray"] <- function(propertyName, index, value){NetProps.SetPropStringArray(this, propertyName, value, index)}
		CBaseEntity["SetPropFloatArray"] <- function(propertyName, index, value){NetProps.SetPropFloatArray(this, propertyName, value, index)}
		CBaseEntity["SetPropVectorArray"] <- function(propertyName, index, value){NetProps.SetPropVectorArray(this, propertyName, value, index)}

		CBaseEntity["SetProp"] <- function(propertyName, value, index = null){
			if(GetPropType(propertyName) == "integer"){
				if(GetPropArraySize(propertyName) > 1){
					if(typeof(value) == "array"){
						for(local i=0; i < value.len(); i++){
							SetPropIntArray(propertyName, i, value[i])
						}
					} else {
						SetPropIntArray(propertyName, index, value)
					}
				} else {
					SetPropInt(propertyName, value)
				}
			} else if(GetPropType(propertyName) == "float"){
				if(GetPropArraySize(propertyName) > 1){
					if(typeof(value) == "array"){
						for(local i=0; i < value.len(); i++){
							SetPropFloatArray(propertyName, i, value[i])
						}
					} else {
						SetPropFloatArray(propertyName, index, value)
					}
				} else {
					SetPropFloat(propertyName, value)
				}
			} else if(GetPropType(propertyName) == "Vector"){
				if(GetPropArraySize(propertyName) > 1){
					if(typeof(value) == "array"){
						for(local i=0; i < value.len(); i++){
							SetPropVectorArray(propertyName, i, value[i])
						}
					} else {
						SetPropVectorArray(propertyName, index, value)
					}
				} else {
					SetPropVector(propertyName, value)
				}
			} else if(GetPropType(propertyName) == "string"){
				if(GetPropArraySize(propertyName) > 1){
					if(typeof(value) == "array"){
						for(local i=0; i < value.len(); i++){
							SetPropStringArray(propertyName, i, value[i])
						}
					} else {
						SetPropStringArray(propertyName, index, value)
					}
				} else {
					SetPropString(propertyName, value)
				}
			}
		}
		CBaseEntity["GetProp"] <- function(propertyName, index = null, asArray = false){
			if(GetPropType(propertyName) == "integer"){
				if(GetPropArraySize(propertyName) > 1){
					if(asArray){
						local netpropArray = []
						for(local i=0; i < GetPropArraySize(propertyName); i++){
							netpropArray.append(GetPropIntArray(propertyName, i))
						}
						return netpropArray
					}
					return GetPropIntArray(propertyName, index)
				} else {
					return GetPropInt(propertyName)
				}
			} else if(GetPropType(propertyName) == "float"){
				if(GetPropArraySize(propertyName) > 1){
					if(asArray){
						local netpropArray = []
						for(local i=0; i < GetPropArraySize(propertyName); i++){
							netpropArray.append(GetPropFloatArray(propertyName, i))
						}
						return netpropArray
					}
					return GetPropFloatArray(propertyName, index)
				} else {
					return GetPropFloat(propertyName)
				}
			} else if(GetPropType(propertyName) == "Vector"){
				if(GetPropArraySize(propertyName) > 1){
					if(asArray){
						local netpropArray = []
						for(local i=0; i < GetPropArraySize(propertyName); i++){
							netpropArray.append(GetPropVectorArray(propertyName, i))
						}
						return netpropArray
					}
					return GetPropVectorArray(propertyName, index)
				} else {
					return GetPropVector(propertyName)
				}
			} else if(GetPropType(propertyName) == "string"){
				if(GetPropArraySize(propertyName) > 1){
					if(asArray){
						local netpropArray = []
						for(local i=0; i < GetPropArraySize(propertyName); i++){
							netpropArray.append(GetPropStringArray(propertyName, i))
						}
						return netpropArray
					}
					return GetPropStringArray(propertyName, index)
				} else {
					return GetPropString(propertyName)
				}
			}
		}

		CBaseEntity["SetRenderFX"] <- function(value){SetProp("m_nRenderFX", value.tointeger())}
		CBaseEntity["GetRenderFX"] <- function(){return GetProp("m_nRenderFX")}

		CBaseEntity["SetRenderMode"] <- function(value){SetProp("m_nRenderMode", value.tointeger())}
		CBaseEntity["GetRenderMode"] <- function(){return GetProp("m_nRenderMode")}

		CBaseEntity["GetModelIndex"] <- function(){return GetPropInt("m_nModelIndex")}
		CBaseEntity["GetModelName"] <- function(){return GetPropString("m_ModelName")}

		CBaseEntity["SetName"] <- function(name){SetPropString("m_iName", name)}

		CBaseEntity["GetFriction"] <- function(){return GetFriction(this)}
		CBaseEntity["GetPhysVelocity"] <- function(){return GetPhysVelocity(this)}

		CBaseEntity["GetFlags"] <- function(){return GetPropInt("m_fFlags")}
		CBaseEntity["SetFlags"] <- function(flag){SetPropInt("m_fFlags", flag)}
		CBaseEntity["AddFlag"] <- function(flag){SetPropInt("m_fFlags", GetPropInt("m_fFlags") | flag)}
		CBaseEntity["RemoveFlag"] <- function(flag){SetPropInt("m_fFlags", GetPropInt("m_fFlags") & ~flag)}
		CBaseEntity["HasFlag"] <- function(flag){return GetFlags() & flag}

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

		CBaseEntity["GetFlowDistance"] <- function(){return GetFlowDistanceForPosition(GetOrigin())}
		CBaseEntity["GetFlowPercent"] <- function(){return GetFlowPercentForPosition(GetOrigin())}

		CBaseEntity["PlaySound"] <- function(soundName){EmitSoundOn(soundName, this)}
		CBaseEntity["StopSound"] <- function(soundName){StopSoundOn(soundName, this)}

		CBaseEntity["Input"] <- function(input, value = "", delay = 0, activator = null){DoEntFire("!self", input.tostring(), value.tostring(), delay.tofloat(), activator, this)}
		CBaseEntity["SetAlpha"] <- function(alpha){Input("Alpha", alpha)}
		CBaseEntity["Enable"] <- function(){Input("Enable")}
		CBaseEntity["Disable"] <- function(){Input("Disable")}
		CBaseEntity["GetValidatedScriptScope"] <- function(){
			ValidateScriptScope()
			return GetScriptScope()
		}


		// Beginning of entity specific NetProps
		CBaseEntity["SetStartScale"] <- function(startScale){SetProp("m_flStartScale", startScale.tofloat())}
		CBaseEntity["GetStartScale"] <- function(){return GetProp("m_flStartScale")}
			
		CBaseEntity["SetScale"] <- function(scale){SetProp("m_flScale", scale.tofloat())}
		CBaseEntity["GetScale"] <- function(){return GetProp("m_flScale")}
			
		CBaseEntity["SetScaleTime"] <- function(scaleTime){SetProp("m_flScaleTime", scaleTime.tofloat())}
		CBaseEntity["GetScaleTime"] <- function(){return GetProp("m_flScaleTime")}
			
		CBaseEntity["SetFlags"] <- function(flags){SetProp("m_nFlags", flags.tointeger())}
		CBaseEntity["GetFlags"] <- function(){return GetProp("m_nFlags")}
			
		CBaseEntity["SetFlameModelIndex"] <- function(flameModelIndex){SetProp("m_nFlameModelIndex", flameModelIndex.tointeger())}
		CBaseEntity["GetFlameModelIndex"] <- function(){return GetProp("m_nFlameModelIndex")}
			
		CBaseEntity["SetFlameFromAboveModelIndex"] <- function(flameFromAboveModelIndex){SetProp("m_nFlameFromAboveModelIndex", flameFromAboveModelIndex.tointeger())}
		CBaseEntity["GetFlameFromAboveModelIndex"] <- function(){return GetProp("m_nFlameFromAboveModelIndex")}


		CBaseEntity["SetStartScale"] <- function(startScale){SetProp("m_flStartScale", startScale.tofloat())}
		CBaseEntity["GetStartScale"] <- function(){return GetProp("m_flStartScale")}
			
		CBaseEntity["SetScale"] <- function(scale){SetProp("m_flScale", scale.tofloat())}
		CBaseEntity["GetScale"] <- function(){return GetProp("m_flScale")}
			
		CBaseEntity["SetScaleTime"] <- function(scaleTime){SetProp("m_flScaleTime", scaleTime.tofloat())}
		CBaseEntity["GetScaleTime"] <- function(){return GetProp("m_flScaleTime")}
			
		CBaseEntity["SetPlasmaModelIndex"] <- function(plasmaModelIndex){SetProp("m_nPlasmaModelIndex", plasmaModelIndex.tointeger())}
		CBaseEntity["GetPlasmaModelIndex"] <- function(){return GetProp("m_nPlasmaModelIndex")}
			
		CBaseEntity["SetPlasmaModelIndex2"] <- function(plasmaModelIndex2){SetProp("m_nPlasmaModelIndex2", plasmaModelIndex2.tointeger())}
		CBaseEntity["GetPlasmaModelIndex2"] <- function(){return GetProp("m_nPlasmaModelIndex2")}
			
		CBaseEntity["SetGlowModelIndex"] <- function(glowModelIndex){SetProp("m_nGlowModelIndex", glowModelIndex.tointeger())}
		CBaseEntity["GetGlowModelIndex"] <- function(){return GetProp("m_nGlowModelIndex")}


		CBaseEntity["SetCharging"] <- function(charging){SetProp("m_isCharging", charging.tointeger())}
		CBaseEntity["IsCharging"] <- function(){return GetProp("m_isCharging")}
			
		CBaseEntity["SetOwner"] <- function(value){SetPropEntity("m_owner", value)}
		CBaseEntity["GetOwner"] <- function(value){return GetPropEntity("m_owner")}
			
		CBaseEntity["SetChargeStartTime"] <- function(chargeStartTime){SetProp("m_chargeStartTime", chargeStartTime.tofloat())}
		CBaseEntity["GetChargeStartTime"] <- function(){return GetProp("m_chargeStartTime")}
			
		CBaseEntity["SetPotentialTarget"] <- function(potentialTarget){SetPropEntity("m_hPotentialTarget", potentialTarget)}
		CBaseEntity["GetPotentialTarget"] <- function(){return GetPropEntity("m_hPotentialTarget")}


		CBaseEntity["SetLeaping"] <- function(leaping){SetProp("m_isCharging", leaping.tointeger())}
		CBaseEntity["IsLeaping"] <- function(){return GetProp("m_isLeaping")}
			
		CBaseEntity["SetOwner"] <- function(value){SetPropEntity("m_owner", value)}
		CBaseEntity["GetOwner"] <- function(value){return GetPropEntity("m_owner")}
			
		CBaseEntity["SetLeapStartTime"] <- function(leapStartTime){SetProp("m_leapStartTime", leapStartTime.tofloat())}
		CBaseEntity["GetLeapStartTime"] <- function(){return GetProp("m_leapStartTime")}
			
		CBaseEntity["SetQueuedLeap"] <- function(queuedLeap){SetProp("m_queuedLeap", queuedLeap)}
		CBaseEntity["GetQueuedLeap"] <- function(){return GetProp("m_queuedLeap")}


		CBaseEntity["SetLunging"] <- function(lunging){SetProp("m_isCharging", lunging.tointeger())}
		CBaseEntity["IsLunging"] <- function(){return GetProp("m_isLunging")}
			
		CBaseEntity["SetOwner"] <- function(value){SetPropEntity("m_owner", value)}
		CBaseEntity["GetOwner"] <- function(value){return GetPropEntity("m_owner")}
			
		CBaseEntity["SetLungeStartTime"] <- function(lungeStartTime){SetProp("m_lungeStartTime", lungeStartTime.tofloat())}
		CBaseEntity["GetLungeStartTime"] <- function(){return GetProp("m_lungeStartTime")}
			
		CBaseEntity["SetQueuedLeap"] <- function(queuedLeap){SetProp("m_queuedLeap", queuedLeap)}
		CBaseEntity["GetQueuedLeap"] <- function(){return GetProp("m_queuedLeap")}


		CBaseEntity["SetActivated"] <- function(hasBeenActivated){SetProp(m_bHasBeenActivated, hasBeenActivated.tointeger())}
		CBaseEntity["HasBeenActivated"] <- function(){return GetProp("m_bHasBeenActivated")}
			
		CBaseEntity["SetOwner"] <- function(value){SetPropEntity("m_owner", value)}
		CBaseEntity["GetOwner"] <- function(value){return GetPropEntity("m_owner")}


		CBaseEntity["SetActivated"] <- function(hasBeenActivated){SetProp(m_bHasBeenActivated, hasBeenActivated.tointeger())}
		CBaseEntity["HasBeenActivated"] <- function(){return GetProp("m_bHasBeenActivated")}
			
		CBaseEntity["SetOwner"] <- function(value){SetPropEntity("m_owner", value)}
		CBaseEntity["GetOwner"] <- function(value){return GetPropEntity("m_owner")}


		CBaseEntity["SetTongueGrabStartingHealth"] <- function(tongueGrabStartingHealth){SetProp("m_tongueGrabStartingHealth", tongueGrabStartingHealth.tointeger())}
		CBaseEntity["GetTongueGrabStartingHealth"] <- function(){return GetProp("m_tongueGrabStartingHealth")}
			
		CBaseEntity["SetOwner"] <- function(value){SetPropEntity("m_owner", value)}
		CBaseEntity["GetOwner"] <- function(value){return GetPropEntity("m_owner")}
			
		CBaseEntity["SetTongueHitRange"] <- function(tongueHitRange){SetProp("m_tongueHitRange", tongueHitRange.tofloat())}
		CBaseEntity["GetTongueHitRange"] <- function(){return GetProp("m_tongueHitRange")}
			
		CBaseEntity["SetTongueHitTimestamp"] <- function(tongueHitTimestamp){SetProp("m_tongueHitTimestamp", tongueHitTimestamp.tofloat())}
		CBaseEntity["GetTongueHitTimestamp"] <- function(){return GetProp("m_tongueHitTimestamp")}
			
		CBaseEntity["SetTongueHitWasAmbush"] <- function(tongueHitWasAmbush){SetProp("m_tongueHitWasAmbush", tongueHitWasAmbush.tointeger())}
		CBaseEntity["GetTongueHitWasAmbush"] <- function(){return GetProp("m_tongueHitWasAmbush")}
			
		CBaseEntity["SetTongueVictimDistance"] <- function(tongueVictimDistance){SetProp("m_tongueVictimDistance", tongueVictimDistance.tofloat())}
		CBaseEntity["GetTongueVictimDistance"] <- function(){return GetProp("m_tongueVictimDistance")}
			
		CBaseEntity["SetTongueVictimPositionTime"] <- function(tongueVictimPositionTime){SetProp("m_tongueVictimPositionTime", tongueVictimPositionTime.tofloat())}
		CBaseEntity["GetTongueVictimPositionTime"] <- function(){return GetProp("m_tongueVictimPositionTime")}
			
		CBaseEntity["SetTongueVictimLastOnGroundTime"] <- function(tongueVictimLastOnGroundTime){SetProp("m_tongueVictimLastOnGroundTime", tongueVictimLastOnGroundTime.tofloat())}
		CBaseEntity["GetTongueVictimLastOnGroundTime"] <- function(){return GetProp("m_tongueVictimLastOnGroundTime")}
			
		CBaseEntity["SetPotentialTarget"] <- function(potentialTarget){SetPropEntity("m_hPotentialTarget", potentialTarget)}
		CBaseEntity["GetPotentialTarget"] <- function(){return GetPropEntity("m_hPotentialTarget")}
			
		CBaseEntity["SetCurrentTipTarget"] <- function(currentTipTarget){SetPropEntity("m_currentTipTarget", currentTipTarget)}
		CBaseEntity["GetCurrentTipTarget"] <- function(){return GetPropEntity("m_currentTipTarget")}
			
		CBaseEntity["SetTongueState"] <- function(tongueState){SetProp("m_tongueState", tongueState.tointeger())}
		CBaseEntity["GetTongueState"] <- function(){return GetProp("m_tongueState")}
			
		CBaseEntity["SetBendPointCount"] <- function(bendPointCount){SetProp("m_bendPointCount", bendPointCount.tointeger())}
		CBaseEntity["GetBendPointCount"] <- function(){return GetProp("m_bendPointCount")}
			
		CBaseEntity["SetTipPosition"] <- function(tipPosition){SetProp("m_tipPosition", tipPosition)}
		CBaseEntity["GetTipPosition"] <- function(){return GetProp("m_tipPosition")}
			
		CBaseEntity["SetBendPositions"] <- function(bendPositions){SetProp("m_bendPositions", bendPositions)}
		CBaseEntity["GetBendPositions"] <- function(){return GetProp("m_bendPositions", null, true)}
		CBaseEntity["SetBendPosition"] <- function(bendPosition, index){SetProp("m_bendPositions", bendPosition, index)}
		CBaseEntity["GetBendPosition"] <- function(index){return GetProp("m_bendPositions", index)}


		CBaseEntity["SetSpraying"] <- function(spraying){SetProp("m_isSpraying", spraying.tointeger())}
		CBaseEntity["IsSpraying"] <- function(){return GetProp("m_isSpraying")}
			
		CBaseEntity["SetOwner"] <- function(value){SetPropEntity("m_owner", value)}
		CBaseEntity["GetOwner"] <- function(value){return GetPropEntity("m_owner")}
			
		CBaseEntity["SetAttackDuration"] <- function(attackDuration){SetProp("m_attackDuration.m_duration", attackDuration.tofloat())}
		CBaseEntity["GetAttackDuration"] <- function(){return GetProp("m_attackDuration.m_duration")}
		CBaseEntity["SetAttackDurationTimestamp"] <- function(attackDurationTimestamp){SetProp("m_attackDuration.m_timestamp", attackDurationTimestamp.tofloat())}
		CBaseEntity["GetAttackDurationTimestamp"] <- function(){return GetProp("m_attackDuration.m_timestamp")}
			
		CBaseEntity["SetNextSprayDuration"] <- function(nextSprayDuration){SetProp("m_nextSpray.m_duration", nextSprayDuration.tofloat())}
		CBaseEntity["GetNextSprayDuration"] <- function(){return GetProp("m_nextSpray.m_duration")}
		CBaseEntity["SetNextSprayTimestamp"] <- function(nextSprayTimestamp){SetProp("m_nextSpray.m_timestamp", nextSprayTimestamp.tofloat())}
		CBaseEntity["GetNextSprayTimestamp"] <- function(){return GetProp("m_nextSpray.m_timestamp")}


		CBaseEntity["SetBeamType"] <- function(beamType){SetProp("m_nBeamType", beamType.tointeger())}
		CBaseEntity["GetBeamType"] <- function(){return GetProp("m_nBeamType")}
			
		CBaseEntity["SetBeamFlags"] <- function(beamFlags){SetProp("m_nBeamFlags", beamFlags.tointeger())}
		CBaseEntity["GetBeamFlags"] <- function(){return GetProp("m_nBeamFlags")}
			
		CBaseEntity["SetNumBeamEnts"] <- function(numBeamEnts){SetProp("m_nNumBeamEnts", numBeamEnts.tointeger())}
		CBaseEntity["GetNumBeamEnts"] <- function(){return GetProp("m_nNumBeamEnts")}
			
		CBaseEntity["SetAttachEntity"] <- function(attachEntity, index){SetPropEntityArray("m_hAttachEntity", attachEntity, index)}
		CBaseEntity["GetAttachEntity"] <- function(index){return GetPropEntityArray("m_hAttachEntity", index)}
			
		CBaseEntity["SetAttachIndexes"] <- function(attachIndexes){SetProp("m_nAttachIndex", attachIndexes)}
		CBaseEntity["GetAttachIndexes"] <- function(){return GetProp("m_nAttachIndex")}
		CBaseEntity["SetAttachIndex"] <- function(attachIndex, index){SetProp("m_nAttachIndex", attachIndex.tointeger(), index)}
		CBaseEntity["GetAttachIndex"] <- function(index){return GetProp("m_nAttachIndex", index)}
			
		CBaseEntity["SetHaloIndex"] <- function(haloIndex){SetProp("m_nHaloIndex", haloIndex.tointeger())}
		CBaseEntity["GetHaloIndex"] <- function(){return GetProp("m_nHaloIndex")}
			
		CBaseEntity["SetHaloScale"] <- function(haloScale){SetProp("m_fHaloScale", haloScale.tofloat())}
		CBaseEntity["GetHaloScale"] <- function(){return GetProp("m_fHaloScale")}
			
		CBaseEntity["SetWidth"] <- function(width){SetProp("m_fWidth", width.tofloat())}
		CBaseEntity["GetWidth"] <- function(){return GetProp("m_fWidth")}
			
		CBaseEntity["SetEndWidth"] <- function(endWidth){SetProp("m_fEndWidth", endWidth.tofloat())}
		CBaseEntity["GetEndWidth"] <- function(){return GetProp("m_fEndWidth")}
			
		CBaseEntity["SetFadeLength"] <- function(fadeLength){SetProp("m_fFadeLength", fadeLength.tofloat())}
		CBaseEntity["GetFadeLength"] <- function(){return GetProp("m_fFadeLength")}
			
		CBaseEntity["SetAmplitude"] <- function(amplitude){SetProp("m_fAmplitude", amplitude.tofloat())}
		CBaseEntity["GetAmplitude"] <- function(){return GetProp("m_fAmplitude")}
			
		CBaseEntity["SetStartFrame"] <- function(startFrame){SetProp("m_fStartFrame", startFrame.tofloat())}
		CBaseEntity["GetStartFrame"] <- function(){return GetProp("m_fStartFrame")}
			
		CBaseEntity["SetSpeed"] <- function(speed){SetProp("m_fSpeed", speed.tofloat())}
		CBaseEntity["GetSpeed"] <- function(){return GetProp("m_fSpeed")}
			
		CBaseEntity["SetFrameRate"] <- function(frameRate){SetProp("m_flFrameRate", frameRate.tofloat())}
		CBaseEntity["GetFrameRate"] <- function(){return GetProp("m_flFrameRate")}
			
		CBaseEntity["SetHDRColorScale"] <- function(HDRColorScale){SetProp("m_flHDRColorScale", HDRColorScale.tofloat())}
		CBaseEntity["GetHDRColorScale"] <- function(){return GetProp("m_flHDRColorScale")}
			
		CBaseEntity["SetFrame"] <- function(frame){SetProp("m_flFrame", frame.tofloat())}
		CBaseEntity["GetFrame"] <- function(){return GetProp("m_flFrame")}
			
		CBaseEntity["SetEndPos"] <- function(endPos){SetProp("m_vecEndPos", endPos)}
		CBaseEntity["GetEndPos"] <- function(){return GetProp("m_vecEndPos")}


		CBaseEntity["SetHaloIndex"] <- function(haloIndex){SetProp("m_nHaloIndex", haloIndex.tointeger())}
		CBaseEntity["GetHaloIndex"] <- function(){return GetProp("m_nHaloIndex")}
			
		CBaseEntity["SetSpotlightOn"] <- function(spotlightOn){SetProp("m_bSpotlightOn", spotlightOn.tointeger())}
		CBaseEntity["IsSpotlightOn"] <- function(){return GetProp("m_bSpotlightOn")}
			
		CBaseEntity["SetHasDynamicLight"] <- function(hasDynamicLight){SetProp("m_bHasDynamicLight", hasDynamicLight.tointeger())}
		CBaseEntity["HasDynamicLight"] <- function(){return GetProp("m_bHasDynamicLight")}
			
		CBaseEntity["SetNoFog"] <- function(noFog){SetProp("m_bNoFog", noFog.tointeger())}
		CBaseEntity["GetNoFog"] <- function(){return GetProp("m_bNoFog")}
			
		CBaseEntity["SetSpotlightMaxLength"] <- function(spotlightMaxLength){SetProp("m_flSpotlightMaxLength", spotlightMaxLength.tofloat())}
		CBaseEntity["GetSpotlightMaxLength"] <- function(){return GetProp("m_flSpotlightMaxLength")}
			
		CBaseEntity["SetSpotlightGoalWidth"] <- function(spotlightGoalWidth){SetProp("m_flSpotlightGoalWidth", spotlightGoalWidth.tofloat())}
		CBaseEntity["GetSpotlightGoalWidth"] <- function(){return GetProp("m_flSpotlightGoalWidth")}
			
		CBaseEntity["SetHDRColorScale"] <- function(HDRColorScale){SetProp("m_flHDRColorScale", HDRColorScale.tofloat())}
		CBaseEntity["GetHDRColorScale"] <- function(){return GetProp("m_flHDRColorScale")}
			
		CBaseEntity["SetRotationSpeed"] <- function(rotationSpeed){SetProp("m_flRotationSpeed", rotationSpeed.tofloat())}
		CBaseEntity["GetRotationSpeed"] <- function(){return GetProp("m_flRotationSpeed")}
			
		CBaseEntity["SetRotationAxis"] <- function(rotationAxis){SetProp("m_nRotationAxis", rotationAxis.tointeger())}
		CBaseEntity["GetRotationAxis"] <- function(){return GetProp("m_nRotationAxis")}
			
		CBaseEntity["SetRotating"] <- function(value){SetProp("m_isRotating", value.tointeger())}
		CBaseEntity["GetRotating"] <- function(){return GetProp("m_isRotating")}

		CBaseEntity["SetReversed"] <- function(value){SetProp("m_isReversed", value.tointeger())}
		CBaseEntity["GetReversed"] <- function(){return GetProp("m_isReversed")}


		CBaseEntity["SetPosX"] <- function(posX, index){SetProp("m_posX", posX.tointeger(), index)}
		CBaseEntity["GetPosX"] <- function(index){return GetProp("m_posX", index)}
			
		CBaseEntity["SetPosX"] <- function(posX, index){SetProp("m_posY", posX.tointeger(), index)}
		CBaseEntity["GetPosX"] <- function(index){return GetProp("m_posY", index)}
			
		CBaseEntity["SetPosX"] <- function(posX, index){SetProp("m_posZ", posX.tointeger(), index)}
		CBaseEntity["GetPosX"] <- function(index){return GetProp("m_posZ", index)}
			
		CBaseEntity["SetPosCount"] <- function(posCount){SetProp("m_posCount", posCount.tointeger())}
		CBaseEntity["GetPosCount"] <- function(){return GetProp("m_posCount")}


		CBaseEntity["SetMinFalloff"] <- function(minFalloff){SetProp("m_MinFalloff", minFalloff.tofloat())}
		CBaseEntity["GetMinFalloff"] <- function(){return GetProp("m_MinFalloff")}
			
		CBaseEntity["SetMaxFalloff"] <- function(maxFalloff){SetProp("m_MaxFalloff", maxFalloff.tofloat())}
		CBaseEntity["GetMaxFalloff"] <- function(){return GetProp("m_MaxFalloff")}
			
		CBaseEntity["SetCurWeight"] <- function(curWeight){SetProp("m_flCurWeight", curWeight.tofloat())}
		CBaseEntity["GetCurWeight"] <- function(){return GetProp("m_flCurWeight")}
			
		CBaseEntity["SetMaxWeight"] <- function(maxWeight){SetProp("m_flMaxWeight", maxWeight.tofloat())}
		CBaseEntity["GetMaxWeight"] <- function(){return GetProp("m_flMaxWeight")}
			
		CBaseEntity["SetFadeInDuration"] <- function(fadeInDuration){SetProp("m_flFadeInDuration", fadeInDuration.tofloat())}
		CBaseEntity["GetFadeInDuration"] <- function(){return GetProp("m_flFadeInDuration")}
			
		CBaseEntity["SetFadeOutDuration"] <- function(fadeOutDuration){SetProp("m_flFadeOutDuration", fadeOutDuration.tofloat())}
		CBaseEntity["GetFadeOutDuration"] <- function(){return GetProp("m_flFadeOutDuration")}
			
		CBaseEntity["SetLookupFilename"] <- function(lookupFilename){SetProp("m_lookupFilename", lookupFilename.tostring())}
		CBaseEntity["GetLookupFilename"] <- function(){return GetProp("m_lookupFilename")}
			
		CBaseEntity["SetEnabled"] <- function(enabled){SetProp("m_bEnabled", enabled.tointeger())}
		CBaseEntity["IsEnabled"] <- function(){return GetProp("m_bEnabled")}
			
		CBaseEntity["SetMaster"] <- function(master){SetProp("m_bMaster", master.tointeger())}
		CBaseEntity["IsMaster"] <- function(){return GetProp("m_bMaster")}
			
		CBaseEntity["SetClientside"] <- function(clientside){SetProp("m_bClientSide", clientside.tointeger())}
		CBaseEntity["IsClientside"] <- function(){return GetProp("m_bClientSide")}
			
		CBaseEntity["SetExclusive"] <- function(exclusive){SetProp("m_bExclusive", exclusive.tointeger())}
		CBaseEntity["IsExclusive"] <- function(){return GetProp("m_bExclusive")}
			
		CBaseEntity["SetTimeStartFadeIn"] <- function(value){SetProp("m_flTimeStartFadeIn", value.tofloat())}
		CBaseEntity["GetTimeStartFadeIn"] <- function(){return GetProp("m_flTimeStartFadeIn")}

		CBaseEntity["SetTimeStartFadeOut"] <- function(value){SetProp("m_flTimeStartFadeOut", value.tofloat())}
		CBaseEntity["GetTimeStartFadeOut"] <- function(){return GetProp("m_flTimeStartFadeOut")}

		CBaseEntity["SetStartFadeInWeight"] <- function(value){SetProp("m_flStartFadeInWeight", value.tofloat())}
		CBaseEntity["GetStartFadeInWeight"] <- function(){return GetProp("m_flStartFadeInWeight")}

		CBaseEntity["SetStartFadeOutWeight"] <- function(value){SetProp("m_flStartFadeOutWeight", value.tofloat())}
		CBaseEntity["GetStartFadeOutWeight"] <- function(){return GetProp("m_flStartFadeOutWeight")}

		CBaseEntity["SetStartDisabled"] <- function(value){SetProp("m_bStartDisabled", value.tointeger())}
		CBaseEntity["GetStartDisabled"] <- function(){return GetProp("m_bStartDisabled")}


		CBaseEntity["SetEnabled"] <- function(enabled){SetProp("m_bEnabled", enabled.tointeger())}
		CBaseEntity["IsEnabled"] <- function(){return GetProp("m_bEnabled")}
			
		CBaseEntity["SetMaxWeight"] <- function(maxWeight){SetProp("m_MaxWeight", maxWeight.tofloat())}
		CBaseEntity["GetMaxWeight"] <- function(){return GetProp("m_MaxWeight")}
			
		CBaseEntity["SetFadeDuration"] <- function(fadeDuration){SetProp("m_FadeDuration", fadeDuration.tofloat())}
		CBaseEntity["GetFadeDuration"] <- function(){return GetProp("m_FadeDuration")}
			
		CBaseEntity["SetLookupFilename"] <- function(lookupFilename){SetProp("m_lookupFilename", lookupFilename.tostring())}
		CBaseEntity["GetLookupFilename"] <- function(){return GetProp("m_lookupFilename")}
			
		CBaseEntity["SetStartDisabled"] <- function(value){SetProp("m_bStartDisabled", value.tointeger())}
		CBaseEntity["GetStartDisabled"] <- function(){return GetProp("m_bStartDisabled")}

		CBaseEntity["SetWeight"] <- function(value){SetProp("m_Weight", value.tofloat())}
		CBaseEntity["GetWeight"] <- function(){return GetProp("m_Weight")}

		CBaseEntity["SetLastEnterWeight"] <- function(value){SetProp("m_LastEnterWeight", value.tofloat())}
		CBaseEntity["GetLastEnterWeight"] <- function(){return GetProp("m_LastEnterWeight")}

		CBaseEntity["SetLastEnterTime"] <- function(value){SetProp("m_LastEnterTime", value.tofloat())}
		CBaseEntity["GetLastEnterTime"] <- function(){return GetProp("m_LastEnterTime")}

		CBaseEntity["SetLastExitWeight"] <- function(value){SetProp("m_LastExitWeight", value.tofloat())}
		CBaseEntity["GetLastExitWeight"] <- function(){return GetProp("m_LastExitWeight")}

		CBaseEntity["SetLastExitTime"] <- function(value){SetProp("m_LastExitTime", value.tofloat())}
		CBaseEntity["GetLastExitTime"] <- function(){return GetProp("m_LastExitTime")}


		CBaseEntity["SetFreezePeriod"] <- function(freezePeriod){SetProp("m_bFreezePeriod", freezePeriod.tointeger())}
		CBaseEntity["GetFreezePeriod"] <- function(){return GetProp("m_bFreezePeriod")}
			
		CBaseEntity["SetRoundTime"] <- function(roundTime){SetProp("m_iRoundTime", roundTime.tointeger())}
		CBaseEntity["GetRoundTime"] <- function(){return GetProp("m_iRoundTime")}
			
		CBaseEntity["SetLevelStartTime"] <- function(levelStartTime){SetProp("m_fLevelStartTime", levelStartTime.tofloat())}
		CBaseEntity["GetLevelStartTime"] <- function(){return GetProp("m_fLevelStartTime")}
			
		CBaseEntity["SetGameStartTime"] <- function(gameStartTime){SetProp("m_flGameStartTime", gameStartTime.tofloat())}
		CBaseEntity["GetGameStartTime"] <- function(){return GetProp("m_flGameStartTime")}
			
		CBaseEntity["SetHostagesRemaining"] <- function(hostagesRemaining){SetProp("m_iHostagesRemaining", hostagesRemaining.tointeger())}
		CBaseEntity["GetHostagesRemaining"] <- function(){return GetProp("m_iHostagesRemaining")}
			
		CBaseEntity["SetMapHasBombTarget"] <- function(mapHasBombTarget){SetProp("m_bMapHasBombTarget", mapHasBombTarget.tointeger())}
		CBaseEntity["GetMapHasBombTarget"] <- function(){return GetProp("m_bMapHasBombTarget")}
			
		CBaseEntity["SetMapHasRescueZone"] <- function(mapHasRescueZone){SetProp("m_bMapHasRescueZone", mapHasRescueZone.tointeger())}
		CBaseEntity["GetMapHasRescueZone"] <- function(){return GetProp("m_bMapHasRescueZone")}
			
		CBaseEntity["SetLogoMap"] <- function(logoMap){SetProp("m_bLogoMap", logoMap.tointeger())}
		CBaseEntity["GetLogoMap"] <- function(){return GetProp("m_bLogoMap")}
			
		CBaseEntity["SetBlackMarket"] <- function(blackMarket){SetProp("m_bBlackMarket", blackMarket.tointeger())}
		CBaseEntity["GetBlackMarket"] <- function(){return GetProp("m_bBlackMarket")}


		CBaseEntity["SetRagdollOrigin"] <- function(ragdollOrigin){SetProp("m_vecRagdollOrigin", ragdollOrigin)}
		CBaseEntity["GetRagdollOrigin"] <- function(){return GetProp("m_vecRagdollOrigin")}
			
		CBaseEntity["SetPlayer"] <- function(player){SetPropEntity("m_hPlayer", player)}
		CBaseEntity["GetPlayer"] <- function(){return GetPropEntity("m_hPlayer")}
			
		CBaseEntity["SetRagdollVelocity"] <- function(ragdollVelocity){SetProp("m_vecRagdollVelocity", ragdollVelocity)}
		CBaseEntity["GetRagdollVelocity"] <- function(){return GetProp("m_vecRagdollVelocity")}
			
		CBaseEntity["SetDeathPose"] <- function(deathPose){SetProp("m_iDeathPose", deathPose.tointeger())}
		CBaseEntity["GetDeathPose"] <- function(){return GetProp("m_iDeathPose")}
			
		CBaseEntity["SetDeathFrame"] <- function(deathFrame){SetProp("m_iDeathFrame", deathFrame.tointeger())}
		CBaseEntity["GetDeathFrame"] <- function(){return GetProp("m_iDeathFrame")}
			
		CBaseEntity["SetOnFire"] <- function(onFire){SetProp("m_bOnFire", onFire.tointeger())}
		CBaseEntity["IsOnFire"] <- function(){return GetProp("m_bOnFire")}
			
		CBaseEntity["SetInterpOrigin"] <- function(interpOrigin){SetProp("m_bInterpOrigin", interpOrigin.tointeger())}
		CBaseEntity["IsInterpOrigin"] <- function(){return GetProp("m_bInterpOrigin")}
			
		CBaseEntity["SetRagdollType"] <- function(ragdollType){SetProp("m_ragdollType", ragdollType.tointeger())}
		CBaseEntity["GetRagdollType"] <- function(){return GetProp("m_ragdollType")}
			
		CBaseEntity["SetZombieClass"] <- function(zombieClass){SetProp("m_zombieClass", zombieClass.tointeger())}
		CBaseEntity["GetZombieClass"] <- function(){return GetProp("m_zombieClass")}
			
		CBaseEntity["SetSurvivorCharacter"] <- function(survivorCharacter){SetProp("m_survivorCharacter", survivorCharacter.tointeger())}
		CBaseEntity["GetSurvivorCharacter"] <- function(){return GetProp("m_survivorCharacter")}


		CBaseEntity["SetScore"] <- function(score){SetProp("m_iScore", score.tointeger())}
		CBaseEntity["GetScore"] <- function(){return GetProp("m_iScore")}
			
		CBaseEntity["SetRoundsWon"] <- function(roundsWon){SetProp("m_iRoundsWon", roundsWon.tointeger())}
		CBaseEntity["GetRoundsWon"] <- function(){return GetProp("m_iRoundsWon")}
			
		CBaseEntity["SetTeamName"] <- function(teamName){SetProp("m_szTeamname", teamName.tostring())}
		CBaseEntity["GetTeamName"] <- function(){return GetProp("m_szTeamname")}
			
		CBaseEntity["SetPlayers"] <- function(players){SetProp("player_array", players)}
		CBaseEntity["GetPlayers"] <- function(){return GetProp("player_array", null, true)}


		CBaseEntity["SetUseHitboxesForRenderBox"] <- function(useHitboxesForRenderBox){SetProp("m_bUseHitboxesForRenderBox", useHitboxesForRenderBox.tointeger())}
		CBaseEntity["GetUseHitboxesForRenderBox"] <- function(){return GetProp("m_bUseHitboxesForRenderBox")}
			
		CBaseEntity["SetDefaultAnim"] <- function(value){SetProp("m_iszDefaultAnim", value.tostring())}
		CBaseEntity["GetDefaultAnim"] <- function(){return GetProp("m_iszDefaultAnim")}

		CBaseEntity["SetGoalSequence"] <- function(value){SetProp("m_iGoalSequence", value.tointeger())}
		CBaseEntity["GetGoalSequence"] <- function(){return GetProp("m_iGoalSequence")}

		CBaseEntity["SetTransitionDirection"] <- function(value){SetProp("m_iTransitionDirection", value.tointeger())}
		CBaseEntity["GetTransitionDirection"] <- function(){return GetProp("m_iTransitionDirection")}

		CBaseEntity["SetRandomAnimation"] <- function(value){SetProp("m_bRandomAnimator", value.tointeger())}
		CBaseEntity["GetRandomAnimation"] <- function(){return GetProp("m_bRandomAnimator")}

		CBaseEntity["SetNextRandAnim"] <- function(value){SetProp("m_flNextRandAnim", value.tofloat())}
		CBaseEntity["GetNextRandAnim"] <- function(){return GetProp("m_flNextRandAnim")}

		CBaseEntity["SetMinRandAnimTime"] <- function(value){SetProp("m_flMinRandAnimTime", value.tofloat())}
		CBaseEntity["GetMinRandAnimTime"] <- function(){return GetProp("m_flMinRandAnimTime")}

		CBaseEntity["SetMaxRandAnimTime"] <- function(value){SetProp("m_flMaxRandAnimTime", value.tofloat())}
		CBaseEntity["GetMaxRandAnimTime"] <- function(){return GetProp("m_flMaxRandAnimTime")}

		CBaseEntity["SetStartDisabled"] <- function(value){SetProp("m_bStartDisabled", value.tointeger())}
		CBaseEntity["GetStartDisabled"] <- function(){return GetProp("m_bStartDisabled")}

		CBaseEntity["SetPendingSequence"] <- function(value){SetProp("m_nPendingSequence", value.tointeger())}
		CBaseEntity["GetPendingSequence"] <- function(){return GetProp("m_nPendingSequence")}

		CBaseEntity["SetUpdateAttachedChildren"] <- function(value){SetProp("m_bUpdateAttachedChildren", value.tointeger())}
		CBaseEntity["GetUpdateAttachedChildren"] <- function(){return GetProp("m_bUpdateAttachedChildren")}

		CBaseEntity["SetInitialGlowState"] <- function(value){SetProp("m_iInitialGlowState", value.tointeger())}
		CBaseEntity["GetInitialGlowState"] <- function(){return GetProp("m_iInitialGlowState")}


		CBaseEntity["SetEntAttached"] <- function(entAttached){SetPropEntity("m_hEntAttached", entAttached)}
		CBaseEntity["GetEntAttached"] <- function(){return GetPropEntity("m_hEntAttached")}
			
		CBaseEntity["SetCheapEffect"] <- function(cheapEffect){SetProp("m_bCheapEffect", cheapEffect.tointeger())}
		CBaseEntity["IsCheapEffect"] <- function(){return GetProp("m_bCheapEffect")}
			
		CBaseEntity["SetLifetime"] <- function(value){SetProp("m_flLifetime", value.tofloat())}
		CBaseEntity["GetLifetime"] <- function(){return GetProp("m_flLifetime")}

		CBaseEntity["SetSize"] <- function(value){SetProp("m_flSize", value.tofloat())}
		CBaseEntity["GetSize"] <- function(){return GetProp("m_flSize")}

		CBaseEntity["SetDangerSound"] <- function(value){SetProp("m_iDangerSound", value.tointeger())}
		CBaseEntity["GetDangerSound"] <- function(){return GetProp("m_iDangerSound")}


		CBaseEntity["SetFadeStartDist"] <- function(fadeStartDist){SetProp("m_flFadeStartDist", fadeStartDist.tofloat())}
		CBaseEntity["GetFadeStartDist"] <- function(){return GetProp("m_flFadeStartDist")}
			
		CBaseEntity["SetFadeEndDist"] <- function(fadeEndDist){SetProp("m_flFadeEndDist", fadeEndDist.tofloat())}
		CBaseEntity["GetFadeEndDist"] <- function(){return GetProp("m_flFadeEndDist")}


		CBaseEntity["SetDOFEnabled"] <- function(DOFEnabled){SetProp("m_bDOFEnabled", DOFEnabled.tointeger())}
		CBaseEntity["IsDOFEnabled"] <- function(){return GetProp("m_bDOFEnabled")}
			
		CBaseEntity["SetNearBlurDepth"] <- function(nearBlurDepth){SetProp("m_flNearBlurDepth", nearBlurDepth.tofloat())}
		CBaseEntity["GetNearBlurDepth"] <- function(){return GetProp("m_flNearBlurDepth")}
			
		CBaseEntity["SetFarBlurDepth"] <- function(farBlurDepth){SetProp("m_flFarBlurDepth", farBlurDepth.tofloat())}
		CBaseEntity["GetFarBlurDepth"] <- function(){return GetProp("m_flFarBlurDepth")}
			
		CBaseEntity["SetNearFocusDepth"] <- function(nearFocusDepth){SetProp("m_flNearFocusDepth", nearFocusDepth.tofloat())}
		CBaseEntity["GetNearFocusDepth"] <- function(){return GetProp("m_flNearFocusDepth")}
			
		CBaseEntity["SetFarFocusDepth"] <- function(farFocusDepth){SetProp("m_flFarFocusDepth", farFocusDepth.tofloat())}
		CBaseEntity["GetFarFocusDepth"] <- function(){return GetProp("m_flFarFocusDepth")}
			
		CBaseEntity["SetNearBlurRadius"] <- function(nearBlurRadius){SetProp("m_flNearBlurRadius", nearBlurRadius.tofloat())}
		CBaseEntity["GetNearBlurRadius"] <- function(){return GetProp("m_flNearBlurRadius")}
			
		CBaseEntity["SetFarBlurRadius"] <- function(farBlurRadius){SetProp("m_flFarBlurRadius", farBlurRadius.tofloat())}
		CBaseEntity["GetFarBlurRadius"] <- function(){return GetProp("m_flFarBlurRadius")}
			
		CBaseEntity["SetBlendEndTime"] <- function(value){SetProp("m_flBlendEndTime", value.tofloat())}
		CBaseEntity["GetBlendEndTime"] <- function(){return GetProp("m_flBlendEndTime")}

		CBaseEntity["SetBlendStartTime"] <- function(value){SetProp("m_flBlendStartTime", value.tofloat())}
		CBaseEntity["GetBlendStartTime"] <- function(){return GetProp("m_flBlendStartTime")}


		CBaseEntity["SetSpawnRate"] <- function(spawnRate){SetProp("m_SpawnRate", spawnRate.tofloat())}
		CBaseEntity["GetSpawnRate"] <- function(){return GetProp("m_SpawnRate")}
			
		CBaseEntity["SetColor"] <- function(color){SetProp("m_Color", color)}
		CBaseEntity["GetColor"] <- function(){return GetProp("m_Color")}
			
		CBaseEntity["SetParticleLifetime"] <- function(particleLifetime){SetProp("m_ParticleLifetime", particleLifetime.tofloat())}
		CBaseEntity["GetParticleLifetime"] <- function(){return GetProp("m_ParticleLifetime")}
			
		CBaseEntity["SetStopEmitTime"] <- function(stopEmitTime){SetProp("m_StopEmitTime", stopEmitTime.tofloat())}
		CBaseEntity["GetStopEmitTime"] <- function(){return GetProp("m_StopEmitTime")}
			
		CBaseEntity["SetMinSpeed"] <- function(minSpeed){SetProp("m_MinSpeed", minSpeed.tofloat())}
		CBaseEntity["GetMinSpeed"] <- function(){return GetProp("m_MinSpeed")}
			
		CBaseEntity["SetMaxSpeed"] <- function(maxSpeed){SetProp("m_MaxSpeed", maxSpeed.tofloat())}
		CBaseEntity["GetMaxSpeed"] <- function(){return GetProp("m_MaxSpeed")}
			
		CBaseEntity["SetMinDirectedSpeed"] <- function(minDirectedSpeed){SetProp("m_MinDirectedSpeed", minDirectedSpeed.tofloat())}
		CBaseEntity["GetMinDirectedSpeed"] <- function(){return GetProp("m_MinDirectedSpeed")}
			
		CBaseEntity["SetMaxDirectedSpeed"] <- function(maxDirectedSpeed){SetProp("m_MaxDirectedSpeed", maxDirectedSpeed.tofloat())}
		CBaseEntity["GetMaxDirectedSpeed"] <- function(){return GetProp("m_MaxDirectedSpeed")}
			
		CBaseEntity["SetStartSize"] <- function(startSize){SetProp("m_StartSize", startSize.tofloat())}
		CBaseEntity["GetStartSize"] <- function(){return GetProp("m_StartSize")}
			
		CBaseEntity["SetEndSize"] <- function(endSize){SetProp("m_EndSize", endSize.tofloat())}
		CBaseEntity["GetEndSize"] <- function(){return GetProp("m_EndSize")}
			
		CBaseEntity["SetSpawnRadius"] <- function(spawnRadius){SetProp("m_SpawnRadius", spawnRadius.tofloat())}
		CBaseEntity["GetSpawnRadius"] <- function(){return GetProp("m_SpawnRadius")}
			
		CBaseEntity["SetEmit"] <- function(emit){SetProp("m_bEmit", emit.tointeger())}
		CBaseEntity["GetEmit"] <- function(){return GetProp("m_bEmit")}
			
		CBaseEntity["SetOpacity"] <- function(opacity){SetProp("m_Opacity", opacity.tofloat())}
		CBaseEntity["GetOpacity"] <- function(){return GetProp("m_Opacity")}
			
		CBaseEntity["SetAttachment"] <- function(value){SetProp("m_nAttachment", value.tointeger())}
		CBaseEntity["GetAttachment"] <- function(){return GetProp("m_nAttachment")}


		CBaseEntity["SetDensity"] <- function(density){SetProp("m_nDensity", density.tointeger())}
		CBaseEntity["GetDensity"] <- function(){return GetProp("m_nDensity")}
			
		CBaseEntity["SetLifetime"] <- function(lifetime){SetProp("m_nLifetime", lifetime.tointeger())}
		CBaseEntity["GetLifetime"] <- function(){return GetProp("m_nLifetime")}
			
		CBaseEntity["SetSpeed"] <- function(speed){SetProp("m_nSpeed", speed.tointeger())}
		CBaseEntity["GetSpeed"] <- function(){return GetProp("m_nSpeed")}
			
		CBaseEntity["SetEmit"] <- function(emit){SetProp("m_bEmit", emit.tointeger())}
		CBaseEntity["GetEmit"] <- function(){return GetProp("m_bEmit")}


		CBaseEntity["SetStartTime"] <- function(startTime){SetProp("m_flStartTime", startTime.tofloat())}
		CBaseEntity["GetStartTime"] <- function(){return GetProp("m_flStartTime")}
			
		CBaseEntity["SetFadeInStart"] <- function(fadeInStart){SetProp("m_flFadeInStart", fadeInStart.tofloat())}
		CBaseEntity["GetFadeInStart"] <- function(){return GetProp("m_flFadeInStart")}
			
		CBaseEntity["SetFadeInLength"] <- function(fadeInLength){SetProp("m_flFadeInLength", fadeInLength.tofloat())}
		CBaseEntity["GetFadeInLength"] <- function(){return GetProp("m_flFadeInLength")}
			
		CBaseEntity["SetFadeOutStart"] <- function(fadeOutStart){SetProp("m_flFadeOutStart", fadeOutStart.tofloat())}
		CBaseEntity["GetFadeOutStart"] <- function(){return GetProp("m_flFadeOutStart")}
			
		CBaseEntity["SetFadeOutLength"] <- function(fadeOutLength){SetProp("m_flFadeOutLength", fadeOutLength.tofloat())}
		CBaseEntity["GetFadeOutLength"] <- function(){return GetProp("m_flFadeOutLength")}
			
		CBaseEntity["SetFadeOutModelStart"] <- function(fadeOutModelStart){SetProp("m_flFadeOutModelStart", fadeOutModelStart.tofloat())}
		CBaseEntity["GetFadeOutModelStart"] <- function(){return GetProp("m_flFadeOutModelStart")}
			
		CBaseEntity["SetFadeOutModelLength"] <- function(fadeOutModelLength){SetProp("m_flFadeOutModelLength", fadeOutModelLength.tofloat())}
		CBaseEntity["GetFadeOutModelLength"] <- function(){return GetProp("m_flFadeOutModelLength")}
			
		CBaseEntity["SetDissolveType"] <- function(dissolveType){SetProp("m_nDissolveType", dissolveType.tointeger())}
		CBaseEntity["GetDissolveType"] <- function(){return GetProp("m_nDissolveType")}
			
		CBaseEntity["SetDissolverOrigin"] <- function(dissolverOrigin){SetProp("m_vDissolverOrigin", dissolverOrigin)}
		CBaseEntity["GetDissolverOrigin"] <- function(){return GetProp("m_vDissolverOrigin")}
			
		CBaseEntity["SetMagnitude"] <- function(magnitude){SetProp("m_nMagnitude", magnitude.tointeger())}
		CBaseEntity["GetMagnitude"] <- function(){return GetProp("m_nMagnitude")}


		CBaseEntity["SetAttachment"] <- function(attachment){SetProp("m_nAttachment", attachment.tointeger())}
		CBaseEntity["GetAttachment"] <- function(){return GetProp("m_nAttachment")}
			
		CBaseEntity["SetLifetime"] <- function(lifetime){SetProp("m_flLifetime", lifetime.tofloat())}
		CBaseEntity["GetLifetime"] <- function(){return GetProp("m_flLifetime")}


		CBaseEntity["SetEnabled"] <- function(enable){SetProp("m_fog.enable", enable.tointeger())}
		CBaseEntity["IsEnabled"] <- function(){GetProp("m_fog.enable")}
			
		CBaseEntity["SetBlend"] <- function(blend){SetProp("m_fog.blend", blend.tointeger())}
		CBaseEntity["IsBlend"] <- function(){return GetProp("m_fog.blend")}
			
		CBaseEntity["SetDirPrimary"] <- function(dirPrimary){SetProp("m_fog.dirPrimary", dirPrimary)}
		CBaseEntity["GetDirPrimary"] <- function(){return GetProp("m_fog.dirPrimary")}
			
		CBaseEntity["SetColorPrimary"] <- function(colorPrimary){SetProp("m_fog.colorPrimary", colorPrimary.tointeger())}
		CBaseEntity["GetColorPrimary"] <- function(){return GetProp("m_fog.colorPrimary")}
			
		CBaseEntity["SetColorSecondary"] <- function(colorSecondary){SetProp("m_fog.colorSecondary", colorSecondary.tointeger())}
		CBaseEntity["GetColorSecondary"] <- function(){return GetProp("m_fog.colorSecondary")}
			
		CBaseEntity["SetStart"] <- function(start){SetProp("m_fog.start", start.tofloat())}
		CBaseEntity["GetStart"] <- function(){return GetProp("m_fog.start")}
			
		CBaseEntity["SetEnd"] <- function(end){SetProp("m_fog.end", end.tofloat())}
		CBaseEntity["GetEnd"] <- function(){return GetProp("m_fog.end")}
			
		CBaseEntity["SetMaxDensity"] <- function(maxDensity){SetProp("m_fog.maxdensity", maxDensity.tofloat())}
		CBaseEntity["GetMaxDensity"] <- function(){return GetProp("m_fog.maxdensity")}
			
		CBaseEntity["SetFarZ"] <- function(farZ){SetProp("m_fog.farz", farZ.tofloat())}
		CBaseEntity["GetFarZ"] <- function(){return GetProp("m_fog.farz")}
			
		CBaseEntity["SetSkyboxFogFactor"] <- function(skyboxFogFactor){SetProp("m_fog.skyboxFogFactor", skyboxFogFactor.tofloat())}
		CBaseEntity["GetSkyboxFogFactor"] <- function(){return GetProp("m_fog.skyboxFogFactor")}
			
		CBaseEntity["SetColorPrimaryLerpTo"] <- function(colorPrimaryLerpTo){SetProp("m_fog.colorPrimaryLerpTo", colorPrimaryLerpTo.tointeger())}
		CBaseEntity["GetColorPrimaryLerpTo"] <- function(){return GetProp("m_fog.colorPrimaryLerpTo")}
			
		CBaseEntity["SetColorSecondaryLerpTo"] <- function(colorSecondaryLerpTo){SetProp("m_fog.colorSecondaryLerpTo", colorSecondaryLerpTo.tointeger())}
		CBaseEntity["GetColorSecondaryLerpTo"] <- function(){return GetProp("m_fog.colorSecondaryLerpTo")}
			
		CBaseEntity["SetStartLerpTo"] <- function(startLerpTo){SetProp("m_fog.startLerpTo", startLerpTo.tofloat())}
		CBaseEntity["GetStartLerpTo"] <- function(){return GetProp("m_fog.startLerpTo")}
			
		CBaseEntity["SetEndLerpTo"] <- function(endLerpTo){SetProp("m_fog.endLerpTo", endLerpTo.tofloat())}
		CBaseEntity["GetEndLerpTo"] <- function(){return GetProp("m_fog.endLerpTo")}
			
		CBaseEntity["SetMaxDensityLerpTo"] <- function(maxDensityLerpTo){SetProp("m_fog.maxdensityLerpTo", maxDensityLerpTo.tofloat())}
		CBaseEntity["GetMaxDensityLerpTo"] <- function(){return GetProp("m_fog.maxdensityLerpTo")}
			
		CBaseEntity["SetSkyboxFogFactorLerpTo"] <- function(skyboxFogFactorLerpTo){SetProp("m_fog.skyboxFogFactorLerpTo", skyboxFogFactorLerpTo.tofloat())}
		CBaseEntity["GetSkyboxFogFactorLerpTo"] <- function(){return GetProp("m_fog.skyboxFogFactorLerpTo")}
			
		CBaseEntity["SetLerpTime"] <- function(lerpTime){SetProp("m_fog.lerptime", lerpTime.tofloat())}
		CBaseEntity["GetLerpTime"] <- function(){return GetProp("m_fog.lerptime")}
			
		CBaseEntity["SetDuration"] <- function(duration){SetProp("m_fog.duration", duration.tofloat())}
		CBaseEntity["GetDuration"] <- function(){return GetProp("m_fog.duration")}
			
		CBaseEntity["SetHDRColorScale"] <- function(HDRColorScale){SetProp("m_fog.HDRColorScale", HDRColorScale.tofloat())}
		CBaseEntity["GetHDRColorScale"] <- function(){return GetProp("m_fog.HDRColorScale")}
			
		CBaseEntity["SetUseAngles"] <- function(value){SetProp("m_bUseAngles", value.tointeger())}
		CBaseEntity["GetUseAngles"] <- function(){return GetProp("m_bUseAngles")}


		CBaseEntity["SetHorizontalSize"] <- function(horizontalSize){SetProp("m_nHorizontalSize", horizontalSize.tointeger())}
		CBaseEntity["GetHorizontalSize"] <- function(){return GetProp("m_nHorizontalSize")}
			
		CBaseEntity["SetVerticalSize"] <- function(verticalSize){SetProp("m_nVerticalSize", verticalSize.tointeger())}
		CBaseEntity["GetVerticalSize"] <- function(){return GetProp("m_nVerticalSize")}
			
		CBaseEntity["SetMinDist"] <- function(minDist){SetProp("m_nMinDist", minDist.tointeger())}
		CBaseEntity["GetMinDist"] <- function(){return GetProp("m_nMinDist")}
			
		CBaseEntity["SetMaxDist"] <- function(maxDist){SetProp("m_nMaxDist", maxDist.tointeger())}
		CBaseEntity["GetMaxDist"] <- function(){return GetProp("m_nMaxDist")}
			
		CBaseEntity["SetOuterMaxDist"] <- function(outerMaxDist){SetProp("m_nOuterMaxDist", outerMaxDist.tointeger())}
		CBaseEntity["GetOuterMaxDist"] <- function(){return GetProp("m_nOuterMaxDist")}
			
		CBaseEntity["SetGlowProxySize"] <- function(glowProxySize){SetProp("m_flGlowProxySize", glowProxySize.tofloat())}
		CBaseEntity["GetGlowProxySize"] <- function(){return GetProp("m_flGlowProxySize")}
			
		CBaseEntity["SetHDRColorScale"] <- function(HDRColorScale){SetProp("HDRColorScale", HDRColorScale.tofloat())}
		CBaseEntity["GetHDRColorScale"] <- function(){return GetProp("HDRColorScale")}


		CBaseEntity["SetDisplayPerf"] <- function(displayPerf){SetProp("m_bDisplayPerf", displayPerf.tointeger())}
		CBaseEntity["GetDisplayPerf"] <- function(){return GetProp("m_bDisplayPerf")}
			
		CBaseEntity["SetMeasurePerf"] <- function(measurePerf){SetProp("m_bMeasurePerf", measurePerf.tointeger())}
		CBaseEntity["GetMeasurePerf"] <- function(){return GetProp("m_bMeasurePerf")}


		CBaseEntity["SetMaterialName"] <- function(materialName){SetProp("m_iMaterialName", materialName.tointeger())}
		CBaseEntity["GetMaterialName"] <- function(){return GetProp("m_iMaterialName")}
			
		CBaseEntity["SetLifetime"] <- function(lifetime){SetProp("m_Info.m_flLifetime", lifetime.tofloat())}
		CBaseEntity["GetLifetime"] <- function(){return GetProp("m_flLifetime")}
			
		CBaseEntity["SetStartSize"] <- function(startSize){SetProp("m_Info.m_flStartSize", startSize.tofloat())}
		CBaseEntity["GetStartSize"] <- function(){return GetProp("m_flStartSize")}
			
		CBaseEntity["SetEndSize"] <- function(endSize){SetProp("m_flEndSize", endSize.tofloat())}
		CBaseEntity["GetEndSize"] <- function(){return GetProp("m_flEndSize")}
			
		CBaseEntity["SetConstraintEntity"] <- function(constraintEntity){SetPropEntity("m_hConstraintEntity", constraintEntity)}
		CBaseEntity["GetConstraintEntity"] <- function(){return GetProp("m_hConstraintEntity")}


		/*CBaseEntity["SetOrigin"] <- function(origin){SetProp("m_vOrigin", origin)}
		CBaseEntity["GetOrigin"] <- function(){return GetProp("m_vOrigin")}*/
			
		CBaseEntity["SetDirection"] <- function(direction){SetProp("m_vDirection", direction)}
		CBaseEntity["GetDirection"] <- function(){return GetProp("m_vDirection")}


		CBaseEntity["SetSequenceScale"] <- function(sequenceScale){SetProp("m_flSequenceScale", sequenceScale.tofloat())}
		CBaseEntity["GetSequenceScale"] <- function(){return GetProp("m_flSequenceScale")}


		CBaseEntity["SetSpawnTime"] <- function(spawnTime){SetProp("m_flSpawnTime", spawnTime.tofloat())}
		CBaseEntity["GetSpawnTime"] <- function(){return GetProp("m_flSpawnTime")}
			
		CBaseEntity["SetFadeStartTime"] <- function(fadeStartTime){SetProp("m_FadeStartTime", fadeStartTime.tofloat())}
		CBaseEntity["GetFadeStartTime"] <- function(){return GetProp("m_FadeStartTime")}
			
		CBaseEntity["SetFadeEndTime"] <- function(fadeEndTime){SetProp("m_FadeEndTime", fadeEndTime.tofloat())}
		CBaseEntity["GetFadeEndTime"] <- function(){return GetProp("m_FadeEndTime")}
			
		CBaseEntity["SetCurrentStage"] <- function(currentStage){SetProp("m_CurrentStage", currentStage.tointeger())}
		CBaseEntity["GetCurrentStage"] <- function(){return GetProp("m_CurrentStage")}


		CBaseEntity["SetMins"] <- function(mins){SetProp("m_vMins", mins)}
		CBaseEntity["GetMins"] <- function(){return GetProp("m_vMins")}
			
		CBaseEntity["SetMaxs"] <- function(maxs){SetProp("m_vMaxs", maxs)}
		CBaseEntity["GetMaxs"] <- function(){return GetProp("m_vMaxs")}
			
		CBaseEntity["SetBlocked"] <- function(blocked){SetProp("m_bBlocked", blocked.tointeger())}
		CBaseEntity["IsBlocked"] <- function(){return GetProp("m_bBlocked")}
			
		CBaseEntity["SetBlockType"] <- function(blockType){SetProp("m_nBlockType", blockType.tointeger())}
		CBaseEntity["GetBlockType"] <- function(){return GetProp("m_nBlockType")}


		CBaseEntity["SetTargetEntity"] <- function(targetEntity){SetPropEntity("m_hTargetEntity", targetEntity)}
		CBaseEntity["GetTargetEntity"] <- function(){return GetPropEntity("m_hTargetEntity")}
			
		CBaseEntity["SetState"] <- function(state){SetProp("m_bState", state.tointeger())}
		CBaseEntity["GetState"] <- function(){return GetProp("m_bState")}
			
		CBaseEntity["SetLightFOV"] <- function(lightFOV){SetProp("m_flLightFOV", lightFOV.tofloat())}
		CBaseEntity["GetLightFOV"] <- function(){return GetProp("m_flLightFOV")}
			
		CBaseEntity["SetEnableShadows"] <- function(enableShadows){SetProp("m_bEnableShadows", enableShadows.tointeger())}
		CBaseEntity["GetEnableShadows"] <- function(){return GetProp("m_bEnableShadows")}
			
		CBaseEntity["SetLightOnlyTarget"] <- function(lightOnlyTarget){SetProp("m_bLightOnlyTarget", lightOnlyTarget.tointeger())}
		CBaseEntity["GetLightOnlyTarget"] <- function(){return GetProp("m_bLightOnlyTarget")}
			
		CBaseEntity["SetLightWorld"] <- function(lightWorld){SetProp("m_bLightWorld", lightWorld.tointeger())}
		CBaseEntity["GetLightWorld"] <- function(){return GetProp("m_bLightWorld")}
			
		CBaseEntity["SetCameraSpace"] <- function(cameraSpace){SetProp("m_bCameraSpace", cameraSpace.tointeger())}
		CBaseEntity["GetCameraSpace"] <- function(){return GetProp("m_bCameraSpace")}
			
		CBaseEntity["SetLinearFloatLightColor"] <- function(linearFloatLightColor){SetProp("m_LinearFloatLightColor", linearFloatLightColor)}
		CBaseEntity["GetLinearFloatLightColor"] <- function(){return GetProp("m_LinearFloatLightColor")}
			
		CBaseEntity["SetAmbient"] <- function(ambient){SetProp("m_flAmbient", ambient.tofloat())}
		CBaseEntity["GetAmbient"] <- function(){return GetProp("m_flAmbient")}
			
		CBaseEntity["SetSpotlightTextureName"] <- function(spotlightTextureName){SetProp("m_SpotlightTextureName", spotlightTextureName.tostring())}
		CBaseEntity["GetSpotlightTextureName"] <- function(){return GetProp("m_SpotlightTextureName")}
			
		CBaseEntity["SetSpotlightTextureFrame"] <- function(spotlightTextureFrame){SetProp("m_nSpotlightTextureFrame", spotlightTextureFrame.tointeger())}
		CBaseEntity["GetSpotlightTextureFrame"] <- function(){return GetProp("m_nSpotlightTextureFrame")}
			
		CBaseEntity["SetNearZ"] <- function(nearZ){SetProp("m_flNearZ", nearZ.tofloat())}
		CBaseEntity["GetNearZ"] <- function(){return GetProp("m_flNearZ")}
			
		CBaseEntity["SetFarZ"] <- function(farZ){SetProp("m_flFarZ", farZ.tofloat())}
		CBaseEntity["GetFarZ"] <- function(){return GetProp("m_flFarZ")}
			
		CBaseEntity["SetShadowQuality"] <- function(shadowQuality){SetProp("m_nShadowQuality", shadowQuality.tointeger())}
		CBaseEntity["GetShadowQuality"] <- function(){return GetProp("m_nShadowQuality")}


		CBaseEntity["SetTargetPosition"] <- function(targetPosition){SetProp("m_targetPosition", targetPosition)}
		CBaseEntity["GetTargetPosition"] <- function(){return GetProp("m_targetPosition")}
			
		CBaseEntity["SetControlPosition"] <- function(controlPosition){SetProp("m_controlPosition", controlPosition)}
		CBaseEntity["GetControlPosition"] <- function(){return GetProp("m_controlPosition")}
			
		CBaseEntity["SetScrollRate"] <- function(scrollRate){SetProp("m_scrollRate", scrollRate.tofloat())}
		CBaseEntity["GetScrollRate"] <- function(){return GetProp("m_scrollRate")}
			
		CBaseEntity["SetWidth"] <- function(width){SetProp("m_flWidth", width.tofloat())}
		CBaseEntity["GetWidth"] <- function(){return GetProp("m_flWidth")}


		CBaseEntity["SetSpawnRate"] <- function(spawnRate){SetProp("m_SpawnRate", spawnRate.tofloat())}
		CBaseEntity["GetSpawnRate"] <- function(){GetProp("m_SpawnRate")}
			
		CBaseEntity["SetStartColor"] <- function(startColor){SetProp("m_StartColor", startColor)}
		CBaseEntity["GetStartColor"] <- function(){return GetProp("m_StartColor")}
			
		CBaseEntity["SetEndColor"] <- function(endColor){SetProp("m_EndColor", endColor)}
		CBaseEntity["GetEndColor"] <- function(){return GetProp("m_EndColor")}
			
		CBaseEntity["SetParticleLifetime"] <- function(particleLifetime){SetProp("m_ParticleLifetime", particleLifetime.tofloat())}
		CBaseEntity["GetParticleLifetime"] <- function(){return GetProp("m_ParticleLifetime")}
			
		CBaseEntity["SetStopEmitTime"] <- function(stopEmitTime){SetProp("m_StopEmitTime", stopEmitTime.tofloat())}
		CBaseEntity["GetStopEmitTime"] <- function(){return GetProp("m_StopEmitTime")}
			
		CBaseEntity["SetMinSpeed"] <- function(minSpeed){SetProp("m_MinSpeed", minSpeed.tofloat())}
		CBaseEntity["GetMinSpeed"] <- function(){return GetProp("m_MinSpeed")}
			
		CBaseEntity["SetMaxSpeed"] <- function(maxSpeed){SetProp("m_MaxSpeed", maxSpeed.tofloat())}
		CBaseEntity["GetMaxSpeed"] <- function(){return GetProp("m_MaxSpeed")}
			
		CBaseEntity["SetStartSize"] <- function(startSize){SetProp("m_StartSize", startSize.tofloat())}
		CBaseEntity["GetStartSize"] <- function(){return GetProp("m_StartSize")}
			
		CBaseEntity["SetEndSize"] <- function(endSize){SetProp("m_EndSize", endSize.tofloat())}
		CBaseEntity["GetEndSize"] <- function(){return GetProp("m_EndSize")}
			
		CBaseEntity["SetSpawnRadius"] <- function(spawnRadius){SetProp("m_SpawnRadius", spawnRadius.tofloat())}
		CBaseEntity["GetSpawnRadius"] <- function(){return GetProp("m_SpawnRadius")}
			
		CBaseEntity["SetEmit"] <- function(emit){SetProp("m_bEmit", emit.tointeger())}
		CBaseEntity["GetEmit"] <- function(){return GetProp("m_bEmit")}
			
		CBaseEntity["SetAttachment"] <- function(attachment){SetProp("m_nAttachment", attachment.tointeger())}
		CBaseEntity["GetAttachment"] <- function(){return GetProp("m_nAttachment")}
			
		CBaseEntity["SetOpacity"] <- function(opacity){SetProp("m_Opacity", opacity.tofloat())}
		CBaseEntity["GetOpacity"] <- function(){return GetProp("m_Opacity")}
			
		CBaseEntity["SetDamaged"] <- function(damaged){SetProp("m_bDamaged", damaged.tointeger())}
		CBaseEntity["IsDamaged"] <- function(){return GetProp("m_bDamaged")}
			
		CBaseEntity["SetFlareScale"] <- function(flareScale){SetProp("m_flFlareScale", flareScale.tofloat())}
		CBaseEntity["GetFlareScale"] <- function(){return GetProp("m_flFlareScale")}


		CBaseEntity["SetDuration"] <- function(duration){SetProp("m_flDuration", duration.tofloat())}
		CBaseEntity["GetDuration"] <- function(){return GetProp("m_flDuration")}
			
		CBaseEntity["SetType"] <- function(type){SetProp("m_nType", type.tointeger())}
		CBaseEntity["GetType"] <- function(){return GetProp("m_nType")}


		CBaseEntity["SetOverlayNames"] <- function(overlayNames){SetProp("m_iszOverlayNames", overlayNames)}
		CBaseEntity["GetOverlayNames"] <- function(){return GetProp("m_iszOverlayNames", null, true)}
			
		CBaseEntity["SetOverlayTimes"] <- function(overlayTimes){SetProp("m_flOverlayTimes", overlayTimes)}
		CBaseEntity["GetOverlayTimes"] <- function(){return GetProp("m_flOverlayTimes", null, true)}
			
		CBaseEntity["SetStartTime"] <- function(startTime){SetProp("m_flStartTime", startTime.tofloat())}
		CBaseEntity["GetStartTime"] <- function(){return GetProp("m_flStartTime")}
			
		CBaseEntity["SetDesiredOverlay"] <- function(desiredOverlay){SetProp("m_iDesiredOverlay", desiredOverlay.tointeger())}
		CBaseEntity["GetDesiredOverlay"] <- function(){return GetProp("m_iDesiredOverlay")}
			
		CBaseEntity["SetActive"] <- function(active){SetProp("m_bIsActive", active)}
		CBaseEntity["IsActive"] <- function(){return GetProp("m_bIsActive")}


		CBaseEntity["SetSpreadSpeed"] <- function(value){SetProp("m_SpreadSpeed", value.tofloat())}
		CBaseEntity["GetSpreadSpeed"] <- function(){return GetProp("m_SpreadSpeed")}
			
		CBaseEntity["SetSpeed"] <- function(value){SetProp("m_Speed", value.tofloat())}
		CBaseEntity["GetSpeed"] <- function(){return GetProp("m_Speed")}
			
		CBaseEntity["SetStartSize"] <- function(value){SetProp("m_StartSize", value.tofloat())}
		CBaseEntity["GetStartSize"] <- function(){return GetProp("m_StartSize")}
			
		CBaseEntity["SetEndSize"] <- function(value){SetProp("m_EndSize", value.tofloat())}
		CBaseEntity["GetEndSize"] <- function(){return GetProp("m_EndSize")}

		CBaseEntity["SetRate"] <- function(value){SetProp("m_Rate", value.tofloat())}
		CBaseEntity["GetRate"] <- function(){return GetProp("m_Rate")}

		CBaseEntity["SetJetLength"] <- function(value){SetProp("m_JetLength", value.tofloat())}
		CBaseEntity["GetJetLength"] <- function(){return GetProp("m_JetLength")}

		CBaseEntity["SetEmit"] <- function(value){SetProp("m_bEmit", value.tointeger())}
		CBaseEntity["GetEmit"] <- function(){return GetProp("m_bEmit")}

		CBaseEntity["SetBaseSpread"] <- function(value){SetProp("m_flBaseSpread", value.tofloat())}
		CBaseEntity["GetBaseSpread"] <- function(){return GetProp("m_flBaseSpread")}
			
		CBaseEntity["SetDirLightPos"] <- function(value){SetProp("m_DirLight.m_vPos", value)}
		CBaseEntity["GetDirLightPos"] <- function(){return GetProp("m_DirLight.m_vPos")}
			
		CBaseEntity["SetDirLightColor"] <- function(value){SetProp("m_DirLight.m_vColor", value)}
		CBaseEntity["GetDirLightColor"] <- function(){return GetProp("m_DirLight.m_vColor")}
			
		CBaseEntity["SetDirLightIntensity"] <- function(value){SetProp("m_DirLight.m_flIntensity", value.tofloat())}
		CBaseEntity["GetDirLightIntensity"] <- function(){return GetProp("m_DirLight.m_flIntensity")}
			
		CBaseEntity["SetAmbientLightPos"] <- function(value){SetProp("m_AmbientLight.m_vPos", value)}
		CBaseEntity["GetAmbientLightPos"] <- function(){return GetProp("m_AmbientLight.m_vPos")}
			
		CBaseEntity["SetAmbientLightColor"] <- function(value){SetProp("m_AmbientLight.m_vColor", value)}
		CBaseEntity["GetAmbientLightColor"] <- function(value){return GetProp("m_AmbientLight.m_vColor")}
			
		CBaseEntity["SetAmbientLightIntensity"] <- function(value){SetProp("m_AmbientLight.m_flIntensity", value.tofloat())}
		CBaseEntity["GetAmbientLightIntensity"] <- function(value){return GetProp("m_AmbientLight.m_flIntensity")}
			
		CBaseEntity["SetWind"] <- function(value){SetProp("m_vWind", value)}
		CBaseEntity["GetWind"] <- function(){return GetProp("m_vWind")}
			
		CBaseEntity["SetTwist"] <- function(value){SetProp("m_flTwist", value.tofloat())}
		CBaseEntity["GetTwist"] <- function(){return GetProp("m_flTwist")}
			
		CBaseEntity["SetMaterialModel"] <- function(value){SetProp("m_strMaterialModel", value.tostring())}
		CBaseEntity["GetMaterialModel"] <- function(){return GetProp("m_strMaterialModel")}
			
		CBaseEntity["SetInitialState"] <- function(value){SetProp("m_InitialState", value.tointeger())}
		CBaseEntity["GetInitialState"] <- function(){return GetProp("m_InitialState")}
			
		CBaseEntity["SetRollSpeed"] <- function(value){SetProp("m_flRollSpeed", value.tofloat())}
		CBaseEntity["GetRollSpeed"] <- function(){return GetProp("m_flRollSpeed")}
			
		CBaseEntity["SetWindAngle"] <- function(value){SetProp("m_WindAngle", value)}
		CBaseEntity["GetWindAngle"] <- function(){return GetProp("m_WindAngle")}

		CBaseEntity["SetWindSpeed"] <- function(value){SetProp("m_WindSpeed", value.tofloat())}
		CBaseEntity["GetWindSpeed"] <- function(){return GetProp("m_WindSpeed")}


		CBaseEntity["SetSpawnRate"] <- function(value){SetProp("m_SpawnRate", value.tofloat())}	
		CBaseEntity["GetSpawnRate"] <- function(){return GetProp("m_SpawnRate")}

		CBaseEntity["SetStartColor"] <- function(value){SetProp("m_StartColor", value)}	
		CBaseEntity["GetStartColor"] <- function(){return GetProp("m_StartColor")}

		CBaseEntity["SetEndColor"] <- function(value){SetProp("m_EndColor", value)}	
		CBaseEntity["GetEndColor"] <- function(){return GetProp("m_EndColor")}

		CBaseEntity["SetParticleLifetime"] <- function(value){SetProp("m_ParticleLifetime", value.tofloat())}	
		CBaseEntity["GetParticleLifetime"] <- function(){return GetProp("m_ParticleLifetime")}

		CBaseEntity["SetStopEmitTime"] <- function(value){SetProp("m_StopEmitTime", value.tofloat())}	
		CBaseEntity["GetStopEmitTime"] <- function(){return GetProp("m_StopEmitTime")}

		CBaseEntity["SetMinSpeed"] <- function(value){SetProp("m_MinSpeed", value.tofloat())}	
		CBaseEntity["GetMinSpeed"] <- function(){return GetProp("m_MinSpeed")}

		CBaseEntity["SetMaxSpeed"] <- function(value){SetProp("m_MaxSpeed", value.tofloat())}	
		CBaseEntity["GetMaxSpeed"] <- function(){return GetProp("m_MaxSpeed")}

		CBaseEntity["SetMinDirectedSpeed"] <- function(value){SetProp("m_MinDirectedSpeed", value.tofloat())}	
		CBaseEntity["GetMinDirectedSpeed"] <- function(){return GetProp("m_MinDirectedSpeed")}

		CBaseEntity["SetMaxDirectedSpeed"] <- function(value){SetProp("m_MaxDirectedSpeed", value.tofloat())}	
		CBaseEntity["etMaxDirectedSpeed"] <- function(){return GetProp("m_MaxDirectedSpeed")}

		CBaseEntity["SetStartSize"] <- function(value){SetProp("m_StartSize", value.tofloat())}	
		CBaseEntity["GetStartSize"] <- function(){return GetProp("m_StartSize")}

		CBaseEntity["SetEndSize"] <- function(value){SetProp("m_EndSize", value.tofloat())}	
		CBaseEntity["GetEndSize"] <- function(){return GetProp("m_EndSize")}

		CBaseEntity["SetSpawnRadius"] <- function(value){SetProp("m_SpawnRadius", value.tofloat())}	
		CBaseEntity["GetSpawnRadius"] <- function(){return GetProp("m_SpawnRadius")}

		CBaseEntity["SetEmit"] <- function(value){SetProp("m_bEmit", value.tointeger())}	
		CBaseEntity["GetEmit"] <- function(){return GetProp("m_bEmit")}

		CBaseEntity["SetAttachment"] <- function(value){SetProp("m_nAttachment", value.tointeger())}	
		CBaseEntity["GetAttachment"] <- function(){return GetProp("m_nAttachment")}

		CBaseEntity["SetOpacity"] <- function(value){SetProp("m_Opacity", value.tofloat())}	
		CBaseEntity["GetOpacity"] <- function(){return GetProp("m_Opacity")}


		CBaseEntity["SetSpawnRate"] <- function(value){SetProp("m_flSpawnRate", value.tofloat())}
		CBaseEntity["GetSpawnRate"] <- function(){return GetProp("m_flSpawnRate")}

		CBaseEntity["SetParticleLifetime"] <- function(value){SetProp("m_flParticleLifetime", value.tofloat())}
		CBaseEntity["GetParticleLifetime"] <- function(){return GetProp("m_flParticleLifetime")}

		CBaseEntity["SetStartSize"] <- function(value){SetProp("m_flStartSize", value.tofloat())}
		CBaseEntity["GetStartSize"] <- function(){return GetProp("m_flStartSize")}

		CBaseEntity["SetEndSize"] <- function(value){SetProp("m_flEndSize", value.tofloat())}
		CBaseEntity["GetEndSize"] <- function(){return GetProp("m_flEndSize")}

		CBaseEntity["SetSpawnRadius"] <- function(value){SetProp("m_flSpawnRadius", value.tofloat())}
		CBaseEntity["GetSpawnRadius"] <- function(){return GetProp("m_flSpawnRadius")}

		CBaseEntity["SetEmit"] <- function(value){SetProp("m_bEmit", value.tointeger())}
		CBaseEntity["GetEmit"] <- function(){return GetProp("m_bEmit")}

		CBaseEntity["SetDontRemove"] <- function(value){SetProp("m_bDontRemove", value.tointeger())}
		CBaseEntity["GetDontRemove"] <- function(){return GetProp("m_bDontRemove")}
			
		CBaseEntity["SetDisabled"] <- function(value){SetProp("m_bDisabled", value.tointeger())}
		CBaseEntity["GetDisabled"] <- function(){return GetProp("m_bDisabled")}


		CBaseEntity["SetSpawnRate"] <- function(value){SetProp("m_flSpawnRate", value.tofloat())}
		CBaseEntity["GetSpawnRate"] <- function(){return GetProp("m_flSpawnRate")}

		CBaseEntity["SetEndColor"] <- function(value){SetProp("m_vecEndColor", value)}
		CBaseEntity["GetEndColor"] <- function(){return GetProp("m_vecEndColor")}

		CBaseEntity["SetParticleLifetime"] <- function(value){SetProp("m_flParticleLifetime", value.tofloat())}
		CBaseEntity["GetParticleLifetime"] <- function(){return GetProp("m_flParticleLifetime")}

		CBaseEntity["SetStartSize"] <- function(value){SetProp("m_flStartSize", value.tofloat())}
		CBaseEntity["GetStartSize"] <- function(){return GetProp("m_flStartSize")}

		CBaseEntity["SetEndSize"] <- function(value){SetProp("m_flEndSize", value.tofloat())}
		CBaseEntity["GetEndSize"] <- function(){return GetProp("m_flEndSize")}

		CBaseEntity["SetSpawnRadius"] <- function(value){SetProp("m_flSpawnRadius", value.tofloat())}
		CBaseEntity["GetSpawnRadius"] <- function(){return GetProp("m_flSpawnRadius")}

		CBaseEntity["SetEmit"] <- function(value){SetProp("m_bEmit", value.tointeger())}
		CBaseEntity["GetEmit"] <- function(){return GetProp("m_bEmit")}


		CBaseEntity["SetAttachedToEntity"] <- function(value){SetPropEntity("m_hAttachedToEntity", value)}
		CBaseEntity["GetAttachedToEntity"] <- function(value){return GetPropEntity("m_hAttachedToEntity")}

		CBaseEntity["SetAttachment"] <- function(value){SetProp("m_nAttachment", value.tointeger())}
		CBaseEntity["GetAttachment"] <- function(){return GetProp("m_nAttachment")}

		CBaseEntity["SetScaleTime"] <- function(value){SetProp("m_flScaleTime", value.tofloat())}
		CBaseEntity["GetScaleTime"] <- function(){return GetProp("m_flScaleTime")}

		CBaseEntity["SetSpriteScale"] <- function(value){SetProp("m_flSpriteScale", value.tofloat())}
		CBaseEntity["GetSpriteScale"] <- function(){return GetProp("m_flSpriteScale")}

		CBaseEntity["SetGlowProxySize"] <- function(value){SetProp("m_flGlowProxySize", value.tofloat())}
		CBaseEntity["GetGlowProxySize"] <- function(){return GetProp("m_flGlowProxySize")}

		CBaseEntity["SetHDRColorScale"] <- function(value){SetProp("m_flHDRColorScale", value.tofloat())}
		CBaseEntity["GetHDRColorScale"] <- function(){return GetProp("m_flHDRColorScale")}

		CBaseEntity["SetSpriteFramerate"] <- function(value){SetProp("m_flSpriteFramerate", value.tofloat())}
		CBaseEntity["GetSpriteFramerate"] <- function(){return GetProp("m_flSpriteFramerate")}

		CBaseEntity["SetFrame"] <- function(value){SetProp("m_flFrame", value.tofloat())}
		CBaseEntity["GetFrame"] <- function(){return GetProp("m_flFrame")}

		CBaseEntity["SetBrightnessTime"] <- function(value){SetProp("m_flBrightnessTime", value.tofloat())}
		CBaseEntity["GetBrightnessTime"] <- function(){return GetProp("m_flBrightnessTime")}

		CBaseEntity["SetBrightness"] <- function(value){SetProp("m_nBrightness", value.tointeger())}
		CBaseEntity["GetBrightness"] <- function(){return GetProp("m_nBrightness")}

		CBaseEntity["SetWorldSpaceScale"] <- function(value){SetProp("m_bWorldSpaceScale", value.tointeger())}
		CBaseEntity["GetWorldSpaceScale"] <- function(){return GetProp("m_bWorldSpaceScale")}
			
		CBaseEntity["SetLastTime"] <- function(value){SetProp("m_flLastTime", value.tofloat())}
		CBaseEntity["GetLastTime"] <- function(){return GetProp("m_flLastTime")}

		CBaseEntity["SetMaxFrame"] <- function(value){SetProp("m_flMaxFrame", value.tofloat())}
		CBaseEntity["GetMaxFrame"] <- function(){return GetProp("m_flMaxFrame")}

		CBaseEntity["SetAttachedToEntity"] <- function(value){SetPropEntity("m_hAttachedToEntity", value)}
		CBaseEntity["GetAttachedToEntity"] <- function(value){return GetPropEntity("m_hAttachedToEntity")}

		CBaseEntity["SetDieTime"] <- function(value){SetProp("m_flDieTime", value.tofloat())}
		CBaseEntity["GetDieTime"] <- function(){return GetProp("m_flDieTime")}

		CBaseEntity["SetStartScale"] <- function(value){SetProp("m_flStartScale", value.tofloat())}
		CBaseEntity["GetStartScale"] <- function(){return GetProp("m_flStartScale")}

		CBaseEntity["SetDestScale"] <- function(value){SetProp("m_flDestScale", value.tofloat())}
		CBaseEntity["GetDestScale"] <- function(){return GetProp("m_flDestScale")}

		CBaseEntity["SetScaleTimeStart"] <- function(value){SetProp("m_flScaleTimeStart", value.tofloat())}
		CBaseEntity["GetScaleTimeStart"] <- function(){return GetProp("m_flScaleTimeStart")}

		CBaseEntity["SetStartBrightness"] <- function(value){SetProp("m_nStartBrightness", value.tointeger())}
		CBaseEntity["GetStartBrightness"] <- function(){return GetProp("m_nStartBrightness")}

		CBaseEntity["SetDestBrightness"] <- function(value){SetProp("m_nDestBrightness", value.tointeger())}
		CBaseEntity["GetDestBrightness"] <- function(){return GetProp("m_nDestBrightness")}

		CBaseEntity["SetBrightnessTimeStart"] <- function(value){SetProp("m_flBrightnessTimeStart", value.tofloat())}
		CBaseEntity["GetBrightnessTimeStart"] <- function(){return GetProp("m_flBrightnessTimeStart")}


		CBaseEntity["SetLifeTime"] <- function(value){SetProp("m_flLifeTime", value.tofloat())}
		CBaseEntity["GetLifeTime"] <- function(){return GetProp("m_flLifeTime")}

		CBaseEntity["SetStartWidth"] <- function(value){SetProp("m_flStartWidth", value.tofloat())}
		CBaseEntity["GetStartWidth"] <- function(){return GetProp("m_flStartWidth")}

		CBaseEntity["SetEndWidth"] <- function(value){SetProp("m_flEndWidth", value.tofloat())}
		CBaseEntity["GetEndWidth"] <- function(){return GetProp("m_flEndWidth")}

		CBaseEntity["SetStartWidthVariance"] <- function(value){SetProp("m_flStartWidthVariance", value.tofloat())}
		CBaseEntity["GetStartWidthVariance"] <- function(){return GetProp("m_flStartWidthVariance")}

		CBaseEntity["SetTextureRes"] <- function(value){SetProp("m_flTextureRes", value.tofloat())}
		CBaseEntity["GetTextureRes"] <- function(){return GetProp("m_flTextureRes")}

		CBaseEntity["SetMinFadeLength"] <- function(value){SetProp("m_flMinFadeLength", value.tofloat())}
		CBaseEntity["GetMinFadeLength"] <- function(){return GetProp("m_flMinFadeLength")}

		CBaseEntity["SetSkyboxOrigin"] <- function(value){SetProp("m_vecSkyboxOrigin", value)}
		CBaseEntity["GetSkyboxOrigin"] <- function(){return GetProp("m_vecSkyboxOrigin")}

		CBaseEntity["SetSkyboxScale"] <- function(value){SetProp("m_flSkyboxScale", value.tofloat())}
		CBaseEntity["GetSkyboxScale"] <- function(){return GetProp("m_flSkyboxScale")}
			
		CBaseEntity["SetSpriteName"] <- function(value){SetProp("m_iszSpriteName", value.tostring())}
		CBaseEntity["GetSpriteName"] <- function(){return GetProp("m_iszSpriteName")}

		CBaseEntity["SetAnimate"] <- function(value){SetProp("m_bAnimate", value.tointeger())}
		CBaseEntity["GetAnimate"] <- function(){return GetProp("m_bAnimate")}

		CBaseEntity["SetLastTime"] <- function(value){SetProp("m_flLastTime", value.tofloat())}
		CBaseEntity["GetLastTime"] <- function(){return GetProp("m_flLastTime")}

		CBaseEntity["SetMaxFrame"] <- function(value){SetProp("m_flMaxFrame", value.tofloat())}
		CBaseEntity["GetMaxFrame"] <- function(){return GetProp("m_flMaxFrame")}

		CBaseEntity["SetAttachedToEntity"] <- function(value){SetPropEntity("m_hAttachedToEntity", value)}
		CBaseEntity["GetAttachedToEntity"] <- function(value){return GetPropEntity("m_hAttachedToEntity")}

		CBaseEntity["SetAttachment"] <- function(value){SetProp("m_nAttachment", value.tointeger())}
		CBaseEntity["GetAttachment"] <- function(){return GetProp("m_nAttachment")}

		CBaseEntity["SetDieTime"] <- function(value){SetProp("m_flDieTime", value.tofloat())}
		CBaseEntity["GetDieTime"] <- function(){return GetProp("m_flDieTime")}

		CBaseEntity["SetBrightness"] <- function(value){SetProp("m_nBrightness", value.tointeger())}
		CBaseEntity["GetBrightness"] <- function(){return GetProp("m_nBrightness")}

		CBaseEntity["SetBrightnessTime"] <- function(value){SetProp("m_flBrightnessTime", value.tofloat())}
		CBaseEntity["GetBrightnessTime"] <- function(){return GetProp("m_flBrightnessTime")}

		CBaseEntity["SetSpriteScale"] <- function(value){SetProp("m_flSpriteScale", value.tofloat())}
		CBaseEntity["GetSpriteScale"] <- function(){return GetProp("m_flSpriteScale")}

		CBaseEntity["SetSpriteFramerate"] <- function(value){SetProp("m_flSpriteFramerate", value.tofloat())}
		CBaseEntity["GetSpriteFramerate"] <- function(){return GetProp("m_flSpriteFramerate")}

		CBaseEntity["SetFrame"] <- function(value){SetProp("m_flFrame", value.tofloat())}
		CBaseEntity["GetFrame"] <- function(){return GetProp("m_flFrame")}

		CBaseEntity["SetHDRColorScale"] <- function(value){SetProp("m_flHDRColorScale", value.tofloat())}
		CBaseEntity["GetHDRColorScale"] <- function(){return GetProp("m_flHDRColorScale")}

		CBaseEntity["SetGlowProxySize"] <- function(value){SetProp("m_flGlowProxySize", value.tofloat())}
		CBaseEntity["GetGlowProxySize"] <- function(){return GetProp("m_flGlowProxySize")}

		CBaseEntity["SetScaleTime"] <- function(value){SetProp("m_flScaleTime", value.tofloat())}
		CBaseEntity["GetScaleTime"] <- function(){return GetProp("m_flScaleTime")}

		CBaseEntity["SetStartScale"] <- function(value){SetProp("m_flStartScale", value.tofloat())}
		CBaseEntity["GetStartScale"] <- function(){return GetProp("m_flStartScale")}

		CBaseEntity["SetDestScale"] <- function(value){SetProp("m_flDestScale", value.tofloat())}
		CBaseEntity["GetDestScale"] <- function(){return GetProp("m_flDestScale")}

		CBaseEntity["SetScaleTimeStart"] <- function(value){SetProp("m_flScaleTimeStart", value.tofloat())}
		CBaseEntity["GetScaleTimeStart"] <- function(){return GetProp("m_flScaleTimeStart")}

		CBaseEntity["SetStartBrightness"] <- function(value){SetProp("m_nStartBrightness", value.tointeger())}
		CBaseEntity["GetStartBrightness"] <- function(){return GetProp("m_nStartBrightness")}

		CBaseEntity["SetDestBrightness"] <- function(value){SetProp("m_nDestBrightness", value.tointeger())}
		CBaseEntity["GetDestBrightness"] <- function(){return GetProp("m_nDestBrightness")}

		CBaseEntity["SetBrightnessTimeStart"] <- function(value){SetProp("m_flBrightnessTimeStart", value.tofloat())}
		CBaseEntity["GetBrightnessTimeStart"] <- function(){return GetProp("m_flBrightnessTimeStart")}

		CBaseEntity["SetWorldSpaceScale"] <- function(value){SetProp("m_bWorldSpaceScale", value.tointeger())}
		CBaseEntity["GetWorldSpaceScale"] <- function(){return GetProp("m_bWorldSpaceScale")}


		CBaseEntity["SetSpreadSpeed"] <- function(value){SetProp("m_SpreadSpeed", value.tofloat())}
		CBaseEntity["GetSpreadSpeed"] <- function(){return GetProp("m_SpreadSpeed")}

		CBaseEntity["SetSpeed"] <- function(value){SetProp("m_Speed", value.tofloat())}
		CBaseEntity["GetSpeed"] <- function(){return GetProp("m_Speed")}

		CBaseEntity["SetStartSize"] <- function(value){SetProp("m_StartSize", value.tofloat())}
		CBaseEntity["GetStartSize"] <- function(){return GetProp("m_StartSize")}

		CBaseEntity["SetEndSize"] <- function(value){SetProp("m_EndSize", value.tofloat())}
		CBaseEntity["GetEndSize"] <- function(){return GetProp("m_EndSize")}

		CBaseEntity["SetRate"] <- function(value){SetProp("m_Rate", value.tofloat())}
		CBaseEntity["GetRate"] <- function(){return GetProp("m_Rate")}

		CBaseEntity["SetJetLength"] <- function(value){SetProp("m_JetLength", value.tofloat())}
		CBaseEntity["GetJetLength"] <- function(){return GetProp("m_JetLength")}

		CBaseEntity["SetEmit"] <- function(value){SetProp("m_bEmit", value.tointeger())}
		CBaseEntity["GetEmit"] <- function(){return GetProp("m_bEmit")}

		CBaseEntity["SetFaceLeft"] <- function(value){SetProp("m_bFaceLeft", value.tointeger())}
		CBaseEntity["GetFaceLeft"] <- function(){return GetProp("m_bFaceLeft")}

		CBaseEntity["SetType"] <- function(value){SetProp("m_nType", value.tointeger())}
		CBaseEntity["GetType"] <- function(){return GetProp("m_nType")}

		CBaseEntity["SetRollSpeed"] <- function(value){SetProp("m_flRollSpeed", value.tofloat())}
		CBaseEntity["GetRollSpeed"] <- function(){return GetProp("m_flRollSpeed")}

		CBaseEntity["SetNoiseStart"] <- function(value){SetProp("m_NoiseStart", value.tostring())}
		CBaseEntity["GetNoiseStart"] <- function(){return GetProp("m_NoiseStart")}
			
		CBaseEntity["SetInitialState"] <- function(value){SetProp("m_InitialState", value.tointeger())}
		CBaseEntity["GetInitialState"] <- function(){return GetProp("m_InitialState")}


		CBaseEntity["SetOverlayColor"] <- function(value){SetProp("m_clrOverlay", value.tointeger())}
		CBaseEntity["GetOverlayColor"] <- function(){return GetProp("m_clrOverlay")}

		CBaseEntity["SetDirection"] <- function(value){SetProp("m_vDirection", value)}
		CBaseEntity["GetDirection"] <- function(){return GetProp("m_vDirection")}

		CBaseEntity["SetOn"] <- function(value){SetProp("m_bOn", value.tointeger())}
		CBaseEntity["GetOn"] <- function(){return GetProp("m_bOn")}

		CBaseEntity["SetSize"] <- function(value){SetProp("m_nSize", value.tointeger())}
		CBaseEntity["GetSize"] <- function(){return GetProp("m_nSize")}

		CBaseEntity["SetOverlaySize"] <- function(value){SetProp("m_nOverlaySize", value.tointeger())}
		CBaseEntity["GetOverlaySize"] <- function(){return GetProp("m_nOverlaySize")}

		CBaseEntity["SetMaterial"] <- function(value){SetProp("m_strMaterial", value.tostring())}
		CBaseEntity["GetMaterial"] <- function(){return GetProp("m_strMaterial")}

		CBaseEntity["SetOverlayMaterial"] <- function(value){SetProp("m_nOverlayMaterial", value.tointeger())}
		CBaseEntity["GetOverlayMaterial"] <- function(){return GetProp("m_nOverlayMaterial")}

		CBaseEntity["SetHDRColorScale"] <- function(value){SetProp("HDRColorScale", value.tofloat())}
		CBaseEntity["GetHDRColorScale"] <- function(){return GetProp("HDRColorScale")}
			
		CBaseEntity["SetUseAngles"] <- function(value){SetProp("m_bUseAngles", value.tointeger())}
		CBaseEntity["GetUseAngles"] <- function(){return GetProp("m_bUseAngles")}

		CBaseEntity["SetPitch"] <- function(value){SetProp("m_flPitch", value.tofloat())}
		CBaseEntity["GetPitch"] <- function(){return GetProp("m_flPitch")}

		CBaseEntity["SetYaw"] <- function(value){SetProp("m_flYaw", value.tofloat())}
		CBaseEntity["GetYaw"] <- function(){return GetProp("m_flYaw")}


		CBaseEntity["SetUseCustomAutoExposureMin"] <- function(value){SetProp("m_bUseCustomAutoExposureMin", value.tointeger())}
		CBaseEntity["GetUseCustomAutoExposureMin"] <- function(){return GetProp("m_bUseCustomAutoExposureMin")}

		CBaseEntity["SetUseCustomAutoExposureMax"] <- function(value){SetProp("m_bUseCustomAutoExposureMax", value.tointeger())}
		CBaseEntity["GetUseCustomAutoExposureMax"] <- function(){return GetProp("m_bUseCustomAutoExposureMax")}

		CBaseEntity["SetUseCustomBloomScale"] <- function(value){SetProp("m_bUseCustomBloomScale", value.tointeger())}
		CBaseEntity["GetUseCustomBloomScale"] <- function(){return GetProp("m_bUseCustomBloomScale")}

		CBaseEntity["SetCustomAutoExposureMin"] <- function(value){SetProp("m_flCustomAutoExposureMin", value.tofloat())}
		CBaseEntity["GetCustomAutoExposureMin"] <- function(){return GetProp("m_flCustomAutoExposureMin")}

		CBaseEntity["SetCustomAutoExposureMax"] <- function(value){SetProp("m_flCustomAutoExposureMax", value.tofloat())}
		CBaseEntity["GetCustomAutoExposureMax"] <- function(){return GetProp("m_flCustomAutoExposureMax")}

		CBaseEntity["SetCustomBloomScale"] <- function(value){SetProp("m_flCustomBloomScale", value.tofloat())}
		CBaseEntity["GetCustomBloomScale"] <- function(){return GetProp("m_flCustomBloomScale")}

		CBaseEntity["SetCustomBloomScaleMinimum"] <- function(value){SetProp("m_flCustomBloomScaleMinimum", value.tofloat())}
		CBaseEntity["GetCustomBloomScaleMinimum"] <- function(){return GetProp("m_flCustomBloomScaleMinimum")}

		CBaseEntity["SetBloomExponent"] <- function(value){SetProp("m_flBloomExponent", value.tofloat())}
		CBaseEntity["GetBloomExponent"] <- function(){return GetProp("m_flBloomExponent")}

		CBaseEntity["SetBloomSaturation"] <- function(value){SetProp("m_flBloomSaturation", value.tofloat())}
		CBaseEntity["GetBloomSaturation"] <- function(){return GetProp("m_flBloomSaturation")}

		CBaseEntity["SetTonemapPercentTarget"] <- function(value){SetProp("m_flTonemapPercentTarget", value.tofloat())}
		CBaseEntity["GetTonemapPercentTarget"] <- function(){return GetProp("m_flTonemapPercentTarget")}

		CBaseEntity["SetTonemapPercentBrightPixels"] <- function(value){SetProp("m_flTonemapPercentBrightPixels", value.tofloat())}
		CBaseEntity["GetTonemapPercentBrightPixels"] <- function(){return GetProp("m_flTonemapPercentBrightPixels")}

		CBaseEntity["SetTonemapMinAvgLum"] <- function(value){SetProp("m_flTonemapMinAvgLum", value.tofloat())}
		CBaseEntity["GetTonemapMinAvgLum"] <- function(){return GetProp("m_flTonemapMinAvgLum")}
			
		CBaseEntity["SetBlendTonemapStart"] <- function(value){SetProp("m_flBlendTonemapStart", value.tofloat())}
		CBaseEntity["GetBlendTonemapStart"] <- function(){return GetProp("m_flBlendTonemapStart")}

		CBaseEntity["SetBlendTonemapEnd"] <- function(value){SetProp("m_flBlendTonemapEnd", value.tofloat())}
		CBaseEntity["GetBlendTonemapEnd"] <- function(){return GetProp("m_flBlendTonemapEnd")}

		CBaseEntity["SetBlendEndTime"] <- function(value){SetProp("m_flBlendEndTime", value.tofloat())}
		CBaseEntity["GetBlendEndTime"] <- function(){return GetProp("m_flBlendEndTime")}

		CBaseEntity["SetBlendStartTime"] <- function(value){SetProp("m_flBlendStartTime", value.tofloat())}
		CBaseEntity["GetBlendStartTime"] <- function(){return GetProp("m_flBlendStartTime")}


		CBaseEntity["SetWeaponType"] <- function(value){SetProp("m_iWeaponType", value.tointeger())}
		CBaseEntity["GetWeaponType"] <- function(){return GetProp("m_iWeaponType")}

		CBaseEntity["SetShotsTaken"] <- function(value){SetProp("m_iShotsTaken", value.tointeger())}
		CBaseEntity["GetShotsTaken"] <- function(){return GetProp("m_iShotsTaken")}

		CBaseEntity["SetShotDest"] <- function(value){SetProp("m_vecShotDest", value)}
		CBaseEntity["GetShotDest"] <- function(){return GetProp("m_vecShotDest")}
			
		CBaseEntity["SetDisabled"] <- function(value){SetProp("m_bDisabled", value.tointeger())}
		CBaseEntity["GetDisabled"] <- function(){return GetProp("m_bDisabled")}

		CBaseEntity["SetIgnorePlayers"] <- function(value){SetProp("m_bIgnorePlayers", value.tointeger())}
		CBaseEntity["GetIgnorePlayers"] <- function(){return GetProp("m_bIgnorePlayers")}

		CBaseEntity["SetTargetArc"] <- function(value){SetProp("m_flTargetArc", value.tofloat())}
		CBaseEntity["GetTargetArc"] <- function(){return GetProp("m_flTargetArc")}

		CBaseEntity["SetTargetRange"] <- function(value){SetProp("m_flTargetRange", value.tofloat())}
		CBaseEntity["GetTargetRange"] <- function(){return GetProp("m_flTargetRange")}

		CBaseEntity["SetDamageMod"] <- function(value){SetProp("m_flDamageMod", value.tofloat())}
		CBaseEntity["GetDamageMod"] <- function(){return GetProp("m_flDamageMod")}

		CBaseEntity["SetFilterName"] <- function(value){SetProp("m_iFilterName", value.tostring())}
		CBaseEntity["GetFilterName"] <- function(){return GetProp("m_iFilterName")}

		CBaseEntity["SetEnemyTeam"] <- function(value){SetProp("m_iEnemyTeam", value.tointeger())}
		CBaseEntity["GetEnemyTeam"] <- function(){return GetProp("m_iEnemyTeam")}


		CBaseEntity["SetMinWind"] <- function(value){SetProp("m_iMinWind", value.tointeger())}
		CBaseEntity["GetMinWind"] <- function(){return GetProp("m_iMinWind")}

		CBaseEntity["SetMaxWind"] <- function(value){SetProp("m_iMaxWind", value.tointeger())}
		CBaseEntity["GetMaxWind"] <- function(){return GetProp("m_iMaxWind")}

		CBaseEntity["SetWindRadius"] <- function(value){SetProp("m_windRadius", value.tointeger())}
		CBaseEntity["GetWindRadius"] <- function(){return GetProp("m_windRadius")}

		CBaseEntity["SetMinGust"] <- function(value){SetProp("m_iMinGust", value.tointeger())}
		CBaseEntity["GetMinGust"] <- function(){return GetProp("m_iMinGust")}

		CBaseEntity["SetMaxGust"] <- function(value){SetProp("m_iMaxGust", value.tointeger())}
		CBaseEntity["GetMaxGust"] <- function(){return GetProp("m_iMaxGust")}

		CBaseEntity["SetMinGustDelay"] <- function(value){SetProp("m_flMinGustDelay", value.tofloat())}
		CBaseEntity["GetMinGustDelay"] <- function(){return GetProp("m_flMinGustDelay")}

		CBaseEntity["SetMaxGustDelay"] <- function(value){SetProp("m_flMaxGustDelay", value.tofloat())}
		CBaseEntity["GetMaxGustDelay"] <- function(){return GetProp("m_flMaxGustDelay")}

		CBaseEntity["SetGustDirChange"] <- function(value){SetProp("m_iGustDirChange", value.tointeger())}
		CBaseEntity["GetGustDirChange"] <- function(){return GetProp("m_iGustDirChange")}

		CBaseEntity["SetWindSeed"] <- function(value){SetProp("m_iWindSeed", value.tointeger())}
		CBaseEntity["GetWindSeed"] <- function(){return GetProp("m_iWindSeed")}

		CBaseEntity["SetLocation"] <- function(value){SetProp("m_location", value)}
		CBaseEntity["GetLocation"] <- function(){return GetProp("m_location")}

		CBaseEntity["SetInitialWindDir"] <- function(value){SetProp("m_iInitialWindDir", value.tointeger())}
		CBaseEntity["GetInitialWindDir"] <- function(){return GetProp("m_iInitialWindDir")}

		CBaseEntity["SetInitialWindSpeed"] <- function(value){SetProp("m_flInitialWindSpeed", value.tofloat())}
		CBaseEntity["GetInitialWindSpeed"] <- function(){return GetProp("m_flInitialWindSpeed")}

		CBaseEntity["SetStartTime"] <- function(value){SetProp("m_flStartTime", value.tofloat())}
		CBaseEntity["GetStartTime"] <- function(){return GetProp("m_flStartTime")}

		CBaseEntity["SetGustDuration"] <- function(value){SetProp("m_flGustDuration", value.tofloat())}
		CBaseEntity["GetGustDuration"] <- function(){return GetProp("m_flGustDuration")}
			
		CBaseEntity["SetWindDir"] <- function(value){SetProp("m_iWindDir", value.tointeger())}
		CBaseEntity["GetWindDir"] <- function(){return GetProp("m_iWindDir")}

		CBaseEntity["SetWindSpeed"] <- function(value){SetProp("m_flWindSpeed", value.tofloat())}
		CBaseEntity["GetWindSpeed"] <- function(){return GetProp("m_flWindSpeed")}


		CBaseEntity["SetTriggerState"] <- function(value){SetProp("m_triggerState", value.tointeger())}
		CBaseEntity["GetTriggerState"] <- function(){return GetProp("m_triggerState")}

		CBaseEntity["SetDisabled"] <- function(value){SetProp("m_bDisabled", value.tointeger())}
		CBaseEntity["GetDisabled"] <- function(){return GetProp("m_bDisabled")}
			
		CBaseEntity["SetFirstUseDelay"] <- function(value){SetProp("m_firstUseDelay", value.tofloat())}
		CBaseEntity["GetFirstUseDelay"] <- function(){return GetProp("m_firstUseDelay")}

		CBaseEntity["SetUseDelay"] <- function(value){SetProp("m_useDelay", value.tofloat())}
		CBaseEntity["GetUseDelay"] <- function(){return GetProp("m_useDelay")}

		CBaseEntity["SetType"] <- function(value){SetProp("m_type", value.tointeger())}
		CBaseEntity["GetType"] <- function(){return GetProp("m_type")}

		CBaseEntity["SetScriptFile"] <- function(value){SetProp("m_scriptfile", value.tostring())}
		CBaseEntity["GetScriptFile"] <- function(){return GetProp("m_scriptfile")}

		CBaseEntity["SetVersusTravelCompletion"] <- function(value){SetProp("m_flVersusTravelCompletion", value.tofloat())}
		CBaseEntity["GetVersusTravelCompletion"] <- function(){return GetProp("m_flVersusTravelCompletion")}

		CBaseEntity["SetSacrificeFinale"] <- function(value){SetProp("m_bIsSacrificeFinale", value.tointeger())}
		CBaseEntity["GetSacrificeFinale"] <- function(){return GetProp("m_bIsSacrificeFinale")}


		CBaseEntity["SetPoolOrigin"] <- function(value){SetProp("m_poolOrigin", value)}
		CBaseEntity["GetPoolOrigin"] <- function(){return GetProp("m_poolOrigin")}

		CBaseEntity["SetAngle"] <- function(value){SetProp("m_angle", value.tofloat())}
		CBaseEntity["GetAngle"] <- function(){return GetProp("m_angle")}

		CBaseEntity["SetX"] <- function(value){SetProp("m_x", value.tofloat())}
		CBaseEntity["GetX"] <- function(){return GetProp("m_x")}

		CBaseEntity["SetY"] <- function(value){SetProp("m_y", value.tofloat())}
		CBaseEntity["GetY"] <- function(){return GetProp("m_y")}

		CBaseEntity["SetZ"] <- function(value){SetProp("m_z", value.tofloat())}
		CBaseEntity["GetZ"] <- function(){return GetProp("m_z")}

		CBaseEntity["SetWaterLevel"] <- function(value){SetProp("m_waterLevel", value.tofloat())}
		CBaseEntity["GetWaterLevel"] <- function(){return GetProp("m_waterLevel")}
			
		CBaseEntity["SetPool"] <- function(value){SetPropEntity("m_pool", value)}
		CBaseEntity["GetPool"] <- function(value){return GetPropEntity("m_pool")}

		CBaseEntity["SetID"] <- function(value){SetProp("m_id", value.tointeger())}
		CBaseEntity["GetID"] <- function(){return GetProp("m_id")}

		CBaseEntity["SetAngleChange"] <- function(value){SetProp("m_angleChange", value.tofloat())}
		CBaseEntity["GetAngleChange"] <- function(){return GetProp("m_angleChange")}

		CBaseEntity["SetForward"] <- function(value){SetProp("m_forward", value)}
		CBaseEntity["GetForward"] <- function(){return GetProp("m_forward")}

		CBaseEntity["SetPerp"] <- function(value){SetPropEntity("m_perp", value)}
		CBaseEntity["GetPerp"] <- function(value){return GetPropEntity("m_perp")}

		CBaseEntity["SetSpeed"] <- function(value){SetProp("m_speed", value.tofloat())}
		CBaseEntity["GetSpeed"] <- function(){return GetProp("m_speed")}

		CBaseEntity["SetDesiredSpeed"] <- function(value){SetProp("m_desiredSpeed", value.tofloat())}
		CBaseEntity["GetDesiredSpeed"] <- function(){return GetProp("m_desiredSpeed")}

		CBaseEntity["SetCalmSpeed"] <- function(value){SetProp("m_calmSpeed", value.tofloat())}
		CBaseEntity["GetCalmSpeed"] <- function(){return GetProp("m_calmSpeed")}

		CBaseEntity["SetPanicSpeed"] <- function(value){SetProp("m_panicSpeed", value.tofloat())}
		CBaseEntity["GetPanicSpeed"] <- function(){return GetProp("m_panicSpeed")}

		CBaseEntity["SetAvoidRange"] <- function(value){SetProp("m_avoidRange", value.tofloat())}
		CBaseEntity["GetAvoidRange"] <- function(){return GetProp("m_avoidRange")}

		CBaseEntity["SetTurnClockwise"] <- function(value){SetProp("m_turnClockwise", value.tointeger())}
		CBaseEntity["GetTurnClockwise"] <- function(){return GetProp("m_turnClockwise")}


		CBaseEntity["SetFadeDist"] <- function(value){SetProp("m_flFadeDist", value.tofloat())}
		CBaseEntity["GetFadeDist"] <- function(){return GetProp("m_flFadeDist")}

		CBaseEntity["SetFadeStartDist"] <- function(value){SetProp("m_flFadeStartDist", value.tofloat())}
		CBaseEntity["GetFadeStartDist"] <- function(){return GetProp("m_flFadeStartDist")}

		CBaseEntity["SetTranslucencyLimit"] <- function(value){SetProp("m_flTranslucencyLimit", value.tofloat())}
		CBaseEntity["GetTranslucencyLimit"] <- function(){return GetProp("m_flTranslucencyLimit")}

		CBaseEntity["SetBackgroundModelIndex"] <- function(value){SetProp("m_iBackgroundModelIndex", value.tointeger())}
		CBaseEntity["GetBackgroundModelIndex"] <- function(){return GetProp("m_iBackgroundModelIndex")}
			
		CBaseEntity["SetPortalNumber"] <- function(value){SetProp("m_portalNumber", value.tointeger())}
		CBaseEntity["GetPortalNumber"] <- function(){return GetProp("m_portalNumber")}

		CBaseEntity["SetBackgroundBModelName"] <- function(value){SetProp("m_iBackgroundBModelName", value.tostring())}
		CBaseEntity["GetBackgroundBModelName"] <- function(){return GetProp("m_iBackgroundBModelName")}

		CBaseEntity["SetPortalVersion"] <- function(value){SetProp("m_iPortalVersion", value.tointeger())}
		CBaseEntity["GetPortalVersion"] <- function(){return GetProp("m_iPortalVersion")}


		CBaseEntity["SetNumWide"] <- function(value){SetProp("m_nNumWide", value.tointeger())}
		CBaseEntity["GetNumWide"] <- function(){return GetProp("m_nNumWide")}

		CBaseEntity["SetNumHigh"] <- function(value){SetProp("m_nNumHigh", value.tointeger())}
		CBaseEntity["GetNumHigh"] <- function(){return GetProp("m_nNumHigh")}

		CBaseEntity["SetPanelWidth"] <- function(value){SetProp("m_flPanelWidth", value.tofloat())}
		CBaseEntity["GetPanelWidth"] <- function(){return GetProp("m_flPanelWidth")}

		CBaseEntity["SetPanelHeight"] <- function(value){SetProp("m_flPanelHeight", value.tofloat())}
		CBaseEntity["GetPanelHeight"] <- function(){return GetProp("m_flPanelHeight")}

		CBaseEntity["SetNormal"] <- function(value){SetProp("m_vNormal", value)}
		CBaseEntity["GetNormal"] <- function(){return GetProp("m_vNormal")}

		CBaseEntity["SetCorner"] <- function(value){SetProp("m_vCorner", value)}
		CBaseEntity["GetCorner"] <- function(){return GetProp("m_vCorner")}

		CBaseEntity["SetBroken"] <- function(value){SetProp("m_bIsBroken", value.tointeger())}
		CBaseEntity["GetBroken"] <- function(){return GetProp("m_bIsBroken")}

		CBaseEntity["SetSurfaceType"] <- function(value){SetProp("m_nSurfaceType", value.tointeger())}
		CBaseEntity["GetSurfaceType"] <- function(){return GetProp("m_nSurfaceType")}

		CBaseEntity["SetNoGhostCollision"] <- function(value){SetProp("m_noGhostCollision", value.tointeger())}
		CBaseEntity["GetNoGhostCollision"] <- function(){return GetProp("m_noGhostCollision")}

		CBaseEntity["SetRawPanelBitVec"] <- function(value){SetProp("m_RawPanelBitVec", value)}
		CBaseEntity["GetRawPanelBitVec"] <- function(value){return GetProp("m_RawPanelBitVec", null, true)}
			
		CBaseEntity["SetFragility"] <- function(value){SetProp("m_nFragility", value.tointeger())}
		CBaseEntity["GetFragility"] <- function(){return GetProp("m_nFragility")}

		CBaseEntity["SetQuadError"] <- function(value){SetProp("m_nQuadError", value.tointeger())}
		CBaseEntity["GetQuadError"] <- function(){return GetProp("m_nQuadError")}

		CBaseEntity["SetCorner"] <- function(value){SetProp("m_vCorner", value)}
		CBaseEntity["GetCorner"] <- function(){return GetProp("m_vCorner")}

		CBaseEntity["SetBroken"] <- function(value){SetProp("m_bIsBroken", value.tointeger())}
		CBaseEntity["GetBroken"] <- function(){return GetProp("m_bIsBroken")}

		CBaseEntity["SetNumBrokenPanes"] <- function(value){SetProp("m_nNumBrokenPanes", value.tointeger())}
		CBaseEntity["GetNumBrokenPanes"] <- function(){return GetProp("m_nNumBrokenPanes")}

		CBaseEntity["SetSupport"] <- function(value){SetProp("m_flSupport", value.tofloat())}
		CBaseEntity["GetSupport"] <- function(){return GetProp("m_flSupport")}


		CBaseEntity["SetGlowEntity"] <- function(value){SetPropEntity("m_glowEntity", value)}
		CBaseEntity["GetGlowEntity"] <- function(value){return GetPropEntity("m_glowEntity")}

		CBaseEntity["SetUsable"] <- function(value){SetProp("m_usable", value.tointeger())}
		CBaseEntity["GetUsable"] <- function(){return GetProp("m_usable")}
			
		CBaseEntity["SetMoveDir"] <- function(value){SetProp("m_vecMoveDir", value)}
		CBaseEntity["GetMoveDir"] <- function(){return GetProp("m_vecMoveDir")}

		CBaseEntity["SetStayPushed"] <- function(value){SetProp("m_fStayPushed", value.tofloat())}
		CBaseEntity["GetStayPushed"] <- function(){return GetProp("m_fStayPushed")}

		CBaseEntity["SetRotating"] <- function(value){SetProp("m_fRotating", value.tofloat())}
		CBaseEntity["GetRotating"] <- function(){return GetProp("m_fRotating")}

		CBaseEntity["SetLockedSound"] <- function(value){SetProp("m_bLockedSound", value.tointeger())}
		CBaseEntity["GetLockedSound"] <- function(){return GetProp("m_bLockedSound")}

		CBaseEntity["SetLockedSentence"] <- function(value){SetProp("m_bLockedSentence", value.tointeger())}
		CBaseEntity["GetLockedSentence"] <- function(){return GetProp("m_bLockedSentence")}

		CBaseEntity["SetUnlockedSound"] <- function(value){SetProp("m_bUnlockedSound", value.tointeger())}
		CBaseEntity["GetUnlockedSound"] <- function(){return GetProp("m_bUnlockedSound")}

		CBaseEntity["SetUnlockedSentence"] <- function(value){SetProp("m_bUnlockedSentence", value.tointeger())}
		CBaseEntity["GetUnlockedSentence"] <- function(){return GetProp("m_bUnlockedSentence")}

		CBaseEntity["SetLocked"] <- function(value){SetProp("m_bLocked", value.tointeger())}
		CBaseEntity["GetLocked"] <- function(){return GetProp("m_bLocked")}

		CBaseEntity["SetNoise"] <- function(value){SetProp("m_sNoise", value.tostring())}
		CBaseEntity["GetNoise"] <- function(){return GetProp("m_sNoise")}

		CBaseEntity["SetUseLockedTime"] <- function(value){SetProp("m_flUseLockedTime", value.tofloat())}
		CBaseEntity["GetUseLockedTime"] <- function(){return GetProp("m_flUseLockedTime")}

		CBaseEntity["SetSolidBsp"] <- function(value){SetProp("m_bSolidBsp", value.tointeger())}
		CBaseEntity["GetSolidBsp"] <- function(){return GetProp("m_bSolidBsp")}

		CBaseEntity["SetSounds"] <- function(value){SetProp("m_sounds", value.tostring())}
		CBaseEntity["GetSounds"] <- function(){return GetProp("m_sounds")}


		CBaseEntity["SetUseString"] <- function(value){SetProp("m_sUseString", value.tostring())}
		CBaseEntity["GetUseString"] <- function(){return GetProp("m_sUseString")}

		CBaseEntity["SetUseSubstring"] <- function(value){SetProp("m_sUseSubString", value.tostring())}
		CBaseEntity["GetUseSubstring"] <- function(){return GetProp("m_sUseSubString")}
			
		CBaseEntity["SetAutoDisable"] <- function(value){SetProp("m_bAutoDisable", value.tointeger())}
		CBaseEntity["GetAutoDisable"] <- function(){return GetProp("m_bAutoDisable")}

		CBaseEntity["SetUseTime"] <- function(value){SetProp("m_nUseTime", value.tofloat())}
		CBaseEntity["GetUseTime"] <- function(){return GetProp("m_nUseTime")}


		CBaseEntity["SetConveyorSpeed"] <- function(value){SetProp("m_flConveyorSpeed", value.tofloat())}
		CBaseEntity["GetConveyorSpeed"] <- function(){return GetProp("m_flConveyorSpeed")}
			
		CBaseEntity["SetMoveDir"] <- function(value){SetProp("m_vecMoveDir", value)}
		CBaseEntity["GetMoveDir"] <- function(){return GetProp("m_vecMoveDir")}

		CBaseEntity["SetState"] <- function(value){SetProp("m_nState", value.tointeger())}
		CBaseEntity["GetState"] <- function(){return GetProp("m_nState")}


		CBaseEntity["SetWaveHeight"] <- function(value){SetProp("m_flWaveHeight", value.tofloat())}
		CBaseEntity["GetWaveHeight"] <- function(){return GetProp("m_flWaveHeight")}
			
		CBaseEntity["SetMoveDir"] <- function(value){SetProp("m_vecMoveDir", value)}
		CBaseEntity["GetMoveDir"] <- function(){return GetProp("m_vecMoveDir")}

		CBaseEntity["SetLockedSentence"] <- function(value){SetProp("m_bLockedSentence", value.tointeger())}
		CBaseEntity["GetLockedSentence"] <- function(){return GetProp("m_bLockedSentence")}

		CBaseEntity["SetUnlockedSentence"] <- function(value){SetProp("m_bUnlockedSentence", value.tointeger())}
		CBaseEntity["GetUnlockedSentence"] <- function(){return GetProp("m_bUnlockedSentence")}

		CBaseEntity["SetNoiseMoving"] <- function(value){SetProp("m_NoiseMoving", value.tostring())}
		CBaseEntity["GetNoiseMoving"] <- function(){return GetProp("m_NoiseMoving")}

		CBaseEntity["SetNoiseArrived"] <- function(value){SetProp("m_NoiseArrived", value.tostring())}
		CBaseEntity["GetNoiseArrived"] <- function(){return GetProp("m_NoiseArrived")}

		CBaseEntity["SetNoiseMovingClosed"] <- function(value){SetProp("m_NoiseMovingClosed", value.tostring())}
		CBaseEntity["GetNoiseMovingClosed"] <- function(){return GetProp("m_NoiseMovingClosed")}

		CBaseEntity["SetNoiseArrivedClosed"] <- function(value){SetProp("m_NoiseArrivedClosed", value.tostring())}
		CBaseEntity["GetNoiseArrivedClosed"] <- function(){return GetProp("m_NoiseArrivedClosed")}

		CBaseEntity["SetChainTarget"] <- function(value){SetProp("m_ChainTarget", value.tostring())}
		CBaseEntity["GetChainTarget"] <- function(){return GetProp("m_ChainTarget")}

		CBaseEntity["SetLockedSound"] <- function(value){SetProp("m_ls.sLockedSound", value.tostring())}
		CBaseEntity["GetLockedSound"] <- function(value){return GetProp("m_ls.sLockedSound")}

		CBaseEntity["SetUnlockedSound"] <- function(value){SetProp("m_ls.sUnlockedSound", value.tostring())}
		CBaseEntity["GetUnlockedSound"] <- function(value){return GetProp("m_ls.sUnlockedSound")}

		CBaseEntity["SetLocked"] <- function(value){SetProp("m_bLocked", value.tointeger())}
		CBaseEntity["GetLocked"] <- function(){return GetProp("m_bLocked")}

		CBaseEntity["SetBlockDamage"] <- function(value){SetProp("m_flBlockDamage", value.tofloat())}
		CBaseEntity["GetBlockDamage"] <- function(){return GetProp("m_flBlockDamage")}

		CBaseEntity["SetSpawnPosition"] <- function(value){SetProp("m_eSpawnPosition", value)}
		CBaseEntity["GetSpawnPosition"] <- function(){return GetProp("m_eSpawnPosition")}

		CBaseEntity["SetForceClosed"] <- function(value){SetProp("m_bForceClosed", value.tointeger())}
		CBaseEntity["GetForceClosed"] <- function(){return GetProp("m_bForceClosed")}

		CBaseEntity["SetDoorGroup"] <- function(value){SetProp("m_bDoorGroup", value.tointeger())}
		CBaseEntity["GetDoorGroup"] <- function(){return GetProp("m_bDoorGroup")}

		CBaseEntity["SetLoopMoveSound"] <- function(value){SetProp("m_bLoopMoveSound", value.tointeger())}
		CBaseEntity["GetLoopMoveSound"] <- function(){return GetProp("m_bLoopMoveSound")}

		CBaseEntity["SetIgnoreDebris"] <- function(value){SetProp("m_bIgnoreDebris", value.tointeger())}
		CBaseEntity["GetIgnoreDebris"] <- function(){return GetProp("m_bIgnoreDebris")}


		CBaseEntity["SetColor"] <- function(value){SetProp("m_Color", value.tointeger())}
		CBaseEntity["GetColor"] <- function(){return GetProp("m_Color")}

		CBaseEntity["SetSpawnRate"] <- function(value){SetProp("m_SpawnRate", value.tointeger())}
		CBaseEntity["GetSpawnRate"] <- function(){return GetProp("m_SpawnRate")}

		CBaseEntity["SetSpeedMax"] <- function(value){SetProp("m_SpeedMax", value.tointeger())}
		CBaseEntity["GetSpeedMax"] <- function(){return GetProp("m_SpeedMax")}

		CBaseEntity["SetSizeMin"] <- function(value){SetProp("m_flSizeMin", value.tofloat())}
		CBaseEntity["GetSizeMin"] <- function(){return GetProp("m_flSizeMin")}

		CBaseEntity["SetSizeMax"] <- function(value){SetProp("m_flSizeMax", value.tofloat())}
		CBaseEntity["GetSizeMax"] <- function(){return GetProp("m_flSizeMax")}

		CBaseEntity["SetDistMax"] <- function(value){SetProp("m_DistMax", value.tointeger())}
		CBaseEntity["GetDistMax"] <- function(){return GetProp("m_DistMax")}

		CBaseEntity["SetLifetimeMin"] <- function(value){SetProp("m_LifetimeMin", value.tointeger())}
		CBaseEntity["GetLifetimeMin"] <- function(){return GetProp("m_LifetimeMin")}

		CBaseEntity["SetLifetimeMax"] <- function(value){SetProp("m_LifetimeMax", value.tointeger())}
		CBaseEntity["GetLifetimeMax"] <- function(){return GetProp("m_LifetimeMax")}

		CBaseEntity["SetDustFlags"] <- function(value){SetProp("m_DustFlags", value.tointeger())}
		CBaseEntity["GetDustFlags"] <- function(){return GetProp("m_DustFlags")}

		CBaseEntity["SetFallSpeed"] <- function(value){SetProp("m_FallSpeed", value.tofloat())}
		CBaseEntity["GetFallSpeed"] <- function(){return GetProp("m_FallSpeed")}
			
		CBaseEntity["SetAlpha"] <- function(value){SetProp("m_iAlpha", value.tointeger())}
		CBaseEntity["GetAlpha"] <- function(){return GetProp("m_iAlpha")}


		CBaseEntity["SetAcceleration"] <- function(value){SetProp("m_acceleration", value.tofloat())}
		CBaseEntity["GetAcceleration"] <- function(){return GetProp("m_acceleration")}

		CBaseEntity["SetMovementStartTime"] <- function(value){SetProp("m_movementStartTime", value.tofloat())}
		CBaseEntity["GetMovementStartTime"] <- function(){return GetProp("m_movementStartTime")}

		CBaseEntity["SetMovementStartSpeed"] <- function(value){SetProp("m_movementStartSpeed", value.tofloat())}
		CBaseEntity["GetMovementStartSpeed"] <- function(){return GetProp("m_movementStartSpeed")}

		CBaseEntity["SetMovementStartZ"] <- function(value){SetProp("m_movementStartZ", value.tofloat())}
		CBaseEntity["GetMovementStartZ"] <- function(){return GetProp("m_movementStartZ")}

		CBaseEntity["SetDestinationFloorPosition"] <- function(value){SetProp("m_destinationFloorPosition", value.tofloat())}
		CBaseEntity["GetDestinationFloorPosition"] <- function(){return GetProp("m_destinationFloorPosition")}

		CBaseEntity["SetMaxSpeed"] <- function(value){SetProp("m_maxSpeed", value.tofloat())}
		CBaseEntity["GetMaxSpeed"] <- function(){return GetProp("m_maxSpeed")}

		CBaseEntity["SetMoving"] <- function(value){SetProp("m_isMoving", value.tointeger())}
		CBaseEntity["GetMoving"] <- function(){return GetProp("m_isMoving")}
			
		CBaseEntity["SetTopFloorPosition"] <- function(value){SetProp("m_topFloorPosition", value)}
		CBaseEntity["GetTopFloorPosition"] <- function(){return GetProp("m_topFloorPosition")}

		CBaseEntity["SetBottomFloorPosition"] <- function(value){SetProp("m_bottomFloorPosition", value)}
		CBaseEntity["GetBottomFloorPosition"] <- function(){return GetProp("m_bottomFloorPosition")}

		CBaseEntity["SetSoundStart"] <- function(value){SetProp("m_soundStart", value.tostring())}
		CBaseEntity["GetSoundStart"] <- function(){return GetProp("m_soundStart")}

		CBaseEntity["SetSoundStop"] <- function(value){SetProp("m_soundStop", value.tostring())}
		CBaseEntity["GetSoundStop"] <- function(){return GetProp("m_soundStop")}

		CBaseEntity["SetSoundDisable"] <- function(value){SetProp("m_soundDisable", value.tostring())}
		CBaseEntity["GetSoundDisable"] <- function(){return GetProp("m_soundDisable")}

		CBaseEntity["SetCurrentSound"] <- function(value){SetProp("m_currentSound", value.tostring())}
		CBaseEntity["GetCurrentSound"] <- function(){return GetProp("m_currentSound")}

		CBaseEntity["SetBlockDamage"] <- function(value){SetProp("m_flBlockDamage", value.tofloat())}
		CBaseEntity["GetBlockDamage"] <- function(){return GetProp("m_flBlockDamage")}


		CBaseEntity["SetDisappearMinDist"] <- function(value){SetProp("m_nDisappearMinDist", value.tointeger())}
		CBaseEntity["GetDisappearMinDist"] <- function(){return GetProp("m_nDisappearMinDist")}

		CBaseEntity["SetDisappearMaxDist"] <- function(value){SetProp("m_nDisappearMaxDist", value.tointeger())}
		CBaseEntity["GetDisappearMaxDist"] <- function(){return GetProp("m_nDisappearMaxDist")}


		CBaseEntity["SetActive"] <- function(value){SetProp("m_bActive", value.tointeger())}
		CBaseEntity["GetActive"] <- function(){return GetProp("m_bActive")}

		CBaseEntity["SetOccluderIndex"] <- function(value){SetProp("m_nOccluderIndex", value.tointeger())}
		CBaseEntity["GetOccluderIndex"] <- function(){return GetProp("m_nOccluderIndex")}


		CBaseEntity["SetPhysicsMode"] <- function(value){SetProp("m_iPhysicsMode", value.tointeger())}
		CBaseEntity["GetPhysicsMode"] <- function(){return GetProp("m_iPhysicsMode")}

		CBaseEntity["SetMass"] <- function(value){SetProp("m_fMass", value.tofloat())}
		CBaseEntity["GetMass"] <- function(){return GetProp("m_fMass")}
			
		CBaseEntity["SetCarryingPlayer"] <- function(value){SetPropEntity("m_hCarryingPlayer", value)}
		CBaseEntity["GetCarryingPlayer"] <- function(value){return GetPropEntity("m_hCarryingPlayer")}

		CBaseEntity["SetMassScale"] <- function(value){SetProp("m_massScale", value.tofloat())}
		CBaseEntity["GetMassScale"] <- function(){return GetProp("m_massScale")}

		CBaseEntity["SetDamageType"] <- function(value){SetProp("m_damageType", value.tointeger())}
		CBaseEntity["GetDamageType"] <- function(){return GetProp("m_damageType")}

		CBaseEntity["SetOverrideScript"] <- function(value){SetProp("m_iszOverrideScript", value.tostring())}
		CBaseEntity["GetOverrideScript"] <- function(){return GetProp("m_iszOverrideScript")}

		CBaseEntity["SetDamageToEnableMotion"] <- function(value){SetProp("m_damageToEnableMotion", value.tointeger())}
		CBaseEntity["GetDamageToEnableMotion"] <- function(){return GetProp("m_damageToEnableMotion")}

		CBaseEntity["SetForceToEnableMotion"] <- function(value){SetProp("m_flForceToEnableMotion", value.tofloat())}
		CBaseEntity["GetForceToEnableMotion"] <- function(){return GetProp("m_flForceToEnableMotion")}

		CBaseEntity["SetPreferredCarryAngles"] <- function(value){SetProp("m_angPreferredCarryAngles", value)}
		CBaseEntity["GetPreferredCarryAngles"] <- function(){return GetProp("m_angPreferredCarryAngles")}

		CBaseEntity["SetNotSolidToWorld"] <- function(value){SetProp("m_bNotSolidToWorld", value.tointeger())}
		CBaseEntity["GetNotSolidToWorld"] <- function(){return GetProp("m_bNotSolidToWorld")}

		CBaseEntity["SetExploitableByPlayer"] <- function(value){SetProp("m_iExploitableByPlayer", value.tointeger())}
		CBaseEntity["GetExploitableByPlayer"] <- function(){return GetProp("m_iExploitableByPlayer")}


		CBaseEntity["SetPrecipType"] <- function(value){SetProp("m_nPrecipType", value.tointeger())}
		CBaseEntity["GetPrecipType"] <- function(){return GetProp("m_nPrecipType")}

		CBaseEntity["SetMinSpeed"] <- function(value){SetProp("m_minSpeed", value.tofloat())}
		CBaseEntity["GetMinSpeed"] <- function(){return GetProp("m_minSpeed")}

		CBaseEntity["SetMaxSpeed"] <- function(value){SetProp("m_maxSpeed", value.tofloat())}
		CBaseEntity["GetMaxSpeed"] <- function(){return GetProp("m_maxSpeed")}


		CBaseEntity["SetDisabled"] <- function(value){SetProp("m_bDisabled", value.tointeger())}
		CBaseEntity["GetDisabled"] <- function(){return GetProp("m_bDisabled")}


		CBaseEntity["SetClimbableNormal"] <- function(value){SetProp("m_climbableNormal", value)}
		CBaseEntity["GetClimbableNormal"] <- function(){return GetProp("m_climbableNormal")}


		CBaseEntity["SetColor1"] <- function(value){SetProp("m_Color1", value.tointeger())}
		CBaseEntity["GetColor1"] <- function(){return GetProp("m_Color1")}

		CBaseEntity["SetColor2"] <- function(value){SetProp("m_Color2", value.tointeger())}
		CBaseEntity["GetColor2"] <- function(){return GetProp("m_Color2")}

		CBaseEntity["SetMaterialName"] <- function(value){SetProp("m_MaterialName", value.tostring())}
		CBaseEntity["GetMaterialName"] <- function(){return GetProp("m_MaterialName")}

		CBaseEntity["SetParticleDrawWidth"] <- function(value){SetProp("m_ParticleDrawWidth", value.tofloat())}
		CBaseEntity["GetParticleDrawWidth"] <- function(){return GetProp("m_ParticleDrawWidth")}

		CBaseEntity["SetParticleSpacingDistance"] <- function(value){SetProp("m_ParticleSpacingDistance", value.tofloat())}
		CBaseEntity["GetParticleSpacingDistance"] <- function(){return GetProp("m_ParticleSpacingDistance")}

		CBaseEntity["SetDensityRampSpeed"] <- function(value){SetProp("m_DensityRampSpeed", value.tofloat())}
		CBaseEntity["GetDensityRampSpeed"] <- function(){return GetProp("m_DensityRampSpeed")}

		CBaseEntity["SetRotationSpeed"] <- function(value){SetProp("m_RotationSpeed", value.tofloat())}
		CBaseEntity["GetRotationSpeed"] <- function(){return GetProp("m_RotationSpeed")}

		CBaseEntity["SetMovementSpeed"] <- function(value){SetProp("m_MovementSpeed", value.tofloat())}
		CBaseEntity["GetMovementSpeed"] <- function(){return GetProp("m_MovementSpeed")}

		CBaseEntity["SetDensity"] <- function(value){SetProp("m_Density", value.tofloat())}
		CBaseEntity["GetDensity"] <- function(){return GetProp("m_Density")}

		CBaseEntity["SetMaxDrawDistance"] <- function(value){SetProp("m_maxDrawDistance", value.tofloat())}
		CBaseEntity["GetMaxDrawDistance"] <- function(){return GetProp("m_maxDrawDistance")}


		CBaseEntity["SetPlayerMountPositionTop"] <- function(value){SetProp("m_vecPlayerMountPositionTop", value)}
		CBaseEntity["GetPlayerMountPositionTop"] <- function(){return GetProp("m_vecPlayerMountPositionTop")}

		CBaseEntity["SetPlayerMountPositionBottom"] <- function(value){SetProp("m_vecPlayerMountPositionBottom", value)}
		CBaseEntity["GetPlayerMountPositionBottom"] <- function(){return GetProp("m_vecPlayerMountPositionBottom")}

		CBaseEntity["SetLadderDir"] <- function(value){SetProp("m_vecLadderDir", value)}
		CBaseEntity["GetLadderDir"] <- function(){return GetProp("m_vecLadderDir")}

		CBaseEntity["SetFakeLadder"] <- function(value){SetProp("m_bFakeLadder", value.tointeger())}
		CBaseEntity["GetFakeLadder"] <- function(){return GetProp("m_bFakeLadder")}
			
		CBaseEntity["SetDisabled"] <- function(value){SetProp("m_bDisabled", value.tointeger())}
		CBaseEntity["GetDisabled"] <- function(){return GetProp("m_bDisabled")}


		CBaseEntity["SetCurrentMaxRagdollCount"] <- function(value){SetProp("m_iCurrentMaxRagdollCount", value.tointeger())}
		CBaseEntity["GetCurrentMaxRagdollCount"] <- function(){return GetProp("m_iCurrentMaxRagdollCount")}
			
		CBaseEntity["SetMaxRagdollCount"] <- function(value){SetProp("m_iMaxRagdollCount", value.tointeger())}
		CBaseEntity["GetMaxRagdollCount"] <- function(){return GetProp("m_iMaxRagdollCount")}

		CBaseEntity["SetSaveImportant"] <- function(value){SetProp("m_bSaveImportant", value.tointeger())}
		CBaseEntity["GetSaveImportant"] <- function(){return GetProp("m_bSaveImportant")}


		CBaseEntity["SetActive"] <- function(value){SetProp("m_bActive", value.tointeger())}
		CBaseEntity["GetActive"] <- function(){return GetProp("m_bActive")}
			
		CBaseEntity["SetTotalScavengeItems"] <- function(value){SetProp("m_nTotalScavengeItems", value.tointeger())}
		CBaseEntity["GetTotalScavengeItems"] <- function(){return GetProp("m_nTotalScavengeItems")}


		CBaseEntity["SetGibbedLimbForce"] <- function(value){SetProp("m_gibbedLimbForce", value)}
		CBaseEntity["GetGibbedLimbForce"] <- function(){return GetProp("m_gibbedLimbForce")}

		CBaseEntity["SetOriginalBody"] <- function(value){SetProp("m_originalBody", value.tointeger())}
		CBaseEntity["GetOriginalBody"] <- function(){return GetProp("m_originalBody")}
			
		CBaseEntity["SetMobRush"] <- function(value){SetProp("m_mobRush", value.tointeger())}
		CBaseEntity["GetMobRush"] <- function(){return GetProp("m_mobRush")}

		CBaseEntity["SetBurning"] <- function(value){SetProp("m_bIsBurning", value.tointeger())}
		CBaseEntity["GetBurning"] <- function(){return GetProp("m_bIsBurning")}

		CBaseEntity["SetRequestedWound1"] <- function(value){SetProp("m_iRequestedWound1", value.tointeger())}
		CBaseEntity["GetRequestedWound1"] <- function(){return GetProp("m_iRequestedWound1")}

		CBaseEntity["SetRequestedWound2"] <- function(value){SetProp("m_iRequestedWound2", value.tointeger())}
		CBaseEntity["GetRequestedWound2"] <- function(){return GetProp("m_iRequestedWound2")}

		CBaseEntity["SetFallenFlags"] <- function(value){SetProp("m_nFallenFlags", value.tointeger())}
		CBaseEntity["GetFallenFlags"] <- function(){return GetProp("m_nFallenFlags")}


		CBaseEntity["SetFireXDelta"] <- function(value){SetProp("m_fireXDelta", value.tointeger())}
		CBaseEntity["GetFireXDelta"] <- function(value){return GetProp("m_fireXDelta", null, true)}

		CBaseEntity["SetFireYDelta"] <- function(value){SetProp("m_fireYDelta", value.tointeger())}
		CBaseEntity["GetFireYDelta"] <- function(value){return GetProp("m_fireYDelta", null, true)}

		CBaseEntity["SetFireZDelta"] <- function(value){SetProp("m_fireZDelta", value.tointeger())}
		CBaseEntity["GetFireZDelta"] <- function(value){return GetProp("m_fireZDelta", null, true)}

		CBaseEntity["SetFireCount"] <- function(value){SetProp("m_fireCount", value.tointeger())}
		CBaseEntity["GetFireCount"] <- function(){return GetProp("m_fireCount")}


		CBaseEntity["SetTextureFrameIndex"] <- function(value){SetProp("m_iTextureFrameIndex", value.tointeger())}
		CBaseEntity["GetTextureFrameIndex"] <- function(){return GetProp("m_iTextureFrameIndex")}

		CBaseEntity["SetOverlayID"] <- function(value){SetProp("m_iOverlayID", value.tointeger())}
		CBaseEntity["GetOverlayID"] <- function(){return GetProp("m_iOverlayID")}


		CBaseEntity["SetOrder"] <- function(value){SetProp("m_order", value.tointeger())}
		CBaseEntity["GetOrder"] <- function(){return GetProp("m_order")}
			
		CBaseEntity["SetSurvivorName"] <- function(value){SetProp("m_iszSurvivorName", value.tostring())}
		CBaseEntity["GetSurvivorName"] <- function(){return GetProp("m_iszSurvivorName")}

		CBaseEntity["SetSurvivorIntroSequence"] <- function(value){SetProp("m_iszSurvivorIntroSequence", value.tostring())}
		CBaseEntity["GetSurvivorIntroSequence"] <- function(){return GetProp("m_iszSurvivorIntroSequence")}

		CBaseEntity["SetGamemode"] <- function(value){SetProp("m_iszGameMode", value.tostring())}
		CBaseEntity["GetGamemode"] <- function(){return GetProp("m_iszGameMode")}

		CBaseEntity["SetSurvivorConcept"] <- function(value){SetProp("m_iszSurvivorConcept", value.tostring())}
		CBaseEntity["GetSurvivorConcept"] <- function(){return GetProp("m_iszSurvivorConcept")}

		CBaseEntity["SetHideWeapons"] <- function(value){SetProp("m_bHideWeapons", value.tointeger())}
		CBaseEntity["GetHideWeapons"] <- function(){return GetProp("m_bHideWeapons")}


		CBaseEntity["SetSurvivor"] <- function(value){SetProp("m_survivor", value.tointeger())}
		CBaseEntity["GetSurvivor"] <- function(){return GetProp("m_survivor")}
			
		CBaseEntity["SetRescueEyePos"] <- function(value){SetProp("m_rescueEyePos", value)}
		CBaseEntity["GetRescueEyePos"] <- function(){return GetProp("m_rescueEyePos")}


		CBaseEntity["SetLoadingProgress"] <- function(value){SetProp("m_loadingProgress", value.tointeger())}
		CBaseEntity["GetLoadingProgress"] <- function(){return GetProp("m_loadingProgress")}

		CBaseEntity["SetUserID"] <- function(value){SetProp("m_userID", value.tointeger())}
		CBaseEntity["GetUserID"] <- function(){return GetProp("m_userID")}

		CBaseEntity["SetDeaths"] <- function(value){SetProp("m_deaths", value.tointeger())}
		CBaseEntity["GetDeaths"] <- function(){return GetProp("m_deaths")}

		CBaseEntity["SetScore"] <- function(value){SetProp("m_score", value.tointeger())}
		CBaseEntity["GetScore"] <- function(){return GetProp("m_score")}

		CBaseEntity["SetHasMolotov"] <- function(value){SetProp("m_hasMolotov", value.tointeger())}
		CBaseEntity["GetHasMolotov"] <- function(){return GetProp("m_hasMolotov")}

		CBaseEntity["SetHasGrenade"] <- function(value){SetProp("m_hasGrenade", value.tointeger())}
		CBaseEntity["GetHasGrenade"] <- function(){return GetProp("m_hasGrenade")}

		CBaseEntity["SetHasFirstAidKit"] <- function(value){SetProp("m_hasFirstAidKit", value.tointeger())}
		CBaseEntity["GetHasFirstAidKit"] <- function(){return GetProp("m_hasFirstAidKit")}

		CBaseEntity["SetHasPainPills"] <- function(value){SetProp("m_hasPainPills", value.tointeger())}
		CBaseEntity["GetHasPainPills"] <- function(){return GetProp("m_hasPainPills")}

		CBaseEntity["SetPrimaryWeaponID"] <- function(value){SetProp("m_primaryWeaponID", value.tointeger())}
		CBaseEntity["GetPrimaryWeaponID"] <- function(){return GetProp("m_primaryWeaponID")}

		CBaseEntity["SetSecondaryWeaponID"] <- function(value){SetProp("m_secondaryWeaponID", value.tointeger())}
		CBaseEntity["GetSecondaryWeaponID"] <- function(){return GetProp("m_secondaryWeaponID")}


		CBaseEntity["SetSceneStringIndex"] <- function(value){SetProp("m_nSceneStringIndex", value.tointeger())}
		CBaseEntity["GetSceneStringIndex"] <- function(){return GetProp("m_nSceneStringIndex")}

		CBaseEntity["SetPlayingBack"] <- function(value){SetProp("m_bIsPlayingBack", value.tointeger())}
		CBaseEntity["GetPlayingBack"] <- function(){return GetProp("m_bIsPlayingBack")}

		CBaseEntity["SetPaused"] <- function(value){SetProp("m_bPaused", value.tointeger())}
		CBaseEntity["GetPaused"] <- function(){return GetProp("m_bPaused")}

		CBaseEntity["SetMultiplayer"] <- function(value){SetProp("m_bMultiplayer", value.tointeger())}
		CBaseEntity["GetMultiplayer"] <- function(){return GetProp("m_bMultiplayer")}

		CBaseEntity["SetForceClientTime"] <- function(value){SetProp("m_flForceClientTime", value.tofloat())}
		CBaseEntity["GetForceClientTime"] <- function(){return GetProp("m_flForceClientTime")}

		CBaseEntity["SetActorList"] <- function(value){SetPropEntity("m_hActorList", value)}
		CBaseEntity["GetActorList"] <- function(value){return GetPropEntity("m_hActorList", null, true)}
			
		CBaseEntity["SetOwner"] <- function(value){SetPropEntity("m_hOwner", value)}
		CBaseEntity["GetOwner"] <- function(value){return GetPropEntity("m_hOwner")}

		CBaseEntity["SetHadOwner"] <- function(value){SetProp("m_bHadOwner", value.tointeger())}
		CBaseEntity["GetHadOwner"] <- function(){return GetProp("m_bHadOwner")}

		CBaseEntity["SetPostSpeakDelay"] <- function(value){SetProp("m_flPostSpeakDelay", value.tofloat())}
		CBaseEntity["GetPostSpeakDelay"] <- function(){return GetProp("m_flPostSpeakDelay")}

		CBaseEntity["SetPreDelay"] <- function(value){SetProp("m_flPreDelay", value.tofloat())}
		CBaseEntity["GetPreDelay"] <- function(){return GetProp("m_flPreDelay")}

		CBaseEntity["SetInstanceFilename"] <- function(value){SetProp("m_szInstanceFilename", value.tostring())}
		CBaseEntity["GetInstanceFilename"] <- function(){return GetProp("m_szInstanceFilename")}

		CBaseEntity["SetIsBackground"] <- function(value){SetProp("m_bIsBackground", value.tointeger())}
		CBaseEntity["GetIsBackground"] <- function(){return GetProp("m_bIsBackground")}

		CBaseEntity["SetSceneFile"] <- function(value){SetProp("m_iszSceneFile", value.tostring())}
		CBaseEntity["GetSceneFile"] <- function(){return GetProp("m_iszSceneFile")}

		CBaseEntity["SetResumeSceneFile"] <- function(value){SetProp("m_iszResumeSceneFile", value.tostring())}
		CBaseEntity["GetResumeSceneFile"] <- function(){return GetProp("m_iszResumeSceneFile")}

		CBaseEntity["SetWaitingForThisResumeScene"] <- function(value){SetPropEntity("m_hWaitingForThisResumeScene", value)}
		CBaseEntity["GetWaitingForThisResumeScene"] <- function(value){return GetPropEntity("m_hWaitingForThisResumeScene")}

		CBaseEntity["SetWaitingForResumeScene"] <- function(value){SetProp("m_bWaitingForResumeScene", value.tointeger())}
		CBaseEntity["GetWaitingForResumeScene"] <- function(){return GetProp("m_bWaitingForResumeScene")}

		CBaseEntity["SetBusyActor"] <- function(value){SetPropEntity("m_BusyActor", value)}
		CBaseEntity["GetBusyActor"] <- function(value){return GetPropEntity("m_BusyActor")}

		CBaseEntity["SetCurrentTime"] <- function(value){SetProp("m_flCurrentTime", value.tofloat())}
		CBaseEntity["GetCurrentTime"] <- function(){return GetProp("m_flCurrentTime")}

		CBaseEntity["SetFrameTime"] <- function(value){SetProp("m_flFrameTime", value.tofloat())}
		CBaseEntity["GetFrameTime"] <- function(){return GetProp("m_flFrameTime")}

		CBaseEntity["SetCancelAtNextInterrupt"] <- function(value){SetProp("m_bCancelAtNextInterrupt", value.tointeger())}
		CBaseEntity["GetCancelAtNextInterrupt"] <- function(){return GetProp("m_bCancelAtNextInterrupt")}

		CBaseEntity["SetPitch"] <- function(value){SetProp("m_fPitch", value.tofloat())}
		CBaseEntity["GetPitch"] <- function(){return GetProp("m_fPitch")}

		CBaseEntity["SetAutomated"] <- function(value){SetProp("m_bAutomated", value.tointeger())}
		CBaseEntity["GetAutomated"] <- function(){return GetProp("m_bAutomated")}

		CBaseEntity["SetAutomatedAction"] <- function(value){SetProp("m_nAutomatedAction", value.tointeger())}
		CBaseEntity["GetAutomatedAction"] <- function(){return GetProp("m_nAutomatedAction")}

		CBaseEntity["SetAutomationDelay"] <- function(value){SetProp("m_flAutomationDelay", value.tofloat())}
		CBaseEntity["GetAutomationDelay"] <- function(){return GetProp("m_flAutomationDelay")}

		CBaseEntity["SetAutomationTime"] <- function(value){SetProp("m_flAutomationTime", value.tofloat())}
		CBaseEntity["GetAutomationTime"] <- function(){return GetProp("m_flAutomationTime")}

		CBaseEntity["SetPausedViaInput"] <- function(value){SetProp("m_bPausedViaInput", value.tointeger())}
		CBaseEntity["GetPausedViaInput"] <- function(){return GetProp("m_bPausedViaInput")}

		CBaseEntity["SetWaitingForActor"] <- function(value){SetProp("m_bWaitingForActor", value.tointeger())}
		CBaseEntity["GetWaitingForActor"] <- function(){return GetProp("m_bWaitingForActor")}

		CBaseEntity["SetWaitingForInterrupt"] <- function(value){SetProp("m_bWaitingForInterrupt", value.tointeger())}
		CBaseEntity["GetWaitingForInterrupt"] <- function(){return GetProp("m_bWaitingForInterrupt")}

		CBaseEntity["SetInterruptedActorsScenes"] <- function(value){SetProp("m_bInterruptedActorsScenes", value.tointeger())}
		CBaseEntity["GetInterruptedActorsScenes"] <- function(){return GetProp("m_bInterruptedActorsScenes")}

		CBaseEntity["SetBreakOnNonIdle"] <- function(value){SetProp("m_bBreakOnNonIdle", value.tointeger())}
		CBaseEntity["GetBreakOnNonIdle"] <- function(){return GetProp("m_bBreakOnNonIdle")}

		CBaseEntity["SetInterruptCount"] <- function(value){SetProp("m_nInterruptCount", value.tointeger())}
		CBaseEntity["GetInterruptCount"] <- function(){return GetProp("m_nInterruptCount")}

		CBaseEntity["SetInterrupted"] <- function(value){SetProp("m_bInterrupted", value.tointeger())}
		CBaseEntity["GetInterrupted"] <- function(){return GetProp("m_bInterrupted")}

		CBaseEntity["SetInterruptScene"] <- function(value){SetPropEntity("m_hInterruptScene", value)}
		CBaseEntity["GetInterruptScene"] <- function(value){return GetPropEntity("m_hInterruptScene")}

		CBaseEntity["SetCompletedEarly"] <- function(value){SetProp("m_bCompletedEarly", value.tointeger())}
		CBaseEntity["GetCompletedEarly"] <- function(){return GetProp("m_bCompletedEarly")}

		CBaseEntity["SetInterruptSceneFinished"] <- function(value){SetProp("m_bInterruptSceneFinished", value.tointeger())}
		CBaseEntity["GetInterruptSceneFinished"] <- function(){return GetProp("m_bInterruptSceneFinished")}

		CBaseEntity["SetGenerated"] <- function(value){SetProp("m_bGenerated", value.tointeger())}
		CBaseEntity["GetGenerated"] <- function(){return GetProp("m_bGenerated")}

		CBaseEntity["SetSoundName"] <- function(value){SetProp("m_iszSoundName", value.tostring())}
		CBaseEntity["GetSoundName"] <- function(){return GetProp("m_iszSoundName")}

		CBaseEntity["SetActor"] <- function(value){SetPropEntity("m_hActor", value)}
		CBaseEntity["GetActor"] <- function(value){return GetPropEntity("m_hActor")}


		CBaseEntity["SetStartPoint"] <- function(value){SetPropEntity("m_hStartPoint", value)}
		CBaseEntity["GetStartPoint"] <- function(value){return GetPropEntity("m_hStartPoint")}

		CBaseEntity["SetEndPoint"] <- function(value){SetPropEntity("m_hEndPoint", value)}
		CBaseEntity["GetEndPoint"] <- function(value){return GetPropEntity("m_hEndPoint")}

		CBaseEntity["SetStartAttachment"] <- function(value){SetProp("m_iStartAttachment", value.tointeger())}
		CBaseEntity["GetStartAttachment"] <- function(){return GetProp("m_iStartAttachment")}

		CBaseEntity["SetEndAttachment"] <- function(value){SetProp("m_iEndAttachment", value.tointeger())}
		CBaseEntity["GetEndAttachment"] <- function(){return GetProp("m_iEndAttachment")}

		CBaseEntity["SetSlack"] <- function(value){SetProp("m_Slack", value.tointeger())}
		CBaseEntity["GetSlack"] <- function(){return GetProp("m_Slack")}

		CBaseEntity["SetRopeLength"] <- function(value){SetProp("m_RopeLength", value.tointeger())}
		CBaseEntity["GetRopeLength"] <- function(){return GetProp("m_RopeLength")}

		CBaseEntity["SetLockedPoints"] <- function(value){SetProp("m_fLockedPoints", value.tointeger())}
		CBaseEntity["GetLockedPoints"] <- function(){return GetProp("m_fLockedPoints")}

		CBaseEntity["SetChangeCount"] <- function(value){SetProp("m_nChangeCount", value.tointeger())}
		CBaseEntity["GetChangeCount"] <- function(){return GetProp("m_nChangeCount")}
			
		CBaseEntity["SetRopeFlags"] <- function(value){SetProp("m_RopeFlags", value.tointeger())}
		CBaseEntity["GetRopeFlags"] <- function(){return GetProp("m_RopeFlags")}

		CBaseEntity["SetSegments"] <- function(value){SetProp("m_nSegments", value.tointeger())}
		CBaseEntity["GetSegments"] <- function(){return GetProp("m_nSegments")}

		CBaseEntity["SetConstrainBetweenEndpoints"] <- function(value){SetProp("m_bConstrainBetweenEndpoints", value.tointeger())}
		CBaseEntity["GetConstrainBetweenEndpoints"] <- function(){return GetProp("m_bConstrainBetweenEndpoints")}

		CBaseEntity["SetRopeMaterialModelIndex"] <- function(value){SetProp("m_iRopeMaterialModelIndex", value.tointeger())}
		CBaseEntity["GetRopeMaterialModelIndex"] <- function(){return GetProp("m_iRopeMaterialModelIndex")}

		CBaseEntity["SetSubdiv"] <- function(value){SetProp("m_Subdiv", value.tointeger())}
		CBaseEntity["GetSubdiv"] <- function(){return GetProp("m_Subdiv")}

		CBaseEntity["SetTextureScale"] <- function(value){SetProp("m_TextureScale", value.tofloat())}
		CBaseEntity["GetTextureScale"] <- function(){return GetProp("m_TextureScale")}

		CBaseEntity["SetWidth"] <- function(value){SetProp("m_Width", value.tofloat())}
		CBaseEntity["GetWidth"] <- function(){return GetProp("m_Width")}

		CBaseEntity["SetScrollSpeed"] <- function(value){SetProp("m_flScrollSpeed", value.tofloat())}
		CBaseEntity["GetScrollSpeed"] <- function(){return GetProp("m_flScrollSpeed")}
			
		CBaseEntity["SetNextLinkName"] <- function(value){SetProp("m_iNextLinkName", value.tostring())}
		CBaseEntity["GetNextLinkName"] <- function(){return GetProp("m_iNextLinkName")}

		CBaseEntity["SetRopeMaterialModel"] <- function(value){SetProp("m_strRopeMaterialModel", value.tostring())}
		CBaseEntity["GetRopeMaterialModel"] <- function(){return GetProp("m_strRopeMaterialModel")}

		CBaseEntity["SetCreatedFromMapFile"] <- function(value){SetProp("m_bCreatedFromMapFile", value.tointeger())}
		CBaseEntity["GetCreatedFromMapFile"] <- function(){return GetProp("m_bCreatedFromMapFile")}

		CBaseEntity["SetStartPointValid"] <- function(value){SetProp("m_bStartPointValid", value.tointeger())}
		CBaseEntity["GetStartPointValid"] <- function(){return GetProp("m_bStartPointValid")}

		CBaseEntity["SetEndPointValid"] <- function(value){SetProp("m_bEndPointValid", value.tointeger())}
		CBaseEntity["GetEndPointValid"] <- function(){return GetProp("m_bEndPointValid")}


		CBaseEntity["SetFlags"] <- function(value){SetProp("m_Flags", value.tointeger())}
		CBaseEntity["GetFlags"] <- function(){return GetProp("m_Flags")}

		CBaseEntity["SetLightStyle"] <- function(value){SetProp("m_LightStyle", value.tointeger())}
		CBaseEntity["GetLightStyle"] <- function(){return GetProp("m_LightStyle")}

		CBaseEntity["SetRadius"] <- function(value){SetProp("m_Radius", value.tofloat())}
		CBaseEntity["GetRadius"] <- function(){return GetProp("m_Radius")}

		CBaseEntity["SetExponent"] <- function(value){SetProp("m_Exponent", value.tointeger())}
		CBaseEntity["GetExponent"] <- function(){return GetProp("m_Exponent")}

		CBaseEntity["SetInnerAngle"] <- function(value){SetProp("m_InnerAngle", value.tofloat())}
		CBaseEntity["GetInnerAngle"] <- function(){return GetProp("m_InnerAngle")}

		CBaseEntity["SetOuterAngle"] <- function(value){SetProp("m_OuterAngle", value.tofloat())}
		CBaseEntity["GetOuterAngle"] <- function(){return GetProp("m_OuterAngle")}

		CBaseEntity["SetSpotRadius"] <- function(value){SetProp("m_SpotRadius", value.tofloat())}
		CBaseEntity["GetSpotRadius"] <- function(){return GetProp("m_SpotRadius")}
			
		CBaseEntity["SetActualFlags"] <- function(value){SetProp("m_ActualFlags", value.tointeger())}
		CBaseEntity["GetActualFlags"] <- function(){return GetProp("m_ActualFlags")}

		CBaseEntity["SetOn"] <- function(value){SetProp("m_On", value.tointeger())}
		CBaseEntity["GetOn"] <- function(){return GetProp("m_On")}


		CBaseEntity["SetMaterialName"] <- function(value){SetProp("m_szMaterialName", value.tostring())}
		CBaseEntity["GetMaterialName"] <- function(){return GetProp("m_szMaterialName")}

		CBaseEntity["SetMaterialVar"] <- function(value){SetProp("m_szMaterialVar", value.tostring())}
		CBaseEntity["GetMaterialVar"] <- function(){return GetProp("m_szMaterialVar")}

		CBaseEntity["SetMaterialVarValue"] <- function(value){SetProp("m_szMaterialVarValue", value.tostring())}
		CBaseEntity["GetMaterialVarValue"] <- function(){return GetProp("m_szMaterialVarValue")}

		CBaseEntity["SetFrameStart"] <- function(value){SetProp("m_iFrameStart", value.tointeger())}
		CBaseEntity["GetFrameStart"] <- function(){return GetProp("m_iFrameStart")}

		CBaseEntity["SetFrameEnd"] <- function(value){SetProp("m_iFrameEnd", value.tointeger())}
		CBaseEntity["GetFrameEnd"] <- function(){return GetProp("m_iFrameEnd")}

		CBaseEntity["SetWrap"] <- function(value){SetProp("m_bWrap", value.tointeger())}
		CBaseEntity["GetWrap"] <- function(){return GetProp("m_bWrap")}

		CBaseEntity["SetFramerate"] <- function(value){SetProp("m_flFramerate", value.tofloat())}
		CBaseEntity["GetFramerate"] <- function(){return GetProp("m_flFramerate")}

		CBaseEntity["SetNewAnimCommandsSemaphore"] <- function(value){SetProp("m_bNewAnimCommandsSemaphore", value.tointeger())}
		CBaseEntity["GetNewAnimCommandsSemaphore"] <- function(){return GetProp("m_bNewAnimCommandsSemaphore")}

		CBaseEntity["SetFloatLerpStartValue"] <- function(value){SetProp("m_flFloatLerpStartValue", value.tofloat())}
		CBaseEntity["GetFloatLerpStartValue"] <- function(){return GetProp("m_flFloatLerpStartValue")}

		CBaseEntity["SetFloatLerpEndValue"] <- function(value){SetProp("m_flFloatLerpEndValue", value.tofloat())}
		CBaseEntity["GetFloatLerpEndValue"] <- function(){return GetProp("m_flFloatLerpEndValue")}

		CBaseEntity["SetFloatLerpTransitionTime"] <- function(value){SetProp("m_flFloatLerpTransitionTime", value.tofloat())}
		CBaseEntity["GetFloatLerpTransitionTime"] <- function(){return GetProp("m_flFloatLerpTransitionTime")}

		CBaseEntity["SetModifyMode"] <- function(value){SetProp("m_nModifyMode", value.tointeger())}
		CBaseEntity["GetModifyMode"] <- function(){return GetProp("m_nModifyMode")}


		CBaseEntity["SetModelIndex"] <- function(value){SetProp("m_modelIndex", value.tointeger())}
		CBaseEntity["GetModelIndex"] <- function(){return GetProp("m_modelIndex")}

		CBaseEntity["SetSolidIndex"] <- function(value){SetProp("m_solidIndex", value.tointeger())}
		CBaseEntity["GetSolidIndex"] <- function(){return GetProp("m_solidIndex")}
			
		CBaseEntity["SetPhysicsBone"] <- function(value){SetProp("m_physicsBone", value.tostring())}
		CBaseEntity["GetPhysicsBone"] <- function(){return GetProp("m_physicsBone")}

		CBaseEntity["SetHitGroup"] <- function(value){SetProp("m_hitGroup", value.tointeger())}
		CBaseEntity["GetHitGroup"] <- function(){return GetProp("m_hitGroup")}


		CBaseEntity["SetAwake"] <- function(value){SetProp("m_bAwake", value.tointeger())}
		CBaseEntity["GetAwake"] <- function(){return GetProp("m_bAwake")}

		CBaseEntity["SetHasTankGlow"] <- function(value){SetProp("m_hasTankGlow", value.tointeger())}
		CBaseEntity["GetHasTankGlow"] <- function(){return GetProp("m_hasTankGlow")}

		CBaseEntity["SetCarryable"] <- function(value){SetProp("m_isCarryable", value.tointeger())}
		CBaseEntity["GetCarryable"] <- function(){return GetProp("m_isCarryable")}


		CBaseEntity["SetRagAngles"] <- function(value){SetProp("m_ragAngles", value)}
		CBaseEntity["GetRagAngles"] <- function(value){return GetProp("m_ragAngles", null, true)}

		CBaseEntity["SetRagPos"] <- function(value){SetProp("m_ragPos", value)}
		CBaseEntity["GetRagPos"] <- function(value){return GetProp("m_ragPos", null, true)}

		CBaseEntity["SetUnragdoll"] <- function(value){SetPropEntity("m_hUnragdoll", value)}
		CBaseEntity["GetUnragdoll"] <- function(value){return GetPropEntity("m_hUnragdoll")}

		CBaseEntity["SetBlendWeight"] <- function(value){SetProp("m_flBlendWeight", value.tofloat())}
		CBaseEntity["GetBlendWeight"] <- function(){return GetProp("m_flBlendWeight")}

		CBaseEntity["SetOverlaySequence"] <- function(value){SetProp("m_nOverlaySequence", value.tointeger())}
		CBaseEntity["GetOverlaySequence"] <- function(){return GetProp("m_nOverlaySequence")}
			
		CBaseEntity["SetLastUpdateTickCount"] <- function(value){SetProp("m_lastUpdateTickCount", value.tointeger())}
		CBaseEntity["GetLastUpdateTickCount"] <- function(){return GetProp("m_lastUpdateTickCount")}

		CBaseEntity["SetAllAsleep"] <- function(value){SetProp("m_allAsleep", value.tointeger())}
		CBaseEntity["GetAllAsleep"] <- function(){return GetProp("m_allAsleep")}

		CBaseEntity["SetDamageEntity"] <- function(value){SetPropEntity("m_hDamageEntity", value)}
		CBaseEntity["GetDamageEntity"] <- function(value){return GetPropEntity("m_hDamageEntity")}

		CBaseEntity["SetKiller"] <- function(value){SetPropEntity("m_hKiller", value)}
		CBaseEntity["GetKiller"] <- function(value){return GetPropEntity("m_hKiller")}

		CBaseEntity["SetStartDisabled"] <- function(value){SetProp("m_bStartDisabled", value.tointeger())}
		CBaseEntity["GetStartDisabled"] <- function(){return GetProp("m_bStartDisabled")}


		CBaseEntity["SetPing"] <- function(ent, value){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return false
				}
				
				SetProp("m_iPing", value.tointeger(), ent.GetEntityIndex())
			}
		CBaseEntity["GetPing"] <- function(ent){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return
				}
				
				return GetProp("m_iPing", ent.GetEntityIndex())
			}

		CBaseEntity["SetScore"] <- function(ent, value){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return false
				}
				
				SetProp("m_iScore", value.tointeger(), ent.GetEntityIndex())
			}
		CBaseEntity["GetScore"] <- function(ent){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return
				}
				
				return GetProp("m_iScore", ent.GetEntityIndex())
			}

		CBaseEntity["SetTankTickets"] <- function(ent, value){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return false
				}
				
				SetProp("m_iTankTickets", value.tointeger(), ent.GetEntityIndex())
			}
		CBaseEntity["GetTankTickets"] <- function(ent){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return
				}
				
				return GetProp("m_iTankTickets", ent.GetEntityIndex())
			}

		CBaseEntity["SetDeaths"] <- function(ent, value){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return false
				}
				
				SetProp("m_iDeaths", value.tointeger(), ent.GetEntityIndex())
			}
		CBaseEntity["GetDeaths"] <- function(ent){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return
				}
				
				return GetProp("m_iDeaths", ent.GetEntityIndex())
			}

		CBaseEntity["SetConnected"] <- function(ent, value){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return false
				}
				
				SetProp("m_bConnected", value.tointeger(), ent.GetEntityIndex())
			}
		CBaseEntity["GetConnected"] <- function(ent){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return
				}
				
				return GetProp("m_bConnected", ent.GetEntityIndex())
			}


		CBaseEntity["SetActive"] <- function(value){SetProp("m_bActive", value.tointeger())}
		CBaseEntity["GetActive"] <- function(){return GetProp("m_bActive")}

		CBaseEntity["SetCommentaryFile"] <- function(value){SetProp("m_iszCommentaryFile", value.tostring())}
		CBaseEntity["GetCommentaryFile"] <- function(){return GetProp("m_iszCommentaryFile")}

		CBaseEntity["SetCommentaryFileNoHDR"] <- function(value){SetProp("m_iszCommentaryFileNoHDR", value.tostring())}
		CBaseEntity["GetCommentaryFileNoHDR"] <- function(){return GetProp("m_iszCommentaryFileNoHDR")}

		CBaseEntity["SetStartTime"] <- function(value){SetProp("m_flStartTime", value.tofloat())}
		CBaseEntity["GetStartTime"] <- function(){return GetProp("m_flStartTime")}

		CBaseEntity["SetSpeakers"] <- function(value){SetProp("m_iszSpeakers", value.tostring())}
		CBaseEntity["GetSpeakers"] <- function(){return GetProp("m_iszSpeakers")}

		CBaseEntity["SetNodeNumber"] <- function(value){SetProp("m_iNodeNumber", value.tointeger())}
		CBaseEntity["GetNodeNumber"] <- function(){return GetProp("m_iNodeNumber")}

		CBaseEntity["SetNodeNumberMax"] <- function(value){SetProp("m_iNodeNumberMax", value.tointeger())}
		CBaseEntity["GetNodeNumberMax"] <- function(){return GetProp("m_iNodeNumberMax")}

		CBaseEntity["SetViewPosition"] <- function(value){SetPropEntity("m_hViewPosition", value)}
		CBaseEntity["GetViewPosition"] <- function(value){return GetPropEntity("m_hViewPosition")}
			
		CBaseEntity["SetPreCommands"] <- function(value){SetProp("m_iszPreCommands", value.tostring())}
		CBaseEntity["GetPreCommands"] <- function(){return GetProp("m_iszPreCommands")}

		CBaseEntity["SetPostCommands"] <- function(value){SetProp("m_iszPostCommands", value.tostring())}
		CBaseEntity["GetPostCommands"] <- function(){return GetProp("m_iszPostCommands")}

		CBaseEntity["SetViewTarget"] <- function(value){SetPropEntity("m_hViewTarget", value)}
		CBaseEntity["GetViewTarget"] <- function(value){return GetPropEntity("m_hViewTarget")}

		CBaseEntity["SetViewTargetAngles"] <- function(value){SetPropEntity("m_hViewTargetAngles", value)}
		CBaseEntity["GetViewTargetAngles"] <- function(value){return GetPropEntity("m_hViewTargetAngles")}

		CBaseEntity["SetViewPositionMover"] <- function(value){SetPropEntity("m_hViewPositionMover", value)}
		CBaseEntity["GetViewPositionMover"] <- function(value){return GetPropEntity("m_hViewPositionMover")}

		CBaseEntity["SetPreventMovement"] <- function(value){SetProp("m_bPreventMovement", value.tointeger())}
		CBaseEntity["GetPreventMovement"] <- function(){return GetProp("m_bPreventMovement")}

		CBaseEntity["SetUnderCrosshair"] <- function(value){SetProp("m_bUnderCrosshair", value.tointeger())}
		CBaseEntity["GetUnderCrosshair"] <- function(){return GetProp("m_bUnderCrosshair")}

		CBaseEntity["SetUnstoppable"] <- function(value){SetProp("m_bUnstoppable", value.tointeger())}
		CBaseEntity["GetUnstoppable"] <- function(){return GetProp("m_bUnstoppable")}

		CBaseEntity["SetFinishedTime"] <- function(value){SetProp("m_flFinishedTime", value.tofloat())}
		CBaseEntity["GetFinishedTime"] <- function(){return GetProp("m_flFinishedTime")}

		CBaseEntity["SetFinishOrigin"] <- function(value){SetProp("m_vecFinishOrigin", value)}
		CBaseEntity["GetFinishOrigin"] <- function(){return GetProp("m_vecFinishOrigin")}

		CBaseEntity["SetOriginalAngles"] <- function(value){SetProp("m_vecOriginalAngles", value)}
		CBaseEntity["GetOriginalAngles"] <- function(){return GetProp("m_vecOriginalAngles")}

		CBaseEntity["SetFinishAngles"] <- function(value){SetProp("m_vecFinishAngles", value)}
		CBaseEntity["GetFinishAngles"] <- function(){return GetProp("m_vecFinishAngles")}

		CBaseEntity["SetPreventChangesWhileMoving"] <- function(value){SetProp("m_bPreventChangesWhileMoving", value.tointeger())}
		CBaseEntity["GetPreventChangesWhileMoving"] <- function(){return GetProp("m_bPreventChangesWhileMoving")}

		CBaseEntity["SetDisabled"] <- function(value){SetProp("m_bDisabled", value.tointeger())}
		CBaseEntity["GetDisabled"] <- function(){return GetProp("m_bDisabled")}

		CBaseEntity["SetTeleportOrigin"] <- function(value){SetProp("m_vecTeleportOrigin", value)}
		CBaseEntity["GetTeleportOrigin"] <- function(){return GetProp("m_vecTeleportOrigin")}


		CBaseEntity["SetUseActionOwner"] <- function(value){SetPropEntity("m_useActionOwner", value)}
		CBaseEntity["GetUseActionOwner"] <- function(value){return GetPropEntity("m_useActionOwner")}

		CBaseEntity["SetGasNozzle"] <- function(value){SetPropEntity("m_hGasNozzle", value)}
		CBaseEntity["GetGasNozzle"] <- function(value){return GetPropEntity("m_hGasNozzle")}
			
		CBaseEntity["SetGasNozzleName"] <- function(value){SetProp("m_sGasNozzleName", value.tostring())}
		CBaseEntity["GetGasNozzleName"] <- function(){return GetProp("m_sGasNozzleName")}


		CBaseEntity["SetUseString"] <- function(value){SetProp("m_sUseString", value.tostring())}
		CBaseEntity["GetUseString"] <- function(){return GetProp("m_sUseString")}

		CBaseEntity["SetUseSubstring"] <- function(value){SetProp("m_sUseSubString", value.tostring())}
		CBaseEntity["GetUseSubstring"] <- function(){return GetProp("m_sUseSubString")}

		CBaseEntity["SetPreviousProgressPercent"] <- function(value){SetProp("m_flPreviousProgressPercent", value.tofloat())}
		CBaseEntity["GetPreviousProgressPercent"] <- function(){return GetProp("m_flPreviousProgressPercent")}

		CBaseEntity["SetCanShowBuildPanel"] <- function(value){SetProp("m_bCanShowBuildPanel", value.tointeger())}
		CBaseEntity["GetCanShowBuildPanel"] <- function(){return GetProp("m_bCanShowBuildPanel")}
			
		CBaseEntity["SetUseModelName"] <- function(value){SetProp("m_sUseModelName", value.tostring())}
		CBaseEntity["GetUseModelName"] <- function(){return GetProp("m_sUseModelName")}

		CBaseEntity["SetDuration"] <- function(value){SetProp("m_flDuration", value.tofloat())}
		CBaseEntity["GetDuration"] <- function(){return GetProp("m_flDuration")}


		CBaseEntity["SetLocalContrastStrength"] <- function(value){SetProp("m_fLocalContrastStrength", value.tofloat())}
		CBaseEntity["GetLocalContrastStrength"] <- function(){return GetProp("m_fLocalContrastStrength")}

		CBaseEntity["SetLocalContrastEdgeStrength"] <- function(value){SetProp("m_fLocalContrastEdgeStrength", value.tofloat())}
		CBaseEntity["GetLocalContrastEdgeStrength"] <- function(){return GetProp("m_fLocalContrastEdgeStrength")}

		CBaseEntity["SetVignetteStart"] <- function(value){SetProp("m_fVignetteStart", value.tofloat())}
		CBaseEntity["GetVignetteStart"] <- function(){return GetProp("m_fVignetteStart")}

		CBaseEntity["SetVignetteEnd"] <- function(value){SetProp("m_fVignetteEnd", value.tofloat())}
		CBaseEntity["GetVignetteEnd"] <- function(){return GetProp("m_fVignetteEnd")}

		CBaseEntity["SetVignetteBlurStrength"] <- function(value){SetProp("m_fVignetteBlurStrength", value.tofloat())}
		CBaseEntity["GetVignetteBlurStrength"] <- function(){return GetProp("m_fVignetteBlurStrength")}

		CBaseEntity["SetFadeToBlackStrength"] <- function(value){SetProp("m_fFadeToBlackStrength", value.tofloat())}
		CBaseEntity["GetFadeToBlackStrength"] <- function(){return GetProp("m_fFadeToBlackStrength")}

		CBaseEntity["SetGrainStrength"] <- function(value){SetProp("m_fGrainStrength", value.tofloat())}
		CBaseEntity["GetGrainStrength"] <- function(){return GetProp("m_fGrainStrength")}

		CBaseEntity["SetTopVignetteStrength"] <- function(value){SetProp("m_fTopVignetteStrength", value.tofloat())}
		CBaseEntity["GetTopVignetteStrength"] <- function(){return GetProp("m_fTopVignetteStrength")}

		CBaseEntity["SetFadeTime"] <- function(value){SetProp("m_fFadeTime", value.tofloat())}
		CBaseEntity["GetFadeTime"] <- function(){return GetProp("m_fFadeTime")}

		CBaseEntity["SetMaster"] <- function(value){SetProp("m_bMaster", value.tointeger())}
		CBaseEntity["GetMaster"] <- function(){return GetProp("m_bMaster")}


		CBaseEntity["SetUsed"] <- function(value){SetProp("m_isUsed", value.tointeger())}
		CBaseEntity["GetUsed"] <- function(){return GetProp("m_isUsed")}
			
		CBaseEntity["SetPillCount"] <- function(value){SetProp("m_pillCount", value.tointeger())}
		CBaseEntity["GetPillCount"] <- function(){return GetProp("m_pillCount")}


		CBaseEntity["SetInitialAngles"] <- function(value){SetProp("m_initialAngles", value)}
		CBaseEntity["GetInitialAngles"] <- function(){return GetProp("m_initialAngles")}

		CBaseEntity["SetOwner"] <- function(value){SetPropEntity("m_owner", value)}
		CBaseEntity["GetOwner"] <- function(value){return GetPropEntity("m_owner")}

		CBaseEntity["SetMaxYaw"] <- function(value){SetProp("m_maxYaw", value.tofloat())}
		CBaseEntity["GetMaxYaw"] <- function(){return GetProp("m_maxYaw")}

		CBaseEntity["SetMaxPitch"] <- function(value){SetProp("m_maxPitch", value.tofloat())}
		CBaseEntity["GetMaxPitch"] <- function(){return GetProp("m_maxPitch")}

		CBaseEntity["SetMinPitch"] <- function(value){SetProp("m_minPitch", value.tofloat())}
		CBaseEntity["GetMinPitch"] <- function(){return GetProp("m_minPitch")}

		CBaseEntity["SetFiring"] <- function(value){SetProp("m_firing", value.tointeger())}
		CBaseEntity["GetFiring"] <- function(){return GetProp("m_firing")}

		CBaseEntity["SetOverheated"] <- function(value){SetProp("m_overheated", value.tointeger())}
		CBaseEntity["GetOverheated"] <- function(){return GetProp("m_overheated")}

		CBaseEntity["SetHeat"] <- function(value){SetProp("m_heat", value.tofloat())}
		CBaseEntity["GetHeat"] <- function(){return GetProp("m_heat")}


		CBaseEntity["SetBoneIndexAttached"] <- function(value){SetProp("m_boneIndexAttached", value.tointeger())}
		CBaseEntity["GetBoneIndexAttached"] <- function(){return GetProp("m_boneIndexAttached")}

		CBaseEntity["SetRagdollAttachedObjectIndex"] <- function(value){SetProp("m_ragdollAttachedObjectIndex", value.tointeger())}
		CBaseEntity["GetRagdollAttachedObjectIndex"] <- function(){return GetProp("m_ragdollAttachedObjectIndex")}

		CBaseEntity["SetAttachmentPointBoneSpace"] <- function(value){SetProp("m_attachmentPointBoneSpace", value)}
		CBaseEntity["GetAttachmentPointBoneSpace"] <- function(){return GetProp("m_attachmentPointBoneSpace")}

		CBaseEntity["SetAttachmentPointRagdollSpace"] <- function(value){SetProp("m_attachmentPointRagdollSpace", value)}
		CBaseEntity["GetAttachmentPointRagdollSpace"] <- function(){return GetProp("m_attachmentPointRagdollSpace")}
			
		CBaseEntity["SetShouldDetach"] <- function(value){SetProp("m_bShouldDetach", value.tointeger())}
		CBaseEntity["GetShouldDetach"] <- function(){return GetProp("m_bShouldDetach")}

		CBaseEntity["SetAttachConstraint"] <- function(value){SetPropEntity("m_pAttachConstraint", value)}
		CBaseEntity["GetAttachConstraint"] <- function(value){return GetPropEntity("m_pAttachConstraint")}


		CBaseEntity["SetPlayer"] <- function(value){SetPropEntity("m_hPlayer", value)}
		CBaseEntity["GetPlayer"] <- function(value){return GetPropEntity("m_hPlayer")}

		CBaseEntity["SetSpeed"] <- function(value){SetProp("m_nSpeed", value.tointeger())}
		CBaseEntity["GetSpeed"] <- function(){return GetProp("m_nSpeed")}

		CBaseEntity["SetRPM"] <- function(value){SetProp("m_nRPM", value.tointeger())}
		CBaseEntity["GetRPM"] <- function(){return GetProp("m_nRPM")}

		CBaseEntity["SetThrottle"] <- function(value){SetProp("m_flThrottle", value.tofloat())}
		CBaseEntity["GetThrottle"] <- function(){return GetProp("m_flThrottle")}

		CBaseEntity["SetBoostTimeLeft"] <- function(value){SetProp("m_nBoostTimeLeft", value.tointeger())}
		CBaseEntity["GetBoostTimeLeft"] <- function(){return GetProp("m_nBoostTimeLeft")}

		CBaseEntity["SetHasBoost"] <- function(value){SetProp("m_nHasBoost", value.tointeger())}
		CBaseEntity["GetHasBoost"] <- function(){return GetProp("m_nHasBoost")}

		CBaseEntity["SetScannerDisabledWeapons"] <- function(value){SetProp("m_nScannerDisabledWeapons", value.tointeger())}
		CBaseEntity["GetScannerDisabledWeapons"] <- function(){return GetProp("m_nScannerDisabledWeapons")}

		CBaseEntity["SetScannerDisabledVehicle"] <- function(value){SetProp("m_nScannerDisabledVehicle", value.tointeger())}
		CBaseEntity["GetScannerDisabledVehicle"] <- function(){return GetProp("m_nScannerDisabledVehicle")}

		CBaseEntity["SetEnterAnimOn"] <- function(value){SetProp("m_bEnterAnimOn", value.tointeger())}
		CBaseEntity["GetEnterAnimOn"] <- function(){return GetProp("m_bEnterAnimOn")}

		CBaseEntity["SetExitAnimOn"] <- function(value){SetProp("m_bExitAnimOn", value.tointeger())}
		CBaseEntity["GetExitAnimOn"] <- function(){return GetProp("m_bExitAnimOn")}

		CBaseEntity["SetUnableToFire"] <- function(value){SetProp("m_bUnableToFire", value.tointeger())}
		CBaseEntity["GetUnableToFire"] <- function(){return GetProp("m_bUnableToFire")}

		CBaseEntity["SetEyeExitEndpoint"] <- function(value){SetProp("m_vecEyeExitEndpoint", value)}
		CBaseEntity["GetEyeExitEndpoint"] <- function(){return GetProp("m_vecEyeExitEndpoint")}

		CBaseEntity["SetHasGun"] <- function(value){SetProp("m_bHasGun", value.tointeger())}
		CBaseEntity["GetHasGun"] <- function(){return GetProp("m_bHasGun")}

		CBaseEntity["SetGunCrosshair"] <- function(value){SetProp("m_vecGunCrosshair", value)}
		CBaseEntity["GetGunCrosshair"] <- function(){return GetProp("m_vecGunCrosshair")}


		CBaseEntity["SetShadowDirection"] <- function(value){SetProp("m_shadowDirection", value)}
		CBaseEntity["GetShadowDirection"] <- function(){return GetProp("m_shadowDirection")}

		CBaseEntity["SetShadowColor"] <- function(value){SetProp("m_shadowColor", value.tointeger())}
		CBaseEntity["GetShadowColor"] <- function(){return GetProp("m_shadowColor")}

		CBaseEntity["SetShadowMaxDist"] <- function(value){SetProp("m_flShadowMaxDist", value.tofloat())}
		CBaseEntity["GetShadowMaxDist"] <- function(){return GetProp("m_flShadowMaxDist")}

		CBaseEntity["SetDisableShadows"] <- function(value){SetProp("m_bDisableShadows", value.tointeger())}
		CBaseEntity["GetDisableShadows"] <- function(){return GetProp("m_bDisableShadows")}

		CBaseEntity["SetEnableLocalLightShadows"] <- function(value){SetProp("m_bEnableLocalLightShadows", value.tointeger())}
		CBaseEntity["GetEnableLocalLightShadows"] <- function(){return GetProp("m_bEnableLocalLightShadows")}


		CBaseEntity["SetMixLayerName"] <- function(value){SetProp("m_iszMixLayerName", value.tostring())}
		CBaseEntity["GetMixLayerName"] <- function(){return GetProp("m_iszMixLayerName")}

		CBaseEntity["SetMixLayerLevel"] <- function(value){SetProp("m_fMixLayerLevel", value.tofloat())}
		CBaseEntity["GetMixLayerLevel"] <- function(){return GetProp("m_fMixLayerLevel")}


		CBaseEntity["SetLightScale"] <- function(value){SetProp("m_flLightScale", value.tofloat())}
		CBaseEntity["GetLightScale"] <- function(){return GetProp("m_flLightScale")}

		CBaseEntity["SetRadius"] <- function(value){SetProp("m_Radius", value.tofloat())}
		CBaseEntity["GetRadius"] <- function(){return GetProp("m_Radius")}
			
		CBaseEntity["SetSpotlightDir"] <- function(value){SetProp("m_vSpotlightDir", value)}
		CBaseEntity["GetSpotlightDir"] <- function(){return GetProp("m_vSpotlightDir")}

		CBaseEntity["SetSpotlightOrg"] <- function(value){SetProp("m_vSpotlightOrg", value)}
		CBaseEntity["GetSpotlightOrg"] <- function(){return GetProp("m_vSpotlightOrg")}


		CBaseEntity["SetHumanSpectatorUserID"] <- function(value){SetProp("m_humanSpectatorUserID", value.tointeger())}
		CBaseEntity["GetHumanSpectatorUserID"] <- function(){return GetProp("m_humanSpectatorUserID")}

		CBaseEntity["SetHumanSpectatorEntIndex"] <- function(value){SetProp("m_humanSpectatorEntIndex", value.tointeger())}
		CBaseEntity["GetHumanSpectatorEntIndex"] <- function(){return GetProp("m_humanSpectatorEntIndex")}


		CBaseEntity["SetCharacterType"] <- function(value){SetProp("m_nCharacterType", value.tointeger())}
		CBaseEntity["GetCharacterType"] <- function(){return GetProp("m_nCharacterType")}


		CBaseEntity["SetFreezePeriod"] <- function(value){SetProp("terror_gamerules_data.m_bFreezePeriod", value.tointeger())}
		CBaseEntity["GetFreezePeriod"] <- function(){return GetProp("terror_gamerules_data.m_bFreezePeriod")}

		CBaseEntity["SetRoundTime"] <- function(value){SetProp("terror_gamerules_data.m_iRoundTime", value.tointeger())}
		CBaseEntity["GetRoundTime"] <- function(){return GetProp("terror_gamerules_data.m_iRoundTime")}

		CBaseEntity["SetLevelStartTime"] <- function(value){SetProp("terror_gamerules_data.m_fLevelStartTime", value.tofloat())}
		CBaseEntity["GetLevelStartTime"] <- function(){return GetProp("terror_gamerules_data.m_fLevelStartTime")}

		CBaseEntity["SetGameStartTime"] <- function(value){SetProp("terror_gamerules_data.m_flGameStartTime", value.tofloat())}
		CBaseEntity["GetGameStartTime"] <- function(){return GetProp("terror_gamerules_data.m_flGameStartTime")}

		CBaseEntity["SetInIntro"] <- function(value){SetProp("terror_gamerules_data.m_bInIntro", value.tointeger())}
		CBaseEntity["GetInIntro"] <- function(){return GetProp("terror_gamerules_data.m_bInIntro")}

		CBaseEntity["SetServerRank"] <- function(value){SetProp("terror_gamerules_data.m_iServerRank", value.tointeger())}
		CBaseEntity["GetServerRank"] <- function(){return GetProp("terror_gamerules_data.m_iServerRank")}

		CBaseEntity["SetServerPlayerCount"] <- function(value){SetProp("terror_gamerules_data.m_iServerPlayerCount", value.tointeger())}
		CBaseEntity["GetServerPlayerCount"] <- function(){return GetProp("terror_gamerules_data.m_iServerPlayerCount")}

		CBaseEntity["SetIsDedicatedServer"] <- function(value){SetProp("terror_gamerules_data.m_bIsDedicatedServer", value.tointeger())}
		CBaseEntity["GetIsDedicatedServer"] <- function(){return GetProp("terror_gamerules_data.m_bIsDedicatedServer")}

		CBaseEntity["SetServerSteamGroupID"] <- function(value){SetProp("terror_gamerules_data.m_iServerSteamGroupID", value.tointeger())}
		CBaseEntity["GetServerSteamGroupID"] <- function(){return GetProp("terror_gamerules_data.m_iServerSteamGroupID")}

		CBaseEntity["SetRoundStartTime"] <- function(value){SetProp("terror_gamerules_data.m_flRoundStartTime", value.tofloat())}
		CBaseEntity["GetRoundStartTime"] <- function(){return GetProp("terror_gamerules_data.m_flRoundStartTime")}

		CBaseEntity["SetRoundEndTime"] <- function(value){SetProp("terror_gamerules_data.m_flRoundEndTime", value.tofloat())}
		CBaseEntity["GetRoundEndTime"] <- function(){return GetProp("terror_gamerules_data.m_flRoundEndTime")}

		CBaseEntity["SetAccumulatedTime"] <- function(value){SetProp("terror_gamerules_data.m_flAccumulatedTime", value.tofloat())}
		CBaseEntity["GetAccumulatedTime"] <- function(){return GetProp("terror_gamerules_data.m_flAccumulatedTime")}

		CBaseEntity["SetRoundNumber"] <- function(value){SetProp("terror_gamerules_data.m_nRoundNumber", value.tointeger())}
		CBaseEntity["GetRoundNumber"] <- function(){return GetProp("terror_gamerules_data.m_nRoundNumber")}

		CBaseEntity["SetRoundLimit"] <- function(value){SetProp("terror_gamerules_data.m_nRoundLimit", value.tointeger())}
		CBaseEntity["GetRoundLimit"] <- function(){return GetProp("terror_gamerules_data.m_nRoundLimit")}

		CBaseEntity["SetTeamBestRoundTime"] <- function(value){SetProp("terror_gamerules_data.m_flTeamBestRoundTime", value.tofloat())}
		CBaseEntity["GetTeamBestRoundTime"] <- function(){return GetProp("terror_gamerules_data.m_flTeamBestRoundTime")}

		CBaseEntity["SetScavengeItemsRemaining"] <- function(value){SetProp("terror_gamerules_data.m_nScavengeItemsRemaining", value.tointeger())}
		CBaseEntity["GetScavengeItemsRemaining"] <- function(){return GetProp("terror_gamerules_data.m_nScavengeItemsRemaining")}

		CBaseEntity["SetScavengeItemsGoal"] <- function(value){SetProp("terror_gamerules_data.m_nScavengeItemsGoal", value.tointeger())}
		CBaseEntity["GetScavengeItemsGoal"] <- function(){return GetProp("terror_gamerules_data.m_nScavengeItemsGoal")}

		CBaseEntity["SetTeamsFlipped"] <- function(value){SetProp("terror_gamerules_data.m_bAreTeamsFlipped", value.tointeger())}
		CBaseEntity["GetTeamsFlipped"] <- function(){return GetProp("terror_gamerules_data.m_bAreTeamsFlipped")}

		CBaseEntity["SetSecondHalfOfRound"] <- function(value){SetProp("terror_gamerules_data.m_bInSecondHalfOfRound", value.tointeger())}
		CBaseEntity["GetSecondHalfOfRound"] <- function(){return GetProp("terror_gamerules_data.m_bInSecondHalfOfRound")}

		CBaseEntity["SetTransitioningToNextMap"] <- function(value){SetProp("terror_gamerules_data.m_bIsTransitioningToNextMap", value.tointeger())}
		CBaseEntity["GetTransitioningToNextMap"] <- function(){return GetProp("terror_gamerules_data.m_bIsTransitioningToNextMap")}

		CBaseEntity["SetVersusVoteRestarting"] <- function(value){SetProp("terror_gamerules_data.m_bIsVersusVoteRestarting", value.tointeger())}
		CBaseEntity["GetVersusVoteRestarting"] <- function(){return GetProp("terror_gamerules_data.m_bIsVersusVoteRestarting")}

		CBaseEntity["SetChallengeModeActive"] <- function(value){SetProp("terror_gamerules_data.m_bChallengeModeActive", value.tointeger())}
		CBaseEntity["GetChallengeModeActive"] <- function(){return GetProp("terror_gamerules_data.m_bChallengeModeActive")}

		CBaseEntity["SetSacrificeEscapees"] <- function(value){SetProp("terror_gamerules_data.m_iSacrificeEscapees", value.tointeger())}
		CBaseEntity["GetSacrificeEscapees"] <- function(){return GetProp("terror_gamerules_data.m_iSacrificeEscapees")}

		CBaseEntity["SetHoldoutCooldownEndTime"] <- function(value){SetProp("terror_gamerules_data.m_flHoldoutCooldownEndTime", value.tofloat())}
		CBaseEntity["GetHoldoutCooldownEndTime"] <- function(){return GetProp("terror_gamerules_data.m_flHoldoutCooldownEndTime")}


		CBaseEntity["GetListenServerHost"] <- function(){
				for(local i=0; i < GetPropArraySize("m_listenServerHost"); i++){
					if(GetProp("m_listenServerHost", i)){
						return EntIndexToHScript(i)
					}
				}
			}
			
		CBaseEntity["SetTeamSwitchRule"] <- function(ent, value){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return false
				}
				
				SetProp("m_TeamSwitchRule", value.tointeger(), ent.GetEntityIndex())
			}
		CBaseEntity["GetTeamSwitchRule"] <- function(ent){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return
				}
				
				return GetProp("m_TeamSwitchRule", ent.GetEntityIndex())
			}
			
		CBaseEntity["GetSurvivalRecordTime"] <- function(ent){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return
				}
				
				return GetProp("m_flSurvivalRecordTime", ent.GetEntityIndex())
			}
			
		CBaseEntity["GetSurvivalTopMedal"] <- function(ent){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return
				}
				
				return GetProp("m_nSurvivalTopMedal", ent.GetEntityIndex())
			}
			
		CBaseEntity["SetBecomeGhostAt"] <- function(ent, value){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return false
				}
				
				SetProp("m_flBecomeGhostAt", value.tofloat(), ent.GetEntityIndex())
			}
		CBaseEntity["GetBecomeGhostAt"] <- function(ent){
				if(ent.GetClassname() != "player" || !ent.IsValid()){
					return
				}
				
				return GetProp("m_flBecomeGhostAt", ent.GetEntityIndex())
			}
			
		CBaseEntity["SetTankLotteryEntryRatio"] <- function(value){SetProp("m_tankLotteryEntryRatio", value.tofloat())}
		CBaseEntity["GetTankLotteryEntryRatio"] <- function(){return GetProp("m_tankLotteryEntryRatio")}

		CBaseEntity["SetTankLotterySelectionRatio"] <- function(value){SetProp("m_tankLotterySelectionRatio", value.tofloat())}
		CBaseEntity["GetTankLotterySelectionRatio"] <- function(){return GetProp("m_tankLotterySelectionRatio")}

		CBaseEntity["SetPendingTankPlayerIndex"] <- function(value){SetProp("m_pendingTankPlayerIndex", value.tointeger())}
		CBaseEntity["GetPendingTankPlayerIndex"] <- function(){return GetProp("m_pendingTankPlayerIndex")}

		CBaseEntity["SetFinale"] <- function(value){SetProp("m_isFinale", value.tointeger())}
		CBaseEntity["GetFinale"] <- function(){return GetProp("m_isFinale")}

		CBaseEntity["SetIsSurvivorTeamReadyTime"] <- function(value){SetProp("m_isSurvivorTeamReadyTime", value.tointeger())}
		CBaseEntity["GetIsSurvivorTeamReadyTime"] <- function(){return GetProp("m_isSurvivorTeamReadyTime")}

		CBaseEntity["SetSurvivorTeamReadyTime"] <- function(value){SetProp("m_survivorTeamReadyTime", value.tointeger())}
		CBaseEntity["GetSurvivorTeamReadyTime"] <- function(){return GetProp("m_survivorTeamReadyTime")}

		CBaseEntity["SetRoundSetupTimeRemaining"] <- function(value){SetProp("m_nRoundSetupTimeRemaining", value.tointeger())}
		CBaseEntity["GetRoundSetupTimeRemaining"] <- function(){return GetProp("m_nRoundSetupTimeRemaining")}

		CBaseEntity["SetTempoState"] <- function(value){SetProp("m_tempoState", value.tointeger())}
		CBaseEntity["GetTempoState"] <- function(){return GetProp("m_tempoState")}

		CBaseEntity["SetAnySurvivorLeftSafeArea"] <- function(value){SetProp("m_hasAnySurvivorLeftSafeArea", value.tointeger())}
		CBaseEntity["GetAnySurvivorLeftSafeArea"] <- function(){return GetProp("m_hasAnySurvivorLeftSafeArea")}

		CBaseEntity["SetTeamFrozen"] <- function(value){SetProp("m_isTeamFrozen", value.tointeger())}
		CBaseEntity["GetTeamFrozen"] <- function(){return GetProp("m_isTeamFrozen")}

		CBaseEntity["SetMissionDuration"] <- function(value){SetProp("m_missionDuration", value.tointeger())}
		CBaseEntity["GetMissionDuration"] <- function(){return GetProp("m_missionDuration")}

		CBaseEntity["SetMissionWipes"] <- function(value){SetProp("m_missionWipes", value.tointeger())}
		CBaseEntity["GetMissionWipes"] <- function(){return GetProp("m_missionWipes")}

		CBaseEntity["SetSharedRandomSeed"] <- function(value){SetProp("m_sharedRandomSeed", value.tointeger())}
		CBaseEntity["GetSharedRandomSeed"] <- function(){return GetProp("m_sharedRandomSeed")}


		CBaseEntity["SetUsedBySurvivorsMask"] <- function(value){SetProp("m_iUsedBySurvivorsMask", value.tointeger())}
		CBaseEntity["GetUsedBySurvivorsMask"] <- function(){return GetProp("m_iUsedBySurvivorsMask")}
			
		CBaseEntity["SetWeaponID"] <- function(value){SetProp("m_weaponID", value.tointeger())}
		CBaseEntity["GetWeaponID"] <- function(){return GetProp("m_weaponID")}

		CBaseEntity["SetItemCount"] <- function(value){SetProp("m_itemCount", value.tointeger())}
		CBaseEntity["GetItemCount"] <- function(){return GetProp("m_itemCount")}


		CBaseEntity["SetWidth"] <- function(value){SetProp("m_flWidth", value.tofloat())}
		CBaseEntity["GetWidth"] <- function(){return GetProp("m_flWidth")}

		CBaseEntity["SetHeight"] <- function(value){SetProp("m_flHeight", value.tofloat())}
		CBaseEntity["GetHeight"] <- function(){return GetProp("m_flHeight")}

		CBaseEntity["SetAttachmentIndex"] <- function(value){SetProp("m_nAttachmentIndex", value.tointeger())}
		CBaseEntity["GetAttachmentIndex"] <- function(){return GetProp("m_nAttachmentIndex")}

		CBaseEntity["SetPanelName"] <- function(value){SetProp("m_nPanelName", value.tointeger())}
		CBaseEntity["GetPanelName"] <- function(){return GetProp("m_nPanelName")}

		CBaseEntity["SetScreenFlags"] <- function(value){SetProp("m_fScreenFlags", value.tointeger())}
		CBaseEntity["GetScreenFlags"] <- function(){return GetProp("m_fScreenFlags")}

		CBaseEntity["SetOverlayMaterial"] <- function(value){SetProp("m_nOverlayMaterial", value.tointeger())}
		CBaseEntity["GetOverlayMaterial"] <- function(){return GetProp("m_nOverlayMaterial")}

		CBaseEntity["SetPlayerOwner"] <- function(value){SetPropEntity("m_hPlayerOwner", value)}
		CBaseEntity["GetPlayerOwner"] <- function(value){return GetPropEntity("m_hPlayerOwner")}


		CBaseEntity["SetEnabled"] <- function(value){SetProp("m_bEnabled", value.tointeger())}
		CBaseEntity["GetEnabled"] <- function(){return GetProp("m_bEnabled")}

		CBaseEntity["SetDisplayText"] <- function(value){SetProp("m_szDisplayText", value.tostring())}
		CBaseEntity["GetDisplayText"] <- function(){return GetProp("m_szDisplayText")}

		CBaseEntity["SetSlideshowDirectory"] <- function(value){SetProp("m_szSlideshowDirectory", value.tostring())}
		CBaseEntity["GetSlideshowDirectory"] <- function(){return GetProp("m_szSlideshowDirectory")}

		CBaseEntity["SetMinSlideTime"] <- function(value){SetProp("m_fMinSlideTime", value.tofloat())}
		CBaseEntity["GetMinSlideTime"] <- function(){return GetProp("m_fMinSlideTime")}

		CBaseEntity["SetMaxSlideTime"] <- function(value){SetProp("m_fMaxSlideTime", value.tofloat())}
		CBaseEntity["GetMaxSlideTime"] <- function(){return GetProp("m_fMaxSlideTime")}

		CBaseEntity["SetCycleType"] <- function(value){SetProp("m_iCycleType", value.tointeger())}
		CBaseEntity["GetCycleType"] <- function(){return GetProp("m_iCycleType")}

		CBaseEntity["SetNoListRepeats"] <- function(value){SetProp("m_bNoListRepeats", value.tointeger())}
		CBaseEntity["GetNoListRepeats"] <- function(){return GetProp("m_bNoListRepeats")}
			
		CBaseEntity["SetScreenWidth"] <- function(value){SetProp("m_iScreenWidth", value.tointeger())}
		CBaseEntity["GetScreenWidth"] <- function(){return GetProp("m_iScreenWidth")}

		CBaseEntity["SetScreenHeight"] <- function(value){SetProp("m_iScreenHeight", value.tointeger())}
		CBaseEntity["GetScreenHeight"] <- function(){return GetProp("m_iScreenHeight")}


		CBaseEntity["SetActiveIssueIndex"] <- function(value){SetProp("m_activeIssueIndex", value.tointeger())}
		CBaseEntity["GetActiveIssueIndex"] <- function(){return GetProp("m_activeIssueIndex")}

		CBaseEntity["SetOnlyTeamToVote"] <- function(value){SetProp("m_onlyTeamToVote", value.tointeger())}
		CBaseEntity["GetOnlyTeamToVote"] <- function(){return GetProp("m_onlyTeamToVote")}

		CBaseEntity["SetVotesYes"] <- function(value){SetProp("m_votesYes", value.tointeger())}
		CBaseEntity["GetVotesYes"] <- function(){return GetProp("m_votesYes")}

		CBaseEntity["SetVotesNo"] <- function(value){SetProp("m_votesNo", value.tointeger())}
		CBaseEntity["GetVotesNo"] <- function(){return GetProp("m_votesNo")}

		CBaseEntity["SetPotentialVotes"] <- function(value){SetProp("m_potentialVotes", value.tointeger())}
		CBaseEntity["GetPotentialVotes"] <- function(){return GetProp("m_potentialVotes")}


		CBaseEntity["SetCheapWaterStartDistance"] <- function(value){SetProp("m_flCheapWaterStartDistance", value.tofloat())}
		CBaseEntity["GetCheapWaterStartDistance"] <- function(){return GetProp("m_flCheapWaterStartDistance")}

		CBaseEntity["SetCheapWaterEndDistance"] <- function(value){SetProp("m_flCheapWaterEndDistance", value.tofloat())}
		CBaseEntity["GetCheapWaterEndDistance"] <- function(){return GetProp("m_flCheapWaterEndDistance")}


		CBaseEntity["SetWeaponID"] <- function(value){SetProp("m_weaponID", value.tointeger())}
		CBaseEntity["GetWeaponID"] <- function(){return GetProp("m_weaponID")}
			
		CBaseEntity["SetItemCount"] <- function(value){SetProp("m_itemCount", value.tointeger())}
		CBaseEntity["GetItemCount"] <- function(){return GetProp("m_itemCount")}


		CBaseEntity["SetState"] <- function(value){SetProp("m_iState", value.tointeger())}
		CBaseEntity["GetState"] <- function(){return GetProp("m_iState")}

		CBaseEntity["SetHitting"] <- function(value){SetProp("m_bHitting", value.tointeger())}
		CBaseEntity["GetHitting"] <- function(){return GetProp("m_bHitting")}


		CBaseEntity["SetVulnerableToSpit"] <- function(value){SetProp("m_bVulnerableToSpit", value.tointeger())}
		CBaseEntity["GetVulnerableToSpit"] <- function(){return GetProp("m_bVulnerableToSpit")}


		CBaseEntity["SetLastAttackTime"] <- function(value){SetProp("m_flLastAttackTime", value.tofloat())}
		CBaseEntity["GetLastAttackTime"] <- function(){return GetProp("m_flLastAttackTime")}

		CBaseEntity["SetMeleeWeaponInfo"] <- function(value){SetPropEntity("m_hMeleeWeaponInfo", value)}
		CBaseEntity["GetMeleeWeaponInfo"] <- function(value){return GetPropEntity("m_hMeleeWeaponInfo")}

		CBaseEntity["SetNextPrimaryAttackIndex"] <- function(value){SetProp("m_iNextPrimaryAttackIndex", value.tointeger())}
		CBaseEntity["GetNextPrimaryAttackIndex"] <- function(){return GetProp("m_iNextPrimaryAttackIndex")}

		CBaseEntity["SetNextStrongAttackIndex"] <- function(value){SetProp("m_iNextStrongAttackIndex", value.tointeger())}
		CBaseEntity["GetNextStrongAttackIndex"] <- function(){return GetProp("m_iNextStrongAttackIndex")}

		CBaseEntity["SetNextSecondaryAttackIndex"] <- function(value){SetProp("m_iNextSecondaryAttackIndex", value.tointeger())}
		CBaseEntity["GetNextSecondaryAttackIndex"] <- function(){return GetProp("m_iNextSecondaryAttackIndex")}

		CBaseEntity["SetInMeleeSwing"] <- function(value){SetProp("m_bInMeleeSwing", value.tointeger())}
		CBaseEntity["GetInMeleeSwing"] <- function(){return GetProp("m_bInMeleeSwing")}

		CBaseEntity["SetMeleeSwingDuration"] <- function(value){SetProp("m_meleeSwingTimer.m_duration", value.tofloat())}
		CBaseEntity["GetMeleeSwingDuration"] <- function(value){return GetProp("m_meleeSwingTimer.m_duration")}

		CBaseEntity["SetMeleeSwingTimestamp"] <- function(value){SetProp("m_meleeSwingTimer.m_timestamp", value.tofloat()())}
		CBaseEntity["GetMeleeSwingTimestamp"] <- function(value){return GetProp("m_meleeSwingTimer.m_timestamp")}
			
		CBaseEntity["SetMapSetScriptName"] <- function(value){SetProp("m_strMapSetScriptName", value.tostring())}
		CBaseEntity["GetMapSetScriptName"] <- function(){return GetProp("m_strMapSetScriptName")}


		CBaseEntity["SetRage"] <- function(value){SetProp("m_rage", value.tofloat())}
		CBaseEntity["GetRage"] <- function(){return GetProp("m_rage")}

		CBaseEntity["SetWanderRage"] <- function(value){SetProp("m_wanderrage", value.tofloat())}
		CBaseEntity["GetWanderRage"] <- function(){return GetProp("m_wanderrage")}


		CBaseEntity["SetWaveHeight"] <- function(value){SetProp("m_flWaveHeight", value.tofloat())}
		CBaseEntity["GetWaveHeight"] <- function(){return GetProp("m_flWaveHeight")}

		CBaseEntity["SetWorldMins"] <- function(value){SetProp("m_WorldMins", value)}
		CBaseEntity["GetWorldMins"] <- function(){return GetProp("m_WorldMins")}

		CBaseEntity["SetWorldMaxs"] <- function(value){SetProp("m_WorldMaxs", value)}
		CBaseEntity["GetWorldMaxs"] <- function(){return GetProp("m_WorldMaxs")}

		CBaseEntity["SetStartDark"] <- function(value){SetProp("m_bStartDark", value.tointeger())}
		CBaseEntity["GetStartDark"] <- function(){return GetProp("m_bStartDark")}

		CBaseEntity["SetMaxOccludeeArea"] <- function(value){SetProp("m_flMaxOccludeeArea", value.tofloat())}
		CBaseEntity["GetMaxOccludeeArea"] <- function(){return GetProp("m_flMaxOccludeeArea")}

		CBaseEntity["SetMinOccluderArea"] <- function(value){SetProp("m_flMinOccluderArea", value.tofloat())}
		CBaseEntity["GetMinOccluderArea"] <- function(){return GetProp("m_flMinOccluderArea")}

		CBaseEntity["SetMaxPropScreenSpaceWidth"] <- function(value){SetProp("m_flMaxPropScreenSpaceWidth", value.tofloat())}
		CBaseEntity["GetMaxPropScreenSpaceWidth"] <- function(){return GetProp("m_flMaxPropScreenSpaceWidth")}

		CBaseEntity["SetMinPropScreenSpaceWidth"] <- function(value){SetProp("m_flMinPropScreenSpaceWidth", value.tofloat())}
		CBaseEntity["GetMinPropScreenSpaceWidth"] <- function(){return GetProp("m_flMinPropScreenSpaceWidth")}

		CBaseEntity["SetDetailSpriteMaterial"] <- function(value){SetProp("m_iszDetailSpriteMaterial", value.tostring())}
		CBaseEntity["GetDetailSpriteMaterial"] <- function(){return GetProp("m_iszDetailSpriteMaterial")}

		CBaseEntity["SetStartMusicType"] <- function(value){SetProp("m_iStartMusicType", value.tointeger())}
		CBaseEntity["GetStartMusicType"] <- function(){return GetProp("m_iStartMusicType")}

		CBaseEntity["SetMusicPostFix"] <- function(value){SetProp("m_iszMusicPostFix", value.tostring())}
		CBaseEntity["GetMusicPostFix"] <- function(){return GetProp("m_iszMusicPostFix")}

		CBaseEntity["SetColdWorld"] <- function(value){SetProp("m_bColdWorld", value.tointeger())}
		CBaseEntity["GetColdWorld"] <- function(){return GetProp("m_bColdWorld")}
			
		CBaseEntity["SetChapterTitle"] <- function(value){SetProp("m_iszChapterTitle", value.tostring())}
		CBaseEntity["GetChapterTitle"] <- function(){return GetProp("m_iszChapterTitle")}

		CBaseEntity["SetDisplayTitle"] <- function(value){SetProp("m_bDisplayTitle", value.tointeger())}
		CBaseEntity["GetDisplayTitle"] <- function(){return GetProp("m_bDisplayTitle")}

		CBaseEntity["SetTimeOfDay"] <- function(value){SetProp("m_iTimeOfDay", value.tointeger())}
		CBaseEntity["GetTimeOfDay"] <- function(){return GetProp("m_iTimeOfDay")}
	}
	
	local func_CBaseAnimating = function(){
		CBaseAnimating["GetMoveType"] <- function(){return GetPropInt("movetype")}
		CBaseAnimating["SetMoveType"] <- function(type){SetPropInt("movetype", type)}

		CBaseAnimating["PlaySound"] <- function(soundName){EmitSoundOn(soundName, this)}
		CBaseAnimating["StopSound"] <- function(soundName){StopSoundOn(soundName, this)}

		CBaseAnimating["GetFlags"] <- function(){return GetPropInt("m_fFlags")}
		CBaseAnimating["SetFlags"] <- function(flag){SetPropInt("m_fFlags", flag)}
		CBaseAnimating["AddFlag"] <- function(flag){SetPropInt("m_fFlags", GetPropInt("m_fFlags") | flag)}
		CBaseAnimating["RemoveFlag"] <- function(flag){SetPropInt("m_fFlags", GetPropInt("m_fFlags") & ~flag)}
		CBaseAnimating["HasFlag"] <- function(flag){return GetFlags() & flag}

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

		CBaseAnimating["SetTeam"] <- function(team){SetPropInt("m_iTeamNum", team.tointeger())}
		CBaseAnimating["GetTeam"] <- function(){return GetPropInt("m_iTeamNum")}

		CBaseAnimating["Input"] <- function(input, value = "", delay = 0, activator = null){DoEntFire("!self", input.tostring(), value.tostring(), delay.tofloat(), activator, this)}
		CBaseAnimating["SetAlpha"] <- function(alpha){Input("Alpha", alpha)}
		CBaseAnimating["Enable"] <- function(){Input("Enable")}
		CBaseAnimating["Disable"] <- function(){Input("Disable")}

		CBaseAnimating["GetMoveType"] <- function(){return GetPropInt("movetype")}
		CBaseAnimating["SetMoveType"] <- function(type){SetPropInt("movetype", type)}

		CBaseAnimating["GetModelIndex"] <- function(){return GetPropInt("m_nModelIndex")}
		CBaseAnimating["GetModelName"] <- function(){return GetPropString("m_ModelName")}
		CBaseAnimating["SetName"] <- function(name){SetPropString("m_iName", name)}

		CBaseAnimating["GetFriction"] <- function(){return GetFriction(this)}

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

		CBaseAnimating["SetProp"] <- function(propertyName, value, index = null){
			if(GetPropType(propertyName) == "integer"){
				if(GetPropArraySize(propertyName) > 1){
					if(typeof(value) == "array"){
						for(local i=0; i < value.len(); i++){
							SetPropIntArray(propertyName, i, value[i])
						}
					} else {
						SetPropIntArray(propertyName, index, value)
					}
				} else {
					SetPropInt(propertyName, value)
				}
			} else if(GetPropType(propertyName) == "float"){
				if(GetPropArraySize(propertyName) > 1){
					if(typeof(value) == "array"){
						for(local i=0; i < value.len(); i++){
							SetPropFloatArray(propertyName, i, value[i])
						}
					} else {
						SetPropFloatArray(propertyName, index, value)
					}
				} else {
					SetPropFloat(propertyName, value)
				}
			} else if(GetPropType(propertyName) == "Vector"){
				if(GetPropArraySize(propertyName) > 1){
					if(typeof(value) == "array"){
						for(local i=0; i < value.len(); i++){
							SetPropVectorArray(propertyName, i, value[i])
						}
					} else {
						SetPropVectorArray(propertyName, index, value)
					}
				} else {
					SetPropVector(propertyName, value)
				}
			} else if(GetPropType(propertyName) == "string"){
				if(GetPropArraySize(propertyName) > 1){
					if(typeof(value) == "array"){
						for(local i=0; i < value.len(); i++){
							SetPropStringArray(propertyName, i, value[i])
						}
					} else {
						SetPropStringArray(propertyName, index, value)
					}
				} else {
					SetPropString(propertyName, value)
				}
			}
		}
		CBaseAnimating["GetProp"] <- function(propertyName, index = null, asArray = false){
			if(GetPropType(propertyName) == "integer"){
				if(GetPropArraySize(propertyName) > 1){
					if(asArray){
						local netpropArray = []
						for(local i=0; i < GetPropArraySize(propertyName); i++){
							netpropArray.append(GetPropIntArray(propertyName, i))
						}
						return netpropArray
					}
					return GetPropIntArray(propertyName, index)
				} else {
					return GetPropInt(propertyName)
				}
			} else if(GetPropType(propertyName) == "float"){
				if(GetPropArraySize(propertyName) > 1){
					if(asArray){
						local netpropArray = []
						for(local i=0; i < GetPropArraySize(propertyName); i++){
							netpropArray.append(GetPropFloatArray(propertyName, i))
						}
						return netpropArray
					}
					return GetPropFloatArray(propertyName, index)
				} else {
					return GetPropFloat(propertyName)
				}
			} else if(GetPropType(propertyName) == "Vector"){
				if(GetPropArraySize(propertyName) > 1){
					if(asArray){
						local netpropArray = []
						for(local i=0; i < GetPropArraySize(propertyName); i++){
							netpropArray.append(GetPropVectorArray(propertyName, i))
						}
						return netpropArray
					}
					return GetPropVectorArray(propertyName, index)
				} else {
					return GetPropVector(propertyName)
				}
			} else if(GetPropType(propertyName) == "string"){
				if(GetPropArraySize(propertyName) > 1){
					if(asArray){
						local netpropArray = []
						for(local i=0; i < GetPropArraySize(propertyName); i++){
							netpropArray.append(GetPropStringArray(propertyName, i))
						}
						return netpropArray
					}
					return GetPropStringArray(propertyName, index)
				} else {
					return GetPropString(propertyName)
				}
			}
		}

		CBaseAnimating["SetRenderFX"] <- function(value){SetProp("m_nRenderFX", value.tointeger())}
		CBaseAnimating["GetRenderFX"] <- function(){return GetProp("m_nRenderFX")}

		CBaseAnimating["SetRenderMode"] <- function(value){SetProp("m_nRenderMode", value.tointeger())}
		CBaseAnimating["GetRenderMode"] <- function(){return GetProp("m_nRenderMode")}

		CBaseAnimating["SetClip"] <- function(clip){SetPropInt("m_iClip1", clip)}
		CBaseAnimating["GetClip"] <- function(){return GetPropInt("m_iClip1")}
		CBaseAnimating["SetReserveAmmo"] <- function(ammo){SetPropInt("m_iExtraPrimaryAmmo", ammo)}
		CBaseAnimating["GetReserveAmmo"] <- function(){return GetPropInt("m_iExtraPrimaryAmmo")}
	}
	
	local func_CTerrorPlayer = function(){
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

		CTerrorPlayer["SetProp"] <- function(propertyName, value, index = null){
			if(GetPropType(propertyName) == "integer"){
				if(GetPropArraySize(propertyName) > 1){
					if(typeof(value) == "array"){
						for(local i=0; i < value.len(); i++){
							SetPropIntArray(propertyName, i, value[i])
						}
					} else {
						SetPropIntArray(propertyName, index, value)
					}
				} else {
					SetPropInt(propertyName, value)
				}
			} else if(GetPropType(propertyName) == "float"){
				if(GetPropArraySize(propertyName) > 1){
					if(typeof(value) == "array"){
						for(local i=0; i < value.len(); i++){
							SetPropFloatArray(propertyName, i, value[i])
						}
					} else {
						SetPropFloatArray(propertyName, index, value)
					}
				} else {
					SetPropFloat(propertyName, value)
				}
			} else if(GetPropType(propertyName) == "Vector"){
				if(GetPropArraySize(propertyName) > 1){
					if(typeof(value) == "array"){
						for(local i=0; i < value.len(); i++){
							SetPropVectorArray(propertyName, i, value[i])
						}
					} else {
						SetPropVectorArray(propertyName, index, value)
					}
				} else {
					SetPropVector(propertyName, value)
				}
			} else if(GetPropType(propertyName) == "string"){
				if(GetPropArraySize(propertyName) > 1){
					if(typeof(value) == "array"){
						for(local i=0; i < value.len(); i++){
							SetPropStringArray(propertyName, i, value[i])
						}
					} else {
						SetPropStringArray(propertyName, index, value)
					}
				} else {
					SetPropString(propertyName, value)
				}
			}
		}
		CTerrorPlayer["GetProp"] <- function(propertyName, index = null, asArray = false){
			if(GetPropType(propertyName) == "integer"){
				if(GetPropArraySize(propertyName) > 1){
					if(asArray){
						local netpropArray = []
						for(local i=0; i < GetPropArraySize(propertyName); i++){
							netpropArray.append(GetPropIntArray(propertyName, i))
						}
						return netpropArray
					}
					return GetPropIntArray(propertyName, index)
				} else {
					return GetPropInt(propertyName)
				}
			} else if(GetPropType(propertyName) == "float"){
				if(GetPropArraySize(propertyName) > 1){
					if(asArray){
						local netpropArray = []
						for(local i=0; i < GetPropArraySize(propertyName); i++){
							netpropArray.append(GetPropFloatArray(propertyName, i))
						}
						return netpropArray
					}
					return GetPropFloatArray(propertyName, index)
				} else {
					return GetPropFloat(propertyName)
				}
			} else if(GetPropType(propertyName) == "Vector"){
				if(GetPropArraySize(propertyName) > 1){
					if(asArray){
						local netpropArray = []
						for(local i=0; i < GetPropArraySize(propertyName); i++){
							netpropArray.append(GetPropVectorArray(propertyName, i))
						}
						return netpropArray
					}
					return GetPropVectorArray(propertyName, index)
				} else {
					return GetPropVector(propertyName)
				}
			} else if(GetPropType(propertyName) == "string"){
				if(GetPropArraySize(propertyName) > 1){
					if(asArray){
						local netpropArray = []
						for(local i=0; i < GetPropArraySize(propertyName); i++){
							netpropArray.append(GetPropStringArray(propertyName, i))
						}
						return netpropArray
					}
					return GetPropStringArray(propertyName, index)
				} else {
					return GetPropString(propertyName)
				}
			}
		}

		CTerrorPlayer["Input"] <- function(input, value = "", delay = 0, activator = null){DoEntFire("!self", input.tostring(), value.tostring(), delay.tofloat(), activator, this)}
		CTerrorPlayer["SetAlpha"] <- function(alpha){Input("Alpha", alpha)}
		CTerrorPlayer["Enable"] <- function(){Input("Enable")}
		CTerrorPlayer["Disable"] <- function(){Input("Disable")}

		CTerrorPlayer["SetDucked"] <- function(value){SetProp("m_Local.m_bDucked", value.tointeger())}
		CTerrorPlayer["GetDucked"] <- function(){return GetProp("m_Local.m_bDucked")}

		CTerrorPlayer["SetDucking"] <- function(value){SetProp("m_Local.m_bDucking", value.tointeger())}
		CTerrorPlayer["GetDucking"] <- function(){return GetProp("m_Local.m_bDucking")}

		CTerrorPlayer["SetInDuckJump"] <- function(value){SetProp("m_Local.m_bInDuckJump", value.tointeger())}
		CTerrorPlayer["GetInDuckJump"] <- function(){return GetProp("m_Local.m_bInDuckJump")}

		CTerrorPlayer["SetDuckTimeInMilliseconds"] <- function(value){SetProp("m_Local.m_nDuckTimeMsecs", value.tointeger())}
		CTerrorPlayer["GetDuckTimeInMilliseconds"] <- function(){return GetProp("m_Local.m_nDuckTimeMsecs")}

		CTerrorPlayer["SetDuckJumpTimeInMilliseconds"] <- function(value){SetProp("m_Local.m_nDuckJumpTimeMsecs", value.tointeger())}
		CTerrorPlayer["GetDuckJumpTimeInMilliseconds"] <- function(){return GetProp("m_Local.m_nDuckJumpTimeMsecs")}

		CTerrorPlayer["SetJumpTimeInMilliseconds"] <- function(value){SetProp("m_Local.m_nJumpTimeMsecs", value.tointeger())}
		CTerrorPlayer["GetJumpTimeInMilliseconds"] <- function(){return GetProp("m_Local.m_nJumpTimeMsecs")}

		CTerrorPlayer["SetPunchAngle"] <- function(value){SetProp("m_Local.m_vecPunchAngle", value)}
		CTerrorPlayer["GetPunchAngle"] <- function(){return GetProp("m_Local.m_vecPunchAngle")}

		CTerrorPlayer["SetPunchAngleVel"] <- function(value){SetProp("m_Local.m_vecPunchAngleVel", value)}
		CTerrorPlayer["GetPunchAngleVel"] <- function(){return GetProp("m_Local.m_vecPunchAngleVel")}

		CTerrorPlayer["SetAllowAutoMovement"] <- function(value){SetProp("m_Local.m_bAllowAutoMovement", value.tointeger())}
		CTerrorPlayer["GetAllowAutoMovement"] <- function(){return GetProp("m_Local.m_bAllowAutoMovement")}

		CTerrorPlayer["SetAutoAimTarget"] <- function(value){SetProp("m_Local.m_bAutoAimTarget", value.tointeger())}
		CTerrorPlayer["GetAutoAimTarget"] <- function(){return GetProp("m_Local.m_bAutoAimTarget")}

		CTerrorPlayer["SetLastWeapon"] <- function(value){SetPropEntity("m_Local.m_hLastWeapon", value)}
		CTerrorPlayer["GetLastWeapon"] <- function(){return GetPropEntity("m_Local.m_hLastWeapon")}

		CTerrorPlayer["SetDeathTime"] <- function(value){SetProp("m_Local.m_flDeathTime", value.tofloat())}
		CTerrorPlayer["GetDeathTime"] <- function(){return GetProp("m_Local.m_flDeathTime")}

		CTerrorPlayer["SetTonemapController"] <- function(value){SetPropEntity("m_Local.m_hTonemapController", value)}
		CTerrorPlayer["GetTonemapController"] <- function(){return GetPropEntity("m_Local.m_hTonemapController")}

		CTerrorPlayer["SetShotsFired"] <- function(value){SetProp("m_iShotsFired", value.tointeger())}
		CTerrorPlayer["GetShotsFired"] <- function(){return GetProp("m_iShotsFired")}

		CTerrorPlayer["SetVelocityModifier"] <- function(value){SetProp("m_flVelocityModifier", value.tofloat())}
		CTerrorPlayer["GetVelocityModifier"] <- function(){return GetProp("m_flVelocityModifier")}

		CTerrorPlayer["SetArmorValue"] <- function(value){SetProp("m_ArmorValue", value.tointeger())}
		CTerrorPlayer["GetArmorValue"] <- function(){return GetProp("m_ArmorValue")}

		CTerrorPlayer["SetProgressBarDuration"] <- function(value){SetProp("m_flProgressBarDuration", value.tofloat())}
		CTerrorPlayer["GetProgressBarDuration"] <- function(){return GetProp("m_flProgressBarDuration")}

		CTerrorPlayer["SetProgressBarStartTime"] <- function(value){SetProp("m_flProgressBarStartTime", value.tofloat())}
		CTerrorPlayer["GetProgressBarStartTime"] <- function(){return GetProp("m_flProgressBarStartTime")}

		CTerrorPlayer["SetRagdoll"] <- function(value){SetPropEntity("m_hRagdoll", value)}
		CTerrorPlayer["GetRagdoll"] <- function(){return GetPropEntity("m_hRagdoll")}

		CTerrorPlayer["SetInMissionStartArea"] <- function(value){SetProp("m_isInMissionStartArea", value.tointeger())}
		CTerrorPlayer["GetInMissionStartArea"] <- function(){return GetProp("m_isInMissionStartArea")}

		CTerrorPlayer["SetCulling"] <- function(value){SetProp("m_isCulling", value.tointeger())}
		CTerrorPlayer["GetCulling"] <- function(){return GetProp("m_isCulling")}

		CTerrorPlayer["SetRelocating"] <- function(value){SetProp("m_isRelocating", value.tointeger())}
		CTerrorPlayer["GetRelocating"] <- function(){return GetProp("m_isRelocating")}

		CTerrorPlayer["SetGhostSpawnState"] <- function(value){SetProp("m_ghostSpawnState", value.tointeger())}
		CTerrorPlayer["GetGhostSpawnState"] <- function(){return GetProp("m_ghostSpawnState")}

		CTerrorPlayer["SetGhostSpawnClockMaxDelay"] <- function(value){SetProp("m_ghostSpawnClockMaxDelay", value.tointeger())}
		CTerrorPlayer["GetGhostSpawnClockMaxDelay"] <- function(){return GetProp("m_ghostSpawnClockMaxDelay")}

		CTerrorPlayer["SetGhostSpawnClockCurrentDelay"] <- function(value){SetProp("m_ghostSpawnClockCurrentDelay", value.tointeger())}
		CTerrorPlayer["GetGhostSpawnClockCurrentDelay"] <- function(){return GetProp("m_ghostSpawnClockCurrentDelay")}

		CTerrorPlayer["SetNextShoveTime"] <- function(value){SetProp("m_flNextShoveTime", value.tofloat())}
		CTerrorPlayer["GetNextShoveTime"] <- function(){return GetProp("m_flNextShoveTime")}

		CTerrorPlayer["SetShovePenalty"] <- function(value){SetProp("m_iShovePenalty", value.tointeger())}
		CTerrorPlayer["GetShovePenalty"] <- function(){return GetProp("m_iShovePenalty")}

		CTerrorPlayer["SetAutoCrouchEnabled"] <- function(value){SetProp("m_isAutoCrouchEnabled", value.tointeger())}
		CTerrorPlayer["GetAutoCrouchEnabled"] <- function(){return GetProp("m_isAutoCrouchEnabled")}

		CTerrorPlayer["SetAutoCrouchTimestamp"] <- function(value){SetProp("m_autoCrouchTimer.m_timestamp", value.tofloat())}
		CTerrorPlayer["GetAutoCrouchTimestamp"] <- function(){return GetProp("m_autoCrouchTimer.m_timestamp")}

		CTerrorPlayer["SetAdrenalineActive"] <- function(value){SetProp("m_bAdrenalineActive", value.tointeger())}
		CTerrorPlayer["GetAdrenalineActive"] <- function(){return GetProp("m_bAdrenalineActive")}

		CTerrorPlayer["SetZombieClass"] <- function(value){SetProp("m_zombieClass", value.tointeger())}
		CTerrorPlayer["GetZombieClass"] <- function(){return GetProp("m_zombieClass")}

		CTerrorPlayer["SetZombieState"] <- function(value){SetProp("m_zombieState", value.tointeger())}
		CTerrorPlayer["GetZombieState"] <- function(){return GetProp("m_zombieState")}

		CTerrorPlayer["SetMaxDeadDuration"] <- function(value){SetProp("m_maxDeadDuration", value.tofloat())}
		CTerrorPlayer["GetMaxDeadDuration"] <- function(){return GetProp("m_maxDeadDuration")}

		CTerrorPlayer["SetTotalDeadDuration"] <- function(value){SetProp("m_totalDeadDuration", value.tofloat())}
		CTerrorPlayer["GetTotalDeadDuration"] <- function(){return GetProp("m_totalDeadDuration")}

		CTerrorPlayer["SetHangTimestamp"] <- function(value){SetProp("m_hangTimer.m_timestamp", value.tofloat())}
		CTerrorPlayer["GetHangTimestamp"] <- function(){return GetProp("m_hangTimer.m_timestamp")}

		CTerrorPlayer["SetHangAirPos"] <- function(value){SetProp("m_hangAirPos", value)}
		CTerrorPlayer["GetHangAirPos"] <- function(){return GetProp("m_hangAirPos")}

		CTerrorPlayer["SetHangPos"] <- function(value){SetProp("m_hangPos", value)}
		CTerrorPlayer["GetHangPos"] <- function(){return GetProp("m_hangPos")}

		CTerrorPlayer["SetHangStandPos"] <- function(value){SetProp("m_hangStandPos", value)}
		CTerrorPlayer["GetHangStandPos"] <- function(){return GetProp("m_hangStandPos")}

		CTerrorPlayer["SetHangNormal"] <- function(value){SetProp("m_hangNormal", value)}
		CTerrorPlayer["GetHangNormal"] <- function(){return GetProp("m_hangNormal")}

		CTerrorPlayer["SetKnockdownReason"] <- function(value){SetProp("m_knockdownReason", value.tointeger())}
		CTerrorPlayer["GetKnockdownReason"] <- function(){return GetProp("m_knockdownReason")}

		CTerrorPlayer["SetKnockdownTimestamp"] <- function(value){SetProp("m_knockdownTimer.m_timestamp", value.tofloat())}
		CTerrorPlayer["GetKnockdownTimestamp"] <- function(){return GetProp("m_knockdownTimer.m_timestamp")}

		CTerrorPlayer["SetStaggerTimestamp"] <- function(value){SetProp("m_staggerTimer.m_timestamp", value.tofloat())}
		CTerrorPlayer["GetStaggerTimestamp"] <- function(){return GetProp("m_staggerTimer.m_timestamp")}

		CTerrorPlayer["SetStaggerDuration"] <- function(value){SetProp("m_staggerTimer.m_duration", value.tofloat())}
		CTerrorPlayer["GetStaggerDuration"] <- function(){return GetProp("m_staggerTimer.m_duration")}

		CTerrorPlayer["SetStaggerStart"] <- function(value){SetProp("m_staggerStart", value)}
		CTerrorPlayer["GetStaggerStart"] <- function(){return GetProp("m_staggerStart")}

		CTerrorPlayer["SetStaggerDir"] <- function(value){SetProp("m_staggerDir", value)}
		CTerrorPlayer["GetStaggerDir"] <- function(){return GetProp("m_staggerDir")}

		CTerrorPlayer["SetStaggerDist"] <- function(value){SetProp("m_staggerDist", value.tofloat())}
		CTerrorPlayer["GetStaggerDist"] <- function(){return GetProp("m_staggerDist")}

		CTerrorPlayer["SetTugTimestamp"] <- function(value){SetProp("m_tugTimer.m_timestamp", value.tofloat())}
		CTerrorPlayer["GetTugTimestamp"] <- function(){return GetProp("m_tugTimer.m_timestamp")}

		CTerrorPlayer["SetTugDuration"] <- function(value){SetProp("m_tugTimer.m_duration", value.tofloat())}
		CTerrorPlayer["GetTugDuration"] <- function(){return GetProp("m_tugTimer.m_duration")}

		CTerrorPlayer["SetTugStart"] <- function(value){SetProp("m_tugStart", value)}
		CTerrorPlayer["GetTugStart"] <- function(){return GetProp("m_tugStart")}

		CTerrorPlayer["SetTugDir"] <- function(value){SetProp("m_tugDir", value)}
		CTerrorPlayer["GetTugDir"] <- function(){return GetProp("m_tugDir")}

		CTerrorPlayer["SetTugDist"] <- function(value){SetProp("m_tugDist", value.tofloat())}
		CTerrorPlayer["GetTugDist"] <- function(){return GetProp("m_tugDist")}

		CTerrorPlayer["SetVocalizationSubject"] <- function(value){SetPropEntity("m_vocalizationSubject", value)}
		CTerrorPlayer["GetVocalizationSubject"] <- function(){return GetPropEntity("m_vocalizationSubject")}

		CTerrorPlayer["SetVocalizationSubjectTimestamp"] <- function(value){SetProp("m_vocalizationSubjectTimer.m_timestamp", value.tofloat())}
		CTerrorPlayer["GetVocalizationSubjectTimestamp"] <- function(){return GetProp("m_vocalizationSubjectTimer.m_timestamp")}

		CTerrorPlayer["SetVocalizationSubjectDuration"] <- function(value){SetProp("m_vocalizationSubjectTimer.m_duration", value.tofloat())}
		CTerrorPlayer["GetVocalizationSubjectDuration"] <- function(){return GetProp("m_vocalizationSubjectTimer.m_duration")}

		CTerrorPlayer["SetPounceStartPosition"] <- function(value){SetProp("m_pounceStartPosition", value)}
		CTerrorPlayer["GetPounceStartPosition"] <- function(){return GetProp("m_pounceStartPosition")}

		CTerrorPlayer["SetAttemptingToPounce"] <- function(value){SetProp("m_isAttemptingToPounce", value.tointeger())}
		CTerrorPlayer["GetAttemptingToPounce"] <- function(){return GetProp("m_isAttemptingToPounce")}

		CTerrorPlayer["SetVomitStart"] <- function(value){SetProp("m_vomitStart", value.tofloat())}
		CTerrorPlayer["GetVomitStart"] <- function(){return GetProp("m_vomitStart")}

		CTerrorPlayer["SetVomitFadeStart"] <- function(value){SetProp("m_vomitFadeStart", value.tofloat())}
		CTerrorPlayer["GetVomitFadeStart"] <- function(){return GetProp("m_vomitFadeStart")}

		CTerrorPlayer["SetBashedStart"] <- function(value){SetProp("m_bashedStart", value.tofloat())}
		CTerrorPlayer["GetBashedStart"] <- function(){return GetProp("m_bashedStart")}

		CTerrorPlayer["SetSalivaStart"] <- function(value){SetProp("m_salivaStart", value.tofloat())}
		CTerrorPlayer["GetSalivaStart"] <- function(){return GetProp("m_salivaStart")}

		CTerrorPlayer["SetVersusTeam"] <- function(value){SetProp("m_iVersusTeam", value.tointeger())}
		CTerrorPlayer["GetVersusTeam"] <- function(){return GetProp("m_iVersusTeam")}

		CTerrorPlayer["SetLagCompensation"] <- function(value){SetProp("m_bLagCompensation", value.tointeger())}
		CTerrorPlayer["GetLagCompensation"] <- function(){return GetProp("m_bLagCompensation")}

		CTerrorPlayer["SetPredictWeapons"] <- function(value){SetProp("m_bPredictWeapons", value.tointeger())}
		CTerrorPlayer["GetPredictWeapons"] <- function(){return GetProp("m_bPredictWeapons")}

		CTerrorPlayer["SetLastDamageAmount"] <- function(value){SetProp("m_lastDamageAmount", value.tointeger())}
		CTerrorPlayer["GetLastDamageAmount"] <- function(){return GetProp("m_lastDamageAmount")}

		CTerrorPlayer["SetTimeLastHurt"] <- function(value){SetProp("m_fTimeLastHurt", value.tofloat())}
		CTerrorPlayer["GetTimeLastHurt"] <- function(){return GetProp("m_fTimeLastHurt")}

		CTerrorPlayer["SetNextDecalTime"] <- function(value){SetProp("m_flNextDecalTime", value.tofloat())}
		CTerrorPlayer["GetNextDecalTime"] <- function(){return GetProp("m_flNextDecalTime")}

		CTerrorPlayer["SetImpulse"] <- function(value){SetProp("m_nImpulse", value.tointeger())}
		CTerrorPlayer["GetImpulse"] <- function(){return GetProp("m_nImpulse")}

		CTerrorPlayer["SetLastPlayerTalkTime"] <- function(value){SetProp("m_fLastPlayerTalkTime", value.tofloat())}
		CTerrorPlayer["GetLastPlayerTalkTime"] <- function(){return GetProp("m_fLastPlayerTalkTime")}

		CTerrorPlayer["SetUnderwater"] <- function(value){SetProp("m_bPlayerUnderwater", value.tointeger())}
		CTerrorPlayer["GetUnderwater"] <- function(){return GetProp("m_bPlayerUnderwater")}

		CTerrorPlayer["SetSinglePlayerGameEnding"] <- function(value){SetProp("m_bSinglePlayerGameEnding", value.tointeger())}
		CTerrorPlayer["GetSinglePlayerGameEnding"] <- function(){return GetProp("m_bSinglePlayerGameEnding")}

		CTerrorPlayer["SetAutoKickDisabled"] <- function(value){SetProp("m_autoKickDisabled", value.tointeger())}
		CTerrorPlayer["GetAutoKickDisabled"] <- function(){return GetProp("m_autoKickDisabled")}

		CTerrorPlayer["SetNumCrouches"] <- function(value){SetProp("m_nNumCrouches", value.tointeger())}
		CTerrorPlayer["GetNumCrouches"] <- function(){return GetProp("m_nNumCrouches")}

		CTerrorPlayer["SetDuckToggled"] <- function(value){SetProp("m_bDuckToggled", value.tointeger())}
		CTerrorPlayer["GetDuckToggled"] <- function(){return GetProp("m_bDuckToggled")}

		CTerrorPlayer["SetForwardMove"] <- function(value){SetProp("m_flForwardMove", value.tofloat())}
		CTerrorPlayer["GetForwardMove"] <- function(){return GetProp("m_flForwardMove")}

		CTerrorPlayer["SetSideMove"] <- function(value){SetProp("m_flSideMove", value.tofloat())}
		CTerrorPlayer["GetSideMove"] <- function(){return GetProp("m_flSideMove")}

		CTerrorPlayer["SetLastHitGroup"] <- function(value){SetProp("m_LastHitGroup", value.tointeger())}
		CTerrorPlayer["GetLastHitGroup"] <- function(){return GetProp("m_LastHitGroup")}

		CTerrorPlayer["SetForceServerRagdoll"] <- function(value){SetProp("m_bForceServerRagdoll", value.tointeger())}
		CTerrorPlayer["GetForceServerRagdoll"] <- function(){return GetProp("m_bForceServerRagdoll")}

		CTerrorPlayer["SetPreventWeaponPickup"] <- function(value){SetProp("m_bPreventWeaponPickup", value.tointeger())}
		CTerrorPlayer["GetPreventWeaponPickup"] <- function(){return GetProp("m_bPreventWeaponPickup")}

		CTerrorPlayer["SetRenderFX"] <- function(value){SetProp("m_nRenderFX", value.tointeger())}
		CTerrorPlayer["GetRenderFX"] <- function(){return GetProp("m_nRenderFX")}

		CTerrorPlayer["SetRenderMode"] <- function(value){SetProp("m_nRenderMode", value.tointeger())}
		CTerrorPlayer["GetRenderMode"] <- function(){return GetProp("m_nRenderMode")}

		CTerrorPlayer["SetFOVRate"] <- function(value){SetProp("m_Local.m_flFOVRate", value.tofloat())}
		CTerrorPlayer["GetFOVRate"] <- function(){return GetProp("m_Local.m_flFOVRate")}

		CTerrorPlayer["SetPostProcessController"] <- function(value){SetPropEntity("m_hPostProcessCtrl", value)}
		CTerrorPlayer["GetPostProcessController"] <- function(){return GetPropEntity("m_hPostProcessCtrl")}

		CTerrorPlayer["SetColorCorrectionController"] <- function(value){SetPropEntity("m_hColorCorrectionCtrl", value)}
		CTerrorPlayer["GetColorCorrectionController"] <- function(){return GetPropEntity("m_hColorCorrectionCtrl")}

		CTerrorPlayer["SetFogController"] <- function(value){SetPropEntity("m_PlayerFog.m_hCtrl", value)}
		CTerrorPlayer["GetFogController"] <- function(){return GetPropEntity("m_PlayerFog.m_hCtrl")}

		CTerrorPlayer["SetWeapon"] <- function(value, index){SetPropEntityArray("m_hMyWeapons", value, index.tointeger())}
		CTerrorPlayer["GetWeapon"] <- function(index){return GetPropEntityArray("m_hMyWeapons", index.tointeger())}

		CTerrorPlayer["SetLadderNormal"] <- function(value){SetProp("m_vecLadderNormal", value)}
		CTerrorPlayer["GetLadderNormal"] <- function(){return GetProp("m_vecLadderNormal")}

		CTerrorPlayer["SetLastLadderNormal"] <- function(value){SetProp("m_lastLadderNormal", value)}
		CTerrorPlayer["GetLastLadderNormal"] <- function(){return GetProp("m_lastLadderNormal")}

		CTerrorPlayer["IgnoreFallDamage"] <- function(){Input("IgnoreFallDamage")}
		CTerrorPlayer["IgnoreFallDamageWithoutReset"] <- function(){Input("IgnoreFallDamageWithoutReset")}

		CTerrorPlayer["EnableLedgeHang"] <- function(){Input("EnableLedgeHang")}
		CTerrorPlayer["DisableLedgeHang"] <- function(){Input("DisableLedgeHang")}

		CTerrorPlayer["SpeakResponseConcept"] <- function(){Input("SpeakResponseConcept")}

		CTerrorPlayer["TeleportToSurvivorPosition"] <- function(){Input("TeleportToSurvivorPosition")}

		CTerrorPlayer["ReleaseFromSurvivorPosition"] <- function(){Input("ReleaseFromSurvivorPosition")}

		CTerrorPlayer["SetGlowEnabled"] <- function(){Input("SetGlowEnabled")}

		CTerrorPlayer["RemoveWeaponUpgrades"] <- function(){Input("RemoveWeaponUpgrades")}

		CTerrorPlayer["CancelCurrentScene"] <- function(){Input("CancelCurrentScene")}

		CTerrorPlayer["GetValidatedScriptScope"] <- function(){
			ValidateScriptScope()
			return GetScriptScope()
		}

		CTerrorPlayer["CommandBot"] <- function(commandTable){
			commandTable["bot"] <- this
			CommandABot(commandTable)
		}

		CTerrorPlayer["GetMoveType"] <- function(){return GetPropInt("movetype")}
		CTerrorPlayer["SetMoveType"] <- function(type){SetPropInt("movetype", type)}

		CTerrorPlayer["GetFlags"] <- function(){return GetPropInt("m_fFlags")}
		CTerrorPlayer["SetFlags"] <- function(flag){SetPropInt("m_fFlags", flag)}
		CTerrorPlayer["AddFlag"] <- function(flag){SetPropInt("m_fFlags", GetPropInt("m_fFlags") | flag)}
		CTerrorPlayer["RemoveFlag"] <- function(flag){SetPropInt("m_fFlags", GetPropInt("m_fFlags") & ~flag)}
		CTerrorPlayer["HasFlag"] <- function(flag){return GetFlags() & flag}

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

		CTerrorPlayer["GetFriction"] <- function(){return GetFriction(this)}

		CTerrorPlayer["SetTeam"] <- function(team){SetPropInt("m_iTeamNum", team.tointeger())}
		CTerrorPlayer["GetTeam"] <- function(){return GetPropInt("m_iTeamNum")}

		CTerrorPlayer["GetInterp"] <- function(){return GetPropFloat("m_fLerpTime")}

		CTerrorPlayer["GetUpdateRate"] <- function(){return GetPropInt("m_nUpdateRate")}

		CTerrorPlayer["SetModelScale"] <- function(modelScale){SetPropFloat("m_flModelScale", modelScale.tofloat())}
		CTerrorPlayer["GetModelScale"] <- function(){return GetPropFloat("m_flModelScale")}

		CTerrorPlayer["SetThirdperson"] <- function(thirdperson){SetPropFloat("m_TimeForceExternalView", thirdperson ? 2147483647 : 0)}
		CTerrorPlayer["IsInThirdperson"] <- function(){return Time() < GetPropFloat("m_TimeForceExternalView")}

		CTerrorPlayer["GetTongueVictim"] <- function(){return GetPropEntity("m_tongueVictim")}
		CTerrorPlayer["GetTongueAttacker"] <- function(){return GetPropEntity("m_tongueOwner")}
		CTerrorPlayer["GetPounceVictim"] <- function(){return GetPropEntity("m_pounceVictim")}
		CTerrorPlayer["GetPounceAttacker"] <- function(){return GetPropEntity("m_pounceAttacker")}
		CTerrorPlayer["GetLeapVictim"] <- function(){return GetPropEntity("m_jockeyVictim")}
		CTerrorPlayer["GetLeapAttacker"] <- function(){return GetPropEntity("m_jockeyAttacker")}
		CTerrorPlayer["GetChargeVictim"] <- function(){return GetPropEntity("m_pummelVictim")}
		CTerrorPlayer["GetChargeAttacker"] <- function(){return GetPropEntity("m_pummelAttacker")}
		CTerrorPlayer["GetCarryVictim"] <- function(){return GetPropEntity("m_carryVictim")}
		CTerrorPlayer["GetCarryAttacker"] <- function(){return GetPropEntity("m_carryAttacker")}

		CTerrorPlayer["AddDisabledButton"] <- function(disabledButton){SetPropInt("m_afButtonDisabled", GetPropInt("m_afButtonDisabled") | disabledButton.tointeger())}
		CTerrorPlayer["RemoveDisabledButton"] <- function(disabledButton){SetPropInt("m_afButtonDisabled", GetPropInt("m_afButtonDisabled") & ~disabledButton.tointeger())}
		CTerrorPlayer["SetDisabledButtons"] <- function(disabledButtons){SetPropInt("m_afButtonDisabled", disabledButtons.tointeger())}
		CTerrorPlayer["GetDisabledButtons"] <- function(){return GetPropInt("m_afButtonDisabled")}
		CTerrorPlayer["HasDisabledButton"] <- function(disabledButton){return GetDisabledButtons() & disabledButton}

		CTerrorPlayer["AddForcedButton"] <- function(forcedButton){SetPropInt("m_afButtonForced", GetPropInt("m_afButtonForced") | forcedButton.tointeger())}
		CTerrorPlayer["RemoveForcedButton"] <- function(forcedButton){SetPropInt("m_afButtonForced", GetPropInt("m_afButtonForced") & ~forcedButton.tointeger())}
		CTerrorPlayer["SetForcedButtons"] <- function(forcedButtons){SetPropInt("m_afButtonForced", forcedButtons.tointeger())}
		CTerrorPlayer["GetForcedButtons"] <- function(){return GetPropInt("m_afButtonForced")}
		CTerrorPlayer["HasForcedButton"] <- function(forcedButton){return GetForcedButtons() & forcedButton}

		CTerrorPlayer["SetPresentAtSurvivalStart"] <- function(presentAtSurvivalStart){SetPropInt("m_bWasPresentAtSurvivalStart", presentAtSurvivalStart.tointeger())}
		CTerrorPlayer["WasPresentAtSurvivalStart"] <- function(){return GetPropInt("m_bWasPresentAtSurvivalStart")}

		CTerrorPlayer["SetGhost"] <- function(ghost){SetPropInt("m_isGhost", ghost.tointeger())}
		CTerrorPlayer["GetGhost"] <- function(){return GetProp("m_isGhost")}

		CTerrorPlayer["SetUsingMountedGun"] <- function(usingMountedGun){SetPropInt("m_usingMountedGun", usingMountedGun.tointeger())}
		CTerrorPlayer["IsUsingMountedGun"] <- function(){return GetPropInt("m_usingMountedGun")}

		CTerrorPlayer["SetUsingMountedWeapon"] <- function(value){SetProp("m_usingMountedWeapon", value.tointeger())}
		CTerrorPlayer["GetUsingMountedWeapon"] <- function(){return GetProp("m_usingMountedWeapon")}

		CTerrorPlayer["SetFirstManOut"] <- function(value){SetProp("m_bIsFirstManOut", value.tointeger())}
		CTerrorPlayer["GetFirstManOut"] <- function(){return GetPropInt("m_bIsFirstManOut")}

		CTerrorPlayer["SetOnThirdStrike"] <- function(value){SetProp("m_bIsOnThirdStrike", value.tointeger())}
		CTerrorPlayer["GetOnThirdStrike"] <- function(){return GetProp("m_bIsOnThirdStrike")}

		CTerrorPlayer["SetReviveCount"] <- function(value){SetProp("m_currentReviveCount", value.tointeger())}
		CTerrorPlayer["GetReviveCount"] <- function(){return GetPropInt("m_currentReviveCount")}

		CTerrorPlayer["SetProneTongueDrag"] <- function(value){SetProp("m_isProneTongueDrag", value.tointeger())}
		CTerrorPlayer["GetProneTongueDrag"] <- function(){return GetPropInt("m_isProneTongueDrag")}

		CTerrorPlayer["SetReachedTongueOwner"] <- function(value){SetProp("m_reachedTongueOwner", value.tointeger())}
		CTerrorPlayer["GetReachedTongueOwner"] <- function(){return GetPropInt("m_reachedTongueOwner")}

		CTerrorPlayer["SetHangingFromTongue"] <- function(value){SetProp("m_reachedTongueOwner", value.tointeger())}
		CTerrorPlayer["GetHangingFromTongue"] <- function(){return GetPropInt("m_isHangingFromTongue")}

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

		CTerrorPlayer["SetHideHUD"] <- function(hideHUD){SetPropInt("m_Local.m_iHideHUD", hideHUD.tointeger())}
		CTerrorPlayer["AddHideHUD"] <- function(value){SetProp("m_Local.m_iHideHUD", GetProp("m_Local.m_iHideHUD") | value.tointeger())}
		CTerrorPlayer["RemoveHideHUD"] <- function(value){SetProp("m_iHideHUD", GetProp("m_Local.m_iHideHUD") & ~value.tointeger())}
		CTerrorPlayer["GetHideHUD"] <- function(){return GetPropInt("m_Local.m_iHideHUD")}
		CTerrorPlayer["HasHideHUD"] <- function(value){return GetProp("m_Local.m_iHideHUD") & value.tointeger()}

		CTerrorPlayer["SetViewmodel"] <- function(viewmodel){SetPropEntity("m_hViewModel", viewmodel)}
		CTerrorPlayer["GetViewmodel"] <- function(){return GetPropEntity("m_hViewModel")}

		CTerrorPlayer["SetZoom"] <- function(zoom){SetPropInt("m_iFOV", zoom.tointeger())}
		CTerrorPlayer["GetZoom"] <- function(){return GetPropInt("m_iFOV")}

		CTerrorPlayer["SetForcedObserverMode"] <- function(forcedObserverMode){SetPropInt("m_bForcedObserverMode", forcedObserverMode.tointeger())}
		CTerrorPlayer["GetForcedObserverMode"] <- function(){return GetPropInt("m_bForcedObserverMode")}

		CTerrorPlayer["SetObserverTarget"] <- function(observerTarget){SetPropEntity("m_hObserverTarget", observerTarget)}
		CTerrorPlayer["GetObserverTarget"] <- function(){return GetPropEntity("m_hObserverTarget")}

		CTerrorPlayer["SetObserverLastMode"] <- function(observerLastMode){SetPropInt("m_iObserverLastMode", observerLastMode.tointeger())}
		CTerrorPlayer["GetObserverLastMode"] <- function(){return GetPropInt("m_iObserverLastMode")}

		CTerrorPlayer["SetObserverMode"] <- function(observerMode){SetPropInt("m_iObserverMode", observerMode.tointeger())}
		CTerrorPlayer["GetObserverMode"] <- function(){return GetPropInt("m_iObserverMode")}

		CTerrorPlayer["SetSurvivorCharacter"] <- function(survivorCharacter){SetPropInt("m_survivorCharacter", survivorCharacter.tointeger())}
		CTerrorPlayer["GetSurvivorCharacter"] <- function(){return GetPropInt("m_survivorCharacter")}

		CTerrorPlayer["SetCalm"] <- function(value){SetProp("m_isCalm", value.tointeger())}
		CTerrorPlayer["GetCalm"] <- function(){return GetPropInt("m_isCalm")}

		CTerrorPlayer["SetCustomAbility"] <- function(customAbility){SetPropEntity("m_customAbility", customAbility)}
		CTerrorPlayer["GetCustomAbility"] <- function(){return GetPropEntity("m_customAbility")}

		CTerrorPlayer["SetSurvivorGlowEnabled"] <- function(survivorGlowEnabled){SetPropInt("m_bSurvivorGlowEnabled", survivorGlowEnabled.tointeger())}
		CTerrorPlayer["GetSurvivorGlowEnabled"] <- function(){return GetProp("m_bSurvivorGlowEnabled")}

		CTerrorPlayer["SetIntensity"] <- function(value){SetProp("m_clientIntensity", value.tointeger())}
		CTerrorPlayer["GetIntensity"] <- function(){return GetPropInt("m_clientIntensity")}

		CTerrorPlayer["SetFallingFromLedge"] <- function(value){SetProp("m_isFallingFromLedge", value.tointeger())}
		CTerrorPlayer["GetFallingFromLedge"] <- function(){return GetPropInt("m_isFallingFromLedge")}

		CTerrorPlayer["ClearJumpSuppression"] <- function(){SetPropFloat("m_jumpSupressedUntil", 0)}
		CTerrorPlayer["SuppressJump"] <- function(time){SetPropFloat("m_jumpSupressedUntil", Time() + time.tofloat())}

		CTerrorPlayer["SetMaxHealth"] <- function(maxHealth){SetPropInt("m_iMaxHealth", maxHealth.tointeger())}
		CTerrorPlayer["GetMaxHealth"] <- function(){return GetProp("m_iMaxHealth")}

		CTerrorPlayer["SetAirMovementRestricted"] <- function(airMovementRestricted){SetPropInt("m_airMovementRestricted", airMovementRestricted.tointeger())}
		CTerrorPlayer["GetAirMovementRestricted"] <- function(){return GetPropInt("m_airMovementRestricted")}

		CTerrorPlayer["GetFlowDistance"] <- function(){return GetCurrentFlowDistanceForPlayer(this)}
		CTerrorPlayer["GetFlowPercent"] <- function(){return GetCurrentFlowPercentForPlayer(this)}

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
	
	classListeners.append(ClassListener("CBaseEntity", func_CBaseEntity, {}))
	classListeners.append(ClassListener("CBaseAnimating", func_CBaseAnimating, {}))
	classListeners.append(ClassListener("CTerrorPlayer", func_CTerrorPlayer, {}))
}

/**
 * Registers a listener that will call a function when the given check function returns true
 */
function RegisterFunctionListener(checkFunction, callFunction, args, singleUse){
	local errorMessage = "Failed to register function listener"
	if(CheckType(checkFunction, VariableTypes.FUNCTION, errorMessage, "checkFunction")){
		if(CheckType(callFunction, VariableTypes.FUNCTION, errorMessage, "callFunction")){
			if(CheckType(args, VariableTypes.TABLE, errorMessage, "args")){
				if(CheckType(singleUse, VariableTypes.BOOLEAN, errorMessage, "singleUse")){
					for(local i=0; i < functionListeners.len(); i++){
						if(functionListeners[i].GetCheckFunction() == checkFunction){
							functionListeners.remove(i)
							break
						}
					}
					functionListeners.append(FunctionListener(checkFunction, callFunction, args, singleUse))
					PrintInfo("Registered function listener")
					return true
				}
			}
		}
	}
	return false
}

/**
 * Registers a custom weapon hook
 */
function RegisterCustomWeapon(viewmodel, worldmodel, script){
	local errorMessage = "Failed to register custom weapon"
	if(CheckType(viewmodel, VariableTypes.STRING, errorMessage, "viewmodel")){
		if(CheckType(worldmodel, VariableTypes.STRING, errorMessage, "worldmodel")){
			if(CheckType(script, VariableTypes.STRING, errorMessage, "script")){
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
				for(local i=0; i < customWeapons.len(); i++){
					if(customWeapons[i].GetViewmodel() == viewmodel && customWeapons[i].GetWorldModel() == worldmodel && customWeapons[i].GetScope() == scriptScope){
						customWeapons.remove(i)
						break
					}
				}
				customWeapons.append(CustomWeapon(viewmodel,worldmodel,scriptScope))
				if("OnInitialize" in scriptScope){
					scriptScope["OnInitialize"]()
				}
				PrintInfo("Registered custom weapon script " + script)
				return scriptScope
			}
		}
	}
	return false
}

/**
 * Registers various hooks
 */
function RegisterHooks(scriptScope){
	if(CheckType(scriptScope, [VariableTypes.TABLE, VariableTypes.INSTANCE], "Failed to register hooks", "scriptScope")){
		for(local i=0; i < hookScripts.len(); i++){
			if(hookScripts[i] == scriptScope){
				hookScripts.remove(i)
				break
			}
		}
		hookScripts.append(scriptScope)
		PrintInfo("Successfully registered hooks")
		return true
	}
	return false
}

/**
 * Registers a function to be called every tick in scriptScope
 */
function RegisterOnTick(scriptScope){
	if(CheckType(scriptScope, [VariableTypes.TABLE, VariableTypes.INSTANCE], "Failed to register OnTick", "scriptScope")){
		for(local i=0; i < tickScripts.len(); i++){
			if(tickScripts[i] == scriptScope){
				tickScripts.remove(i)
				break
			}
		}
		tickScripts.append(scriptScope)
		PrintInfo("Registered OnTick")
		return true
	}
	return false
}

/**
 * Registers a function to be called every tick
 */
function RegisterTickFunction(func){
	if(CheckType(func, VariableTypes.FUNCTION, "Failed to register a tick function", "func")){
		for(local i=0; i < tickFunctions.len(); i++){
			if(tickFunctions[i] == func){
				tickFunctions.remove(i)
				break
			}
		}
		tickFunctions.append(func)
		PrintInfo("Registered tick function")
		return true
	}
	return false
}

/**
 * Registers a function to be called when an entity is created
 */
function RegisterEntityCreateListener(classname, scope){
	local errorMessage = "Failed to register entity create listener"
	if(CheckType(classname, VariableTypes.STRING, errorMessage, "classname")){
		if(CheckType(scope, [VariableTypes.TABLE, VariableTypes.INSTANCE], errorMessage, "scope")){
			for(local i=0; i < entityCreateListeners.len(); i++){
				if(entityCreateListeners[i].GetClassname() == classname && entityCreateListeners[i].GetScope() == scope){
					entityCreateListeners.remove(i)
					break
				}
			}
			entityCreateListeners.append(EntityCreateListener(classname,scope))
			PrintInfo("Registered entity create listener on " + classname + " entities")
			return true
		}
	}
	return false
}

/**
 * Registers a function to be called when an entity moves
 */
function RegisterEntityMoveListener(ent, scope){
	local errorMessage = "Failed to register entity move listener"
	if(CheckType(ent, VariableTypes.INSTANCE, errorMessage, "ent")){
		if(CheckType(scope, [VariableTypes.TABLE, VariableTypes.INSTANCE], errorMessage, "scope")){
			for(local i=0; i < entityMoveListeners.len(); i++){
				if(entityMoveListeners[i].GetScope() == scope){
					entityMoveListeners.remove(i)
					break
				}
			}
			entityMoveListeners.append(EntityMoveListener(ent, scope))
			PrintInfo("Registered entity move listener on " + ent)
			return true
		}
	}
	return false
}

/**
 * Registers a timer to be updated on the HUD
 */
function RegisterTimer(hudField, time, callFunction, countDown = true, formatTime = false){
	local errorMessage = "Failed to register timer"
	if(CheckType(hudField, VariableTypes.TABLE, errorMessage, "hudField")){
		if(CheckType(time, [VariableTypes.INTEGER, VariableTypes.FLOAT], errorMessage, "time")){
			if(CheckType(callFunction, VariableTypes.FUNCTION, errorMessage, "callFunction")){
				if(CheckType(countDown, VariableTypes.BOOLEAN, errorMessage, "countDown")){
					if(CheckType(formatTime, VariableTypes.BOOLEAN, errorMessage, "formatTime")){
						for(local i=0; i < timers.len(); i++){
							if(timers[i].GetHudField() == hudField){
								timers.remove(i)
								break
							}
						}
						timers.append(Timer(hudField, time, callFunction, countDown, formatTime))
						PrintInfo("Registered hud timer")
						return true
					}
				}
			}
		}
	}
	return false
}

/**
 * Stops a registered timer
 */
function StopTimer(hudField){
	if(CheckType(hudField, VariableTypes.TABLE, "Failed to stop timer", "hudField")){
		for(local i=0; i < timers.len(); i++){
			if(timers[i].GetHudField() == hudField){
				timers.remove(i)
				PrintInfo("Stopped timer")
				return true
			}
		}
		PrintInfo("Timer already stopped")
		return false
	}
	return false
}

/**
 * Schedules a function to be called later
 */
function ScheduleTask(func, time, args = {}, timestamp = false){ // can only check every 33 milliseconds so be careful
	local errorMessage = "Failed to schedule task"
	if(CheckType(func, VariableTypes.FUNCTION, errorMessage, "func")){
		if(CheckType(time, [VariableTypes.INTEGER, VariableTypes.FLOAT], errorMessage, "time")){
			if(CheckType(args, VariableTypes.TABLE, errorMessage, "args")){
				if(CheckType(timestamp, VariableTypes.BOOLEAN, errorMessage, "timestamp")){
					if(time > 0){
						if(timestamp){
							tasks.append(Task(func, args, time))
						} else {
							tasks.append(Task(func, args, Time() + time))
						}
						PrintInfo("Registered a task to execute at " + (Time()+time))
						return true
					} else {
						PrintError("Failed to register task (Time has to be greater than 0)")
						return false
					}
				}
			}
		}
	}
	return false
}

/**
 * Schedules a function to be called next tick
 */
function DoNextTick(func, args = {}){
	local errorMessage = "Failed to schedule next tick task"
	if(CheckType(func, VariableTypes.FUNCTION, errorMessage, "func")){
		if(CheckType(args, VariableTypes.TABLE, errorMessage, "args")){
			tasks.append(Task(func, args, Time() + 0.033))
			PrintInfo("Registered a task to execute next tick")
			return true
		}
	}
	return false
}

/**
 * Registers a function to be called when a command is typed in chat
 */
function RegisterChatCommand(command, func, isInputCommand = false){
	local errorMessage = "Failed to register chat command"
	if(CheckType(command, VariableTypes.STRING, errorMessage, "command")){
		if(CheckType(func, VariableTypes.FUNCTION, errorMessage, "func")){
			if(CheckType(isInputCommand, VariableTypes.BOOLEAN, errorMessage, "isInputCommand")){
				for(local i=0; i < chatCommands.len(); i++){
					if(chatCommands[i].GetCommand() == command){
						chatCommands.remove(i)
						break
					}
				}
				chatCommands.append(ChatCommand(command, func, isInputCommand))
				PrintInfo("Registered chat command (isInput=" + isInputCommand + ", command=" + command + ")")
				return true
			}
		}
	}
	return false
}

/**
 * Registers a function to be called when a convar is changed
 */
function RegisterConvarListener(convar, convarType, scope){
	local errorMessage = "Failed to register convar listener"
	if(CheckType(convar, VariableTypes.STRING, errorMessage, "convar")){
		if(CheckType(convarType, VariableTypes.STRING, errorMessage, "convarType")){
			if(CheckType(scope, [VariableTypes.TABLE, VariableTypes.INSTANCE], errorMessage, "scope")){
				for(local i=0; i < convarListeners.len(); i++){
					if(convarListeners[i].GetConvar() == convar && convarListeners[i].GetScope() == scope){
						convarListeners.remove(i)
						break
					}
				}
				convarListeners.append(ConvarListener(convar, convarType, scope))
				PrintInfo("Registered convar listener")
				return true
			}
		}
	}
	return false
}

/**
 * Registers a function to be called when a tank rock explodes on the ground
 */
function RegisterTankRockExplodeListener(scope){
	if(CheckType(scope, [VariableTypes.TABLE, VariableTypes.INSTANCE], "Failed to register tank rock explode listener", "scope")){
		for(local i=0; i < rockExplodeListeners.len(); i++){
			if(rockExplodeListeners[i].GetScope() == scope){
				rockExplodeListeners.remove(i)
				break
			}
		}
		rockExplodeListeners.append(ThrowableExplodeListener(scope))
		PrintInfo("Registered a tank rock explode listener")
		return true
	}
	return false
}

/**
 * Registers a function to be called when a bile jar explodes on the ground
 */
function RegisterBileExplodeListener(scope){
	if(CheckType(scope, [VariableTypes.TABLE, VariableTypes.INSTANCE], "Failed to register bile explode listener", "scope")){
		for(local i=0; i < bileExplodeListeners.len(); i++){
			if(bileExplodeListeners[i].GetScope() == scope){
				bileExplodeListeners.remove(i)
				break
			}
		}
		bileExplodeListeners.append(ThrowableExplodeListener(scope))
		PrintInfo("Registered a bile explode listener")
		return true
	}
	return false
}

/**
 * Registers a function to be called when a molotov explodes on the ground
 */
function RegisterMolotovExplodeListener(scope){
	if(CheckType(scope, [VariableTypes.TABLE, VariableTypes.INSTANCE], "Failed to register molotov explode listener", "scope")){
		for(local i=0; i < molotovExplodeListeners.len(); i++){
			if(molotovExplodeListeners[i].GetScope() == scope){
				molotovExplodeListeners.remove(i)
				break
			}
		}
		molotovExplodeListeners.append(ThrowableExplodeListener(scope))
		PrintInfo("Registered a molotov explode listener")
		return true
	}
	return false
}

/**
 * Locks an entity by constantly setting its position
 */
function LockEntity(entity){
	if(CheckType(entity, VariableTypes.INSTANCE, "Failed to lock entity", "entity")){
		lockedEntities.append(LockedEntity(entity, entity.GetAngles(), entity.GetOrigin))
		PrintInfo("Locked entity: " + entity)
		return true
	}
	return false
}

/**
 * Unlocks an entity previously locked by LockEntity
 */
function UnlockEntity(entity){
	if(CheckType(entity, VariableTypes.INSTANCE, "Failed to unlock entity", "entity")){
		for(local i=0; i < lockedEntities.len(); i++){
			if(lockedEntities[i] == entity){
				lockedEntities.remove(i)
				return true
			}
		}
		return true
	}
	return false
}

/**
 * Sets the global timescale
 */
function SetTimescale(timescale, acceleration = 0.05, minBlendRate = 0.1, blendDeltaMultiplier = 3.0){
	if(CheckType(timescale, [VariableTypes.FLOAT, VariableTypes.INTEGER], "Failed to set timescale", "timescale")){
		local timescaleEnt = SpawnEntityFromTable("func_timescale", {desiredTimescale = timescale, acceleration = acceleration, minBlendRate = minBlendRate, blendDeltaMultiplier = blendDeltaMultiplier})
		
		DoEntFire("!self", "Start", "", 0, null, timescaleEnt)
		
		timescaleEnt.Kill()
		return true
	}
	return false
}

/**
 * Sends the specified command to the client's console
 */
function SendCommandToClient(client, command){
	local errorMessage = "Failed to send command to client"
	if(CheckType(client, VariableTypes.INSTANCE, errorMessage, "client")){
		if(CheckType(command, VariableTypes.STRING, errorMessage, "command")){
			DoEntFire("!self", "Command", command, 0, client, clientCommand)
			return true
		}
	}
	return false
}

/**
 * Sets the specified players' angles
 */
function SetPlayerAngles(player, angles){
	local prevPlayerName = player.GetName()
	local playerName = UniqueString()
	NetProps.SetPropString(player, "m_iName", playerName)
	local teleportEntity = SpawnEntityFromTable("point_teleport", {origin = GetOrigin(), angles = angles.ToKVString(), target = playerName, targetname = UniqueString()})
	DoEntFire("!self", "Teleport", "", 0, null, teleportEntity)
	DoEntFire("!self", "Kill", "", 0, null, teleportEntity)
	DoEntFire("!self", "AddOutput", "targetname " + prevPlayerName, 0.01, null, this)
}


function PlayerGenerator(){
	local ent = null
	while(ent = Entities.FindByClassname(ent, "player")){
		yield ent
	}
}

function SurvivorGenerator(){
	foreach(ent in PlayerGenerator()){
		if(ent.IsSurvivor()){
			yield ent
		}
	}
}

function EntitiesByClassname(classname){
	local ent = null
	while(ent = Entities.FindByClassname(ent, classname)){
		yield ent
	}
}

function EntitiesByClassnameWithin(classname, origin, radius){
	local ent = null
	while(ent = Entities.FindByClassnameWithin(ent, classname, origin, radius)){
		yield ent
	}
}

function EntitiesByModel(model){
	local ent = null
	while(ent = Entities.FindByModel(ent, model)){
		yield ent
	}
}

function EntitiesByName(name){
	local ent = null
	while(ent = Entities.FindByName(ent, name)){
		yield ent
	}
}

function EntitiesByNameWithin(name, origin, radius){
	local ent = null
	while(ent = Entities.FindByNameWithin(ent, name, origin, radius)){
		yield ent
	}
}

function EntitiesByTarget(targetname){
	local ent = null
	while(ent = Entities.FindByTarget(ent, targetname)){
		yield ent
	}
}

function EntitiesInSphere(origin, radius){
	local ent = null
	while(ent = Entities.FindInSphere(ent, origin, radius)){
		yield ent
	}
}

function EntitiesByOrder(){
	local ent = null
	while(ent = Entities.Next(ent)){
		yield ent
	}
}


function GetPlayers(){
	local entities = []
	local ent = null
	while(ent = Entities.FindByClassname(ent, "player")){
		entities.append(ent)
	}
	return entities
}

function EntitiesByClassnameAsArray(classname){
	local entities = []
	local ent = null
	while(ent = Entities.FindByClassname(ent, classname)){
		entities.append(ent)
	}
	return entities
}

function EntitiesByClassnameWithinAsArray(classname, origin, radius){
	local entities = []
	local ent = null
	while(ent = Entities.FindByClassnameWithin(ent, classname, origin, radius)){
		entities.append(ent)
	}
	return entities
}

function EntitiesByModelAsArray(model){
	local entities = []
	local ent = null
	while(ent = Entities.FindByModel(ent, model)){
		entities.append(ent)
	}
	return entities
}

function EntitiesByNameAsArray(name){
	local entities = []
	local ent = null
	while(ent = Entities.FindByName(ent, name)){
		entities.append(ent)
	}
	return entities
}

function EntitiesByNameWithinAsArray(name, origin, radius){
	local entities = []
	local ent = null
	while(ent = Entities.FindByNameWithin(ent, name, origin, radius)){
		entities.append(ent)
	}
	return entities
}

function EntitiesByTargetAsArray(targetname){
	local entities = []
	local ent = null
	while(ent = Entities.FindByTarget(ent, targetname)){
		entities.append(ent)
	}
	return entities
}

function EntitiesInSphereAsArray(origin, radius){
	local entities = []
	local ent = null
	while(ent = Entities.FindInSphere(ent, origin, radius)){
		entities.append(ent)
	}
	return entities
}

/*
	This might be expensive
*/
function EntitiesByOrderAsArray(){
	local entities = []
	local ent = null
	while(ent = Entities.Next(ent)){
		entities.append(ent)
	}
	return entities
}


function KillByClassname(classname){
	local ent = null
	while(ent = Entities.FindByClassname(ent, classname)){
		ent.Kill()
	}
}

function KillByClassnameWithin(classname, origin, radius){
	local ent = null
	while(ent = Entities.FindByClassnameWithin(ent, classname, origin, radius)){
		ent.Kill()
	}
}

function KillByModel(model){
	local ent = null
	while(ent = Entities.FindByModel(ent, model)){
		ent.Kill()
	}
}

function KillByName(name){
	local ent = null
	while(ent = Entities.FindByName(ent, name)){
		ent.Kill()
	}
}

function KillByNameWithin(name, origin, radius){
	local ent = null
	while(ent = Entities.FindByNameWithin(ent, name, origin, radius)){
		ent.Kill()
	}
}

function KillByTarget(targetname){
	local ent = null
	while(ent = Entities.FindByTarget(ent, targetname)){
		ent.Kill()
	}
}

function KillInSphere(origin, radius){
	local ent = null
	while(ent = Entities.FindInSphere(ent, origin, radius)){
		ent.Kill()
	}
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
	foreach(char in msg){
		if(char != CharacterCodes.SPACE && char != CharacterCodes.NEWLINE){
			found_start = true
			message += char.tochar().tolower()
		} else if(char == CharacterCodes.SPACE){
			found_end = true
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
	local index = 0
	foreach(char in msg){
		if(char != CharacterCodes.SPACE && char != CharacterCodes.NEWLINE){
			found_start = true
			message += char.tochar().tolower()
		} else if(char == CharacterCodes.SPACE){
			found_end = true
			if(message != command || index == msg.len() - 1){
				return false
			}
			return msg.slice(index + 1, msg.len())
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
			local input = GetInputCommand(text, command.GetCommand())
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



printl(
"*******************************************\n" +
"*          HookController loaded          *\n" +
"*         Made by Daroot Leafstorm        *\n" +
"*******************************************"
)