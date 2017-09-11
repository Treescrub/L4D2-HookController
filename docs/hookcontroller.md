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

### Callback Functions
**These functions must have one of these sets of parameters: (ent,player), (ent), or no parameters.**

| Parameter      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| ent | entity | Entity handle of the custom weapon |
| player | entity | Player that pressed the key, may be null |

**List of key names**:
* Attack
* Attack2
* Crouch
* Left
* Right
* Forward
* Backward
* Use
* Reload
* Walk
* Zoom
* Jump

#### OnKeyPressX_Y

<div class="language-c++ highlighter-rouge"><pre class="highlight"><code><span class="n">OnKeyPress<b>X</b>_<b>Y</b></span><span class="p">()</span>
</code></pre>
</div>
**X** can be `Start`, `Tick`, or `End`
Called when a custom weapon entity is held and **Y** (the key name) starts being pressed, every tick while being pressed, or stopped being pressed, depending on **X**.

#### OnUnequipped

```c++
OnUnequipped()
```
Called when a custom weapon entity changes from being held to no longer being held.

#### OnEquipped

```c++
OnEquipped()
```
Called when a custom weapon entity changes from not being held to being held.

#### OnDrop

```c++
OnDrop()
```
Called when a custom weapon entity is dropped by a player.

#### OnPickup

```c++
OnPickup()
```
Called when a custom weapon entity is picked up by a player.

---
## RegisterHooks
<div class="language-c++ highlighter-rouge"><pre class="highlight"><code><span class="n"><b>RegisterHooks</b></span><span class="p">(</span><span style="color:salmon">scriptscope</span><span class="p">)</span>
</code></pre>
</div>
Register hooks to a script scope.

| Parameter      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| scriptscope | table      |  Scope in which callbacks will be called |
| | |
| *return* | boolean | If registering was successful |

### Callback Functions
**These functions must have one of these sets of parameters: (ent,player), (ent), or no parameters.**

| Parameter      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| ent | entity | Entity handle of the custom weapon |
| player | entity | Player that pressed the key, may be null |

**List of key names**:
* Attack
* Attack2
* Crouch
* Left
* Right
* Forward
* Backward
* Use
* Reload
* Walk
* Zoom
* Jump

#### OnKeyPressX_Y

<div class="language-c++ highlighter-rouge"><pre class="highlight"><code><span class="n">OnKeyPress<b>X</b>_<b>Y</b></span><span class="p">()</span>
</code></pre>
</div>
**X** can be `Start`, `Tick`, or `End`
Called when **Y** (the key name) starts being pressed, every tick while being pressed, or stopped being pressed by a player, depending on **X**.


---
## RegisterEntityCreateListener
<div class="language-c++ highlighter-rouge"><pre class="highlight"><code><span class="n"><b>RegisterEntityCreateListener</b></span><span class="p">(</span><span style="color:salmon">classname</span><span class="p">,</span> <span style="color:salmon">scope</span><span class="p">)</span>
</code></pre>
</div>
Listens for new entities by classname.

| Parameter      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| classname | string |  Classname of the entity |
| scope | table | Scope in which callbacks will be called |
| | |
| *return* | boolean | If registering was successful |

---
## RegisterEntityMoveListener
<div class="language-c++ highlighter-rouge"><pre class="highlight"><code><span class="n"><b>RegisterEntityMoveListener</b></span><span class="p">(</span><span style="color:salmon">ent</span><span class="p">,</span><span style="color:salmon">scope</span><span class="p">)</span>
</code></pre>
</div>
Listens for a specific entity moving.

| Parameter      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| ent | entity |  Entity to listen to |
| scope | table | Scope in which callbacks will be called |
| | |
| *return* | boolean | If registering was successful |

---
## ScheduleTask
<div class="language-c++ highlighter-rouge"><pre class="highlight"><code><span class="n"><b>ScheduleTask</b></span><span class="p">(</span><span style="color:salmon">func</span><span class="p">,</span> <span style="color:salmon">time</span><span class="p">,</span> <span style="color:salmon">scope</span> <span class="o">=</span> <span style="color:blue">null</span><span class="p">)</span>
</code></pre>
</div>
Schedules a function to execute at a specific time.

| Parameter      | Type          | Description  |
| :-----------: |:-------------:| :-----------:|
| func | function *or* string |  Function to call, if it's a string scope has to not be null |
| time | integer *or* float | Server time to execute the function |
| scope | table | Scope in which function will be called (if func is a string) |
| | |
| *return* | boolean | If registering was successful |
