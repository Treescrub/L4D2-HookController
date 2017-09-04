::Utilities <- {
	HookController = {}
	PlayerUtilities = {}
}

const PRINT_START = "Scripting Utilities: "

::SetupUtilities <- function(options = null){ // empty files will cause it to not include scripts
	if(options != null){
		if(typeof(options) == "array"){
			foreach(string in options){
				local instances = {}
				if(typeof(string) == "string"){
					if(string.tolower() == "hookcontroller"){
						if(IncludeScript("Utilities/HookController.nut",Utilities.HookController)){
							instances["HookController"] <- Utilities.HookController
						} else {
							instances["HookController"] <- null
							printl(PRINT_START + "Could not include Hook Controller (Check that you have HookController.nut in the Utilities folder)")
						}
					}
					if(string.tolower() == "playerutilities"){
						if(IncludeScript("Utilities/PlayerUtilities.nut",Utilities.PlayerUtilities)){
							instances["PlayerUtilities"] <- Utilities.PlayerUtilities
						} else {
							instances["PlayerUtilities"] <- null
							printl(PRINT_START + "Could not include Player Utilities (Check that you have PlayerUtilities.nut in the Utilities folder)")
						}
					}
				} else {
					printl(PRINT_START + " WARNING: An array element in options is not a string (" + string + " : " + typeof(string) + ")")
				}
			}
			return instances
			printl("Scripting Utilities loaded. (Made by Daroot Leafstorm)")
		} else {
			printl(PRINT_START + "Failed to load Scripting Utilities (The options parameter must be an array)")
			return null
		}
	} else {
		local instances = {}
		if(IncludeScript("Utilities/HookController.nut",Utilities.HookController)){
			instances["HookController"] <- Utilities.HookController
		} else {
			instances["HookController"] <- null
			printl(PRINT_START + "Could not include Hook Controller (Check that you have HookController.nut in the Utilities folder)")
		}
		if(IncludeScript("Utilities/PlayerUtilities.nut",Utilities.PlayerUtilities)){
			instances["PlayerUtilities"] <- Utilities.PlayerUtilities
		} else {
			instances["PlayerUtilities"] <- null
			printl(PRINT_START + "Could not include Player Utilities (Check that you have PlayerUtilities.nut in the Utilities folder)")
		}
		return instances
		printl("Scripting Utilities loaded. (Made by Daroot Leafstorm)")
	}
}