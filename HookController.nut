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
	v1.0.5 - 2/28/20
		Separated ImprovedScripting/ImprovedMethods and renamed to MoreMethods, IncludeImprovedMethods will now try to include MoreMethods.nut for backwards compatibility
		Added GetTickRate
		Added RegisterConvar
	v1.0.4 - 11/12/19
		SetProp now supports setting entity props
	v1.0.3 - 29/11/19
		Fixed SetTimescale
		Fixed OnKeyPress hooks
	v1.0.2 - 23/10/19
		Added UpgradedAmmoLoaded and Upgrades to the Improved Methods
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
 

function void RegisterConvar(name, value) - Registers a new ConVar. Persists for host until engine is closed.

function int GetTickRate() - Get the tick rate of the server. Works by counting ticks over time, so it might be inaccurate for the first few ticks
	returns: int tickRate

function bool ImprovedMethodsIncluded() - Checks if ImprovedMethods is fully included
	returns: bool included

function void IncludeImprovedMethods() - Adds extra methods that can be called on entity handles

function bool RegisterFunctionListener(function checkFunction, function callFunction, table args, bool singleUse) - Registers a listener that waits for the checkFunction to return true
	returns: bool success
	calls: 
		callFunction()
	arguments:
		checkFunction - function called to check whether to return true or false
		callFunction - function called when checkFunction returns true
		args - table with args that checkFunction can use
		singleUse - should this listener be removed after calling callFunction
		
function bool RegisterCustomWeapon(string viewmodel, string worldmodel, string script) - Registers a custom weapon script
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

function bool RegisterHooks(table scriptScope) - Registers various misc hooks
	returns: bool success
	calls:
		OnTick() - called every tick
		OnInventoryChange(entity player, array droppedWeapons, array newWeapons) - called when a players inventory changes
		OnKeyPressStart_key(entity player, entity weapon)
		OnKeyPressTick_key(entity player, entity weapon)
		OnKeyPressEnd_key(entity player, entity weapon)
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

function bool RegisterOnTick(table scriptScope) - Registers a hook called every tick
	returns: bool success
	calls: 
		OnTick() - called every tick
	arguments:
		scriptScope - scope to call the OnTick function in

function bool RegisterTickFunction(function func) - Registers a function to be called every tick
	returns: bool success
	calls:
		func()
	arguments:
		func - function to be called every tick
		
function bool RegisterEntityCreateListener(string classname, table scope) - Registers a listener to check for entity spawning/creation
	returns: bool success
	calls:
		OnEntCreate_classname(entity ent) - called when a new entity with the specified classname is created
	arguments:
		classname - the class name to listen for spawning
		scope - scope to call the OnEntCreate_classname function in
		
function bool RegisterEntityMoveListener(entity ent, table scope) - Registers a listener to watch for movement on ent
	returns: bool success
	calls:
		OnEntityMove(entity ent) - called when the ent moves
	arguments:
		ent - entity to watch for movement
		scope - scope to call the OnEntityMove function in

function bool RegisterTimer(table hudField, float time, function callFunction, bool countDown = true, bool formatTime = false) - Registers a HUD timer
	returns: bool success
	calls:
		callFunction()
	arguments:
		hudField - hud field to use as timer
		time - time to count down or up to
		callFunction - function called when time is reached
		countDown - should count down or up
		formatTime - should format time as mm:ss
		
function bool StopTimer(table hudField) - Stops a currently running timer
	returns: bool success
	arguments:
		hudField - hud field already used as a timer
		
function bool ScheduleTask(function func, float time, table args = {}, bool timestamp = false) - Registers a task to execute in the future
	returns: bool success
	calls:
		func()
	arguments: 
		func - function to be called when time is reached
		time - time to wait (or timestamp)
		args - table with variables that can be used by func
		timestamp - interpret time as a timestamp
		
function bool DoNextTick(function func, table args = {}) - Registers a task to execute next tick
	returns: bool success
	calls:
		func()
	arguments: 
		func - function to be called when time is reached
		args - table with variables that can be used by func
	
function bool RegisterChatCommand(string command, function func, bool isInputCommand = false) - Registers a chat command
	returns: bool success
	calls:
		func(entity ent) or func(entity ent, string input)
	arguments:
		command - text to respond to
		func - function to be called when someone types the chat command
		isInputCommand - if the command should check for input after the command string

function bool RegisterConvarListener(string convar, string convarType, table|instance scope) - Registers a listener for a convar
	returns: bool success
	calls:
		OnConvarChange_convar(string|float previousValue, string|float newValue)
	arguments:
		convar - convar to watch for changes
		convarType - type of convar (string or float)
		scope - scope to call the OnConvarChange_convar function in

