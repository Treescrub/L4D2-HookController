---
title: HookController
---

# Functions

## RegisterCustomWeapon

```c++
RegisterCustomWeapon(viewmodel, worldmodel, script)
```
Register a custom weapon and include the weapon script.

| Variable      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| viewmodel     | string        | Full path of the custom weapon's viewmodel |
| worldmodel    | string        | Full path of the custom weapon's worldmodel |
| script | string      |  Path of the custom weapon's script |
| | |
| *return* | boolean | If registering was successful |

---
## RegisterHooks
```c++
RegisterHooks(scriptscope)
```
Register hooks to a script scope.

| Variable      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| scriptscope | table      |  Scope in which callbacks will be called |
| | |
| *return* | boolean | If registering was successful |

---
## RegisterEntityCreateListener
```c++
RegisterEntityCreateListener(classname, scope)
```
Listens for new entities by classname.

| Variable      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| classname | string |  Classname of the entity |
| scope | table | Scope in which callbacks will be called |
| | |
| *return* | boolean | If registering was successful |
