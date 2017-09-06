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
	
	hookcontroller = null
	playerutilities = null
}

ScriptUtils <- {
	HookController = {}
	PlayerUtilities = {}
}

const PRINT_START = "Scripting Utilities: "

setup_complete <- false
utilities <- null

::GetScriptUtilsHandles <- function(){
	return utilities
}

::SetupUtilities <- function(...){ // empty files will cause it to not include scripts
	if(!setup_complete){
		if(vargv.len() >= 1){
			if(typeof(vargv) == "array"){
				local utils = Utilities()
				foreach(string in vargv){
					if(typeof(string) == "string"){
						if(string.tolower() == "hookcontroller"){
							if(IncludeScript("Utilities/HookController.nut",ScriptUtils.HookController)){
								utils.SetHookController(ScriptUtils.HookController)
							} else {
								utils.SetHookController(null)
								printl(PRINT_START + "Could not include Hook Controller (Check that you have HookController.nut in the Utilities folder)")
							}
						}
						if(string.tolower() == "playerutilities"){
							if(IncludeScript("Utilities/PlayerUtilities.nut",ScriptUtils.PlayerUtilities)){
								utils.SetPlayerUtilities(ScriptUtils.PlayerUtilities)
							} else {
								utils.SetPlayerUtilities(null)
								printl(PRINT_START + "Could not include Player Utilities (Check that you have PlayerUtilities.nut in the Utilities folder)")
							}
						}
					} else {
						printl(PRINT_START + " WARNING: An array element in options is not a string (" + string + " : " + typeof(string) + ")")
					}
				}
				printl("Scripting Utilities loaded. (Made by Daroot Leafstorm)")
				utilities = utils
				return utils
			} else {
				printl(PRINT_START + "Failed to load Scripting Utilities (The options parameter must be an array)")
				return null
			}
		} else {
			local utils = Utilities()
			if(IncludeScript("Utilities/HookController.nut",ScriptUtils.HookController)){
				utils.SetHookController(ScriptUtils.HookController)
			} else {
				utils.SetHookController(null)
				printl(PRINT_START + "Could not include Hook Controller (Check that you have HookController.nut in the Utilities folder)")
			}
			if(IncludeScript("Utilities/PlayerUtilities.nut",ScriptUtils.PlayerUtilities)){
				utils.SetPlayerUtilities(ScriptUtils.PlayerUtilities)
			} else {
				utils.SetPlayerUtilities(null)
				printl(PRINT_START + "Could not include Player Utilities (Check that you have PlayerUtilities.nut in the Utilities folder)")
			}
			utilities = utils
			printl("Scripting Utilities loaded. (Made by Daroot Leafstorm)")
			return utils
		}
	} else {
		return null
	}
}