function bool RegisterTankRockExplodeListener(table scope) - Registers a listener for tank rocks exploding
	returns: bool success
	calls: 
		OnRockExplode(entity thrower, vector startPosition, vector position)
	arguments:
		scope - scope to call the OnRockExplode function in

function bool RegisterBileExplodeListener(table scope) - Registers a listener for biles exploding
	returns: bool success
	calls:
		OnBileExplode(entity thrower, vector startPosition, vector position)
	arguments:
		scope - scope to call the OnBileExplode function in
		
function bool RegisterMolotovExplodeListener(table scope) - Registers a listener for molotovs exploding
	returns: bool success
	calls:
		OnMolotovExplode(entity thrower, vector startPosition, vector position)
	arguments:
		scope - scope to call the OnMolotovExplode function in

function bool LockEntity(entity ent) - Locks an entity by constantly setting its origin
	returns: bool success
	arguments:
		ent - entity to lock
		
function bool LockEntity(entity ent) - Unlocks an entity previously locked by LockEntity
	returns: bool success
	arguments:
		ent - entity to unlock

function bool SetTimescale(float timescale) - Sets global timescale
	returns: bool success
	arguments:
		timescale - desired timescale
		
function bool SendCommandToClient(entity client, string command) - Sends the command to the client's console
	returns: bool success
	arguments:
		client - client to send command to
		command - command to send to client's console
		
function void SetPlayerAngles(entity player, qangle angles) - Sets the players' view angles
	arguments:
		player - player to set view angles of
		angles - angles to set the player's view to

function entity PlayerGenerator() - Generator function that returns players
	returns: entity player
	
function entity EntitiesByClassname(string classname) - Generator function that returns entities by classname
	returns: entity ent
	arguments:
		classname - classname to search for
		
function entity EntitiesByClassnameWithin(string classname, vector origin, float radius) - Generator function that returns entities by classname within a radius
	returns: entity ent
	arguments:
		classname - classname to search for
		origin - position to search around
		radius - radius around origin to search
		
function entity EntitiesByModel(string model) - Generator function that returns entities by model
	returns: entity ent
	arguments:
		model - model to search for
		
function entity EntitiesByName(string name) - Generator function that returns entities by name
	returns: entity ent
	arguments:
		name - name to search for
		
function entity EntitiesByNameWithin(string name, vector origin, float radius) - Generator function that returns entities by name within
	returns: entity ent
	arguments:
		name - name to search for
		origin - position to search around
		radius - radius around origin to search

function entity EntitiesByTarget(string targetname) - Generator function that returns entities by target
	returns: entity ent
	arguments:
		targetname - name of target

function entity EntitiesInSphere(vector origin, float radius) - Generator function that returns entities in the sphere
	returns: entity ent
	arguments:
		origin - position to search around
		radius - radius around origin to search

function entity EntitiesByOrder() - Generator function that returns entities ordered by ent index
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

class ServerInfo {
	constructor(hostname, address, port, game, mapname, maxplayers, os, dedicated, password, vanilla){
		this.hostname = hostname
		this.address = address
		this.port = port
		this.game = game
		this.mapname = mapname
		this.maxplayers = maxplayers
		this.os = os
		this.dedicated = dedicated
		this.password = password
		this.vanilla = vanilla
	}
	
	function GetHostName(){
		return hostname
	}
	
	function GetAddress(){
		return address
	}
	
	function GetPort(){
		return port
	}
	
	function GetGame(){
		return game
	}
	
	function GetMapName(){
		return mapname
	}
	
	function GetMaxPlayers(){
		return maxplayers
	}
	
	function GetOS(){
		return os
	}
	
	function IsDedicated(){
		return dedicated
	}
	
	function HasPassword(){
		return password
	}
	
	function IsVanilla(){
		return vanilla
	}
	
