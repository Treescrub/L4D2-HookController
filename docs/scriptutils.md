---
title: ScriptUtils
---

# Classes

---

## Utilities

---

### Class Functions

Returns the scope of a [HookController](hookcontroller.md) module.
```c++
GetHookController()
```
| Variable      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| *return* | table | Scope of the [HookController](hookcontroller.md) script |

Returns the scope of a [PlayerUtilities](playerutilities.md) module.
```c++
GetPlayerUtilities()
```
| Variable      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| *return* | table | Scope of the [PlayerUtilities](playerutilities.md) script |

# Functions

## GetScriptUtilsHandles

Returns a [Utilities](#utilities) instance. Will not be filled out if [SetupUtilities](#setuputilities) has not been called yet.
```c++
GetScriptUtilsHandles()
```
| Variable      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| *return* | [Utilities](#utilities) | Utilities class containing modules |

**Example**
```c++
local hookcontroller = GetScriptUtilsHandles().GetHookController()
```

## SetupUtilities

```c++
SetupUtilities(...)
```
| Variable      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| ... | variable number of strings | Script names of modules to load, use no arguments to load all modules |
| *return* | [Utilities](#utilities) | Utilities instance with script scopes |

**Example**
```c++
local playerutils = SetupUtilities("HookController","PlayerUtilities").GetPlayerUtilities()
```


