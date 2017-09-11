---
title: ScriptUtils
---
<var>Kappa</var>

# Classes

---

## Utilities

---

### Class Functions

```c++
GetHookController()
```
Returns the scope of a [HookController](hookcontroller.md) module.
```c++
GetPlayerUtilities()
```
Returns the scope of a [PlayerUtilities](playerutilities.md) module.

# Functions

## GetScriptUtilsHandles

```c++
GetScriptUtilsHandles()
```
Returns a [Utilities](#utilities) instance. Will not be filled out if [SetupUtilities](#setuputilities) has not been called yet.

**Example**
```c++
local hookcontroller = GetScriptUtilsHandles().GetHookController()
```

## SetupUtilities

```c++
SetupUtilities(...)
```
Takes any number of inputs.

Use no arguments to load all modules.

All arguments must be strings and are the name of the modules.

Returns a [Utilities](#utilities) instance.

**Example**
```c++
local playerutils = SetupUtilities("HookController","PlayerUtilities").GetPlayerUtilities()
```