	hostname = null
	address = null
	port = null
	game = null
	mapname = null
	maxplayers = null
	os = null
	dedicated = null
	password = null
	vanilla = null
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
local tickCount = 0
local tickRateMeasureStart = -1
local serverInfo = null

// This initializes the timer responsible for the calls to the Think function
local timer = SpawnEntityFromTable("logic_timer", {RefireTime = 0})
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
local function GetPlayers(){
	local array = []
	local ent = null
	while (ent = Entities.FindByClassname(ent, "player")){
		if(ent.IsValid()){
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
	if(NetProps.GetPropInt(player.GetEntity(), "m_nButtons") & keyId){
		if(player.GetHeldButtonsMask() & keyId){
			/*foreach(script in hookScripts){
				CallFunction(script, "OnKeyPressTick_" + keyName, player.GetEntity().GetActiveWeapon(), player.GetEntity())
			}*/
			CallFunction(scope, "OnKeyPressTick_" + keyName, player.GetEntity().GetActiveWeapon(), player.GetEntity())
		} else {
			player.SetHeldButtonsMask(player.GetHeldButtonsMask() | keyId)
			/*foreach(script in hookScripts){
				CallFunction(script, "OnKeyPressStart_" + keyName, player.GetEntity().GetActiveWeapon(), player.GetEntity())
			}*/
			CallFunction(scope, "OnKeyPressStart_" + keyName, player.GetEntity().GetActiveWeapon(), player.GetEntity())
		}
	} else if(player.GetHeldButtonsMask() & keyId){
		player.SetHeldButtonsMask(player.GetHeldButtonsMask() & ~keyId)
		/*foreach(script in hookScripts){
			CallFunction(script, "OnKeyPressEnd_" + keyName, player.GetEntity().GetActiveWeapon(), player.GetEntity())
		}*/
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
	if(tickRateMeasureStart == -1){
		tickRateMeasureStart = Time()
	}
	tickCount++
	if(improvedMethodsFinished || !improvedMethodsStarted){
		foreach(ent in GetPlayers()){
			local found = false
			for(local i=0; i<players.len();i++){
				local player = players[i]
				if(player.GetEntity() != null && player.GetEntity().IsValid()){
					if(ent.GetPlayerUserId() == player.GetEntity().GetPlayerUserId()){
						found = true
					}
					
					if((NetProps.GetPropEntity(ent, "m_tongueOwner") && (NetProps.GetPropInt(ent, "m_isHangingFromTongue") || NetProps.GetPropInt(ent, "m_reachedTongueOwner") || Time() >= NetProps.GetPropFloat(ent, "m_tongueVictimTimer") + 1)) || NetProps.GetPropEntity(ent, "m_jockeyAttacker") || NetProps.GetPropEntity(ent, "m_pounceAttacker") || (NetProps.GetPropEntity(ent, "m_pummelAttacker") || NetProps.GetPropEntity(ent, "m_carryAttacker"))){
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
				players.append(PlayerInfo(ent))
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
			local temp = tasks[i]
			
			tasks.remove(i)
			i -= 1
			
			//try{
				temp.CallFunction()
			//} catch(e){
				//printl(e)
			//}
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


/**
 * Returns the ServerInfo class
 */
function GetServerInfo(){
	return serverInfo
}

/**
 * Get the tick rate of the server. Works by counting ticks over time, so it might be inaccurate for the first few ticks
 */
function GetTickRate(){
	return (tickCount / (Time() - tickRateMeasureStart)).tointeger()
}

/**
 * Registers a new ConVar. Persists for host until engine is closed.
 */
function RegisterConvar(name, value){
	SendToServerConsole("setinfo " + name + " \"" + value + "\"")
}

function ImprovedMethodsIncluded(){
	return improvedMethodsFinished
}

/**
 * Adds various useful methods to common classes such as CBaseEntity and CTerrorPlayer
 */
function IncludeImprovedMethods(){
	if(!IncludeScript("MoreMethods")){
		IncludeScript("ImprovedScripting")
	}
	
	improvedMethodsFinished = true
	
	/*classListeners.append(ClassListener("CBaseEntity", func_CBaseEntity, {}))
	classListeners.append(ClassListener("CBaseAnimating", func_CBaseAnimating, {}))
	classListeners.append(ClassListener("CTerrorPlayer", func_CTerrorPlayer, {}))*/
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
		
		DoEntFire("!self", "Kill", "", 0.001, null, timescaleEnt)
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
	local teleportEntity = SpawnEntityFromTable("point_teleport", {origin = player.GetOrigin(), angles = angles.ToKVString(), target = playerName, targetname = UniqueString()})
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

function OnGameEvent_server_spawn(params){
	/*
		"hostname"	"string"	// public host name
		"address"	"string"	// hostame, IP or DNS name	
		"port"		"short"		// server port
		"game"		"string"	// game dir 
		"mapname"	"string"	// map name
		"maxplayers"	"long"		// max players
		"os"		"string"	// WIN32, LINUX
		"dedicated"	"bool"		// true if dedicated server
		"password"	"bool"		// true if password protected
		"vanilla"	"bool"		// vanilla server doesn't allow custom content on the clients
	*/
	
	serverInfo = ServerInfo(params.hostname, params.address, params.port, params.game, params.mapname, params.maxplayers, params.os, params.dedicated, params.password, params.vanilla)
}

__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)



printl(
"*******************************************\n" +
"*          HookController loaded          *\n" +
"*         Made by Daroot Leafstorm        *\n" +
"*******************************************"
)