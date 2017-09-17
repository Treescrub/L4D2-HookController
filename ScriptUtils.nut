class Utilities{
	function GetHookController(){
		return hookcontroller
	}
	
	function SetHookController(handle){
		hookcontroller = handle
	}
	
	function GetPlayerUtilities(){
		return playerutilities
	}
	
	function SetPlayerUtilities(handle){
		playerutilities = handle
	}
	
	function SetNetPropHelper(handle){
		netprophelper = handle
	}
	
	function GetNetPropHelper(){
		return netprophelper
	}
	
	netprophelper = null
	hookcontroller = null
	playerutilities = null
}

::ScriptUtils <- {
	SetupComplete = false
	UtilitiesInstance = null
	HookController = {}
	PlayerUtilities = {}
	NetPropHelper = {}
}

const PRINT_START = "Scripting Utilities: "

::GetScriptUtilsHandles <- function(){
	return ScriptUtils.UtilitiesInstance
}

::SetupUtilities <- function(...){ // empty files will cause it to not include scripts
	if(!ScriptUtils.SetupComplete){
		if(vargv.len() >= 1){
			if(typeof(vargv) == "array"){
				local utils = Utilities()
				foreach(string in vargv){
					if(typeof(string) == "string"){
						if(string.tolower() == "hookcontroller"){
							local included = IncludeScript("Utilities/HookController.nut",ScriptUtils.HookController)
							if(included){
								utils.SetHookController(ScriptUtils.HookController)
							} else {
								utils.SetHookController(null)
								printl(PRINT_START + "Could not include Hook Controller (Check that you have HookController.nut in the Utilities folder)")
							}
						}
						if(string.tolower() == "playerutilities"){
							local included = IncludeScript("Utilities/PlayerUtilities.nut",ScriptUtils.PlayerUtilities)
							if(included){
								utils.SetPlayerUtilities(ScriptUtils.PlayerUtilities)
							} else {
								utils.SetPlayerUtilities(null)
								printl(PRINT_START + "Could not include Player Utilities (Check that you have PlayerUtilities.nut in the Utilities folder)")
							}
						}
						if(string.tolower() == "netprophelper"){
							local included = IncludeScript("Utilities/NetPropHelper.nut",ScriptUtils.NetPropHelper)
							if(included){
								utils.SetNetPropHelper(ScriptUtils.NetPropHelper)
							} else {
								utils.SetNetPropHelper(null)
								printl(PRINT_START + "Could not include Player Utilities (Check that you have PlayerUtilities.nut in the Utilities folder)")
							}
						}
					} else {
						printl(PRINT_START + " WARNING: An array element in options is not a string (" + string + " : " + typeof(string) + ")")
					}
				}
				printl("Scripting Utilities loaded. (Made by Daroot Leafstorm)")
				ScriptUtils.UtilitiesInstance = utils
				return utils
			} else {
				printl(PRINT_START + "Failed to load Scripting Utilities (The options parameter must be an array)")
				return null
			}
		} else {
			local utils = Utilities()
			local included = IncludeScript("Utilities/HookController.nut",ScriptUtils.HookController)
			if(included){
				utils.SetHookController(ScriptUtils.HookController)
			} else {
				utils.SetHookController(null)
				printl(PRINT_START + "Could not include Hook Controller (Check that you have HookController.nut in the Utilities folder)")
			}
			
			included = IncludeScript("Utilities/PlayerUtilities.nut",ScriptUtils.PlayerUtilities)
			if(included){
				utils.SetPlayerUtilities(ScriptUtils.PlayerUtilities)
			} else {
				utils.SetPlayerUtilities(null)
				printl(PRINT_START + "Could not include Player Utilities (Check that you have PlayerUtilities.nut in the Utilities folder)")
			}
			
			included = IncludeScript("Utilities/NetPropHelper.nut",ScriptUtils.NetPropHelper)
			if(included){
				utils.SetNetPropHelper(ScriptUtils.NetPropHelper)
			} else {
				utils.SetNetPropHelper(null)
				printl(PRINT_START + "Could not include Player Utilities (Check that you have PlayerUtilities.nut in the Utilities folder)")
			}
			ScriptUtils.UtilitiesInstance = utils
			printl("Scripting Utilities loaded. (Made by Daroot Leafstorm)")
			return utils
		}
	} else {
		return null
	}
}