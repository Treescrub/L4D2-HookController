---
title: HookController
---

# Functions

## RegisterCustomWeapon

<div class="language-c++ highlighter-rouge"><pre class="highlight"><code><span class="p"><b>RegisterCustomWeapon</b></span><span class="p">(</span><span style="color:salmon">viewmodel</span><span class="p">,</span> <span style="color:salmon">worldmodel</span><span class="p">,</span> <span style="color:salmon">script</span><span class="p">)</span>
</code></pre>
</div>
Register a custom weapon and include the weapon script.

| Parameter      | Type          | Description  |
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

| Parameter      | Type          | Description  |
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

| Parameter      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| classname | string |  Classname of the entity |
| scope | table | Scope in which callbacks will be called |
| | |
| *return* | boolean | If registering was successful |

---
## RegisterEntityMoveListener
```c++
RegisterEntityMoveListener(ent,scope)
```
Listens for a specific entity moving.

| Parameter      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| ent | entity |  Entity to listen to |
| scope | table | Scope in which callbacks will be called |
| | |
| *return* | boolean | If registering was successful |

---
## ScheduleTask
```c++
ScheduleTask(func, time, scope = null)
```
Schedules a function to execute at a specific time.

| Parameter      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| func | function *or* string |  Function to call, if it's a string scope has to not be null |
| time | integer *or* float | Server time to execute the function |
| scope | table | Scope in which function will be called (if func is a string) |
| | |
| *return* | boolean | If registering was successful |
