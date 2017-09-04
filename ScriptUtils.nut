::Utilities <- {
	HookController = {}
	EntityUtilities = {}
}

const PRINT_START = "Scripting Utilities: "

::SetupUtilities <- function(options = null){ // empty files will cause it to not include scripts
	if(options != null){
		if(typeof(options) == "array"){
			local instances = {}
			if(options.find("HookController") != null || options.find("hookcontroller") != null){
				if(IncludeScript("Utilities/HookController.nut",Utilities.HookController)){
					instances["HookController"] <- Utilities.HookController
				} else {
					instances["HookController"] <- null
					printl(PRINT_START + "Could not include Hook Controller (Check that you have HookController.nut in the Utilities folder)")
				}
			}
			if(options.find("EntityUtilities") != null || options.find("entityutilities") != null){
				if(IncludeScript("Utilities/EntityUtilities.nut",Utilities.EntityUtilities)){
					instances["EntityUtilities"] <- Utilities.EntityUtilities
				} else {
					instances["EntityUtilities"] <- null
					printl(PRINT_START + "Could not include Entity Utilities (Check that you have EntityUtilities.nut in the Utilities folder)")
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
		if(IncludeScript("Utilities/EntityUtilities.nut",Utilities.EntityUtilities)){
			instances["EntityUtilities"] <- Utilities.EntityUtilities
		} else {
			instances["EntityUtilities"] <- null
			printl(PRINT_START + "Could not include Entity Utilities (Check that you have EntityUtilities.nut in the Utilities folder)")
		}
		return instances
		printl("Scripting Utilities loaded. (Made by Daroot Leafstorm)")
	}
}