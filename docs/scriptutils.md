# Classes

## Utilities

### Class Functions

```c++
GetHookController()
```
Returns the scope of a HookController module.
```c++
GetPlayerUtilities()
```
Returns the scope of a PlayerUtilities module.

# Functions

## GetScriptUtilsHandles

```c++
GetScriptUtilsHandles()
```
Returns a [Utilities](##Utilities) instance. Will not be filled out if [SetupUtilities](#SetupUtilities) has not been called yet.

**Example**
```c++
local hookcontroller = GetScriptUtilsHandles().GetHookController()
```
