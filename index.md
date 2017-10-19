---
title: HookController
---

# Features
[**Hook Controller**](docs/hookcontroller.md) has many useful features for scripting:

- Register custom weapons
- Schedule tasks
- Listen for entity creation
- And more

---

# How to Use

Download the [ZIP](https://github.com/Treescrub/L4D2-HookController/archive/master.zip) and extract it into your VScripts folder.

To use in a script, include HookController in a scope.
```c++
local controller = {}
IncludeScript("HookController", controller)
```
Then, register any hooks you want.

You must also call the Start function for hooks to be called.


# Documentation

You can find the documentation [here](docs/index.md)
