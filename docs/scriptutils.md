---
title: ScriptUtils
---

# Classes

---

## Utilities

---

### Class Functions

#### GetHookController
```c++
GetHookController()
```
Returns the scope of a [HookController](hookcontroller.md) module.

| Variable      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| *return* | table | Scope of the [HookController](hookcontroller.md) script |

---
#### GetPlayerUtilities
```c++
GetPlayerUtilities()
```
Returns the scope of a [PlayerUtilities](playerutilities.md) module.

| Variable      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| *return* | table | Scope of the [PlayerUtilities](playerutilities.md) script |

# Functions

## GetScriptUtilsHandles

```c++
GetScriptUtilsHandles()
```
Returns a [Utilities](#utilities) instance. Will not be filled out if [SetupUtilities](#setuputilities) has not been called yet.

| Variable      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| *return* | [Utilities](#utilities) | Utilities class containing modules |

**Example**
```c++
local hookcontroller = GetScriptUtilsHandles().GetHookController()
```

---
## SetupUtilities

```c++
SetupUtilities(...)
```
Setup the modules.

| Variable      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| ... | variable number of strings | Script names of modules to load, use no arguments to load all modules |
| *return* | [Utilities](#utilities) | Utilities instance with script scopes |

**Example**
```c++
local playerutils = SetupUtilities("HookController","PlayerUtilities").GetPlayerUtilities()
```


