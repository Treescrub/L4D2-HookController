---
title: ScriptUtils
---

# Features
ScriptUtils has many useful features for scripting, the current ones are:

- [**Hook Controller**](docs/hookcontroller.md) \- Can register custom weapons, schedule tasks, and listen for entities being created.
- [**Player Utilities**](docs/playerutilities.md) \- Functions for CTerrorPlayer entities, mostly functions for NetProp setting.
- [**NetProp Helper**](docs/netprophelper.md) \- Keeps track of changes in network properties based on commands entered in chat or in a script.

# How to Use

Download the [ZIP](https://github.com/Treescrub/ScriptUtils/archive/master.zip) and extract it into your VScripts folder.

Then include the script.
```c++
IncludeScript("ScriptUtils")
```
To set up modules and get handles.
```c++
SetupUtilities()
```
This will return a table of the module scopes.
Find documentation [here](#markdown)

### Markdown

Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
Syntax highlighted code block

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```
[![](button2.png)](http://reddit.com)
# Header 1
## Header 2
### Header 3
