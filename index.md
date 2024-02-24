---
title: HookController
---

# Features
[**Hook Controller**](docs/hookcontroller.md) has many useful features for scripting:

- Register custom weapons
- Register a function to be executed every server tick
- Register chat commands
- Register throwable explode hooks
- Schedule tasks to be executed after the given time
- Listen for entity creation
- Can add many extra methods to entities
- Set a player's view angles
- and more...

---

# How to Use

Download the [ZIP](https://github.com/Treescrub/L4D2-HookController/archive/master.zip) and extract HookController.nut to your VScripts folder.

To use in a script, include HookController in a table.
```javascript
HookController <- {}
IncludeScript("HookController", HookController)
```
Then, register any hooks you want.

# Documentation

You can find the documentation [here](docs/hookcontroller.md)
