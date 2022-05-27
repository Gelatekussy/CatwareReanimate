![Catware](https://user-images.githubusercontent.com/76650942/168428908-67cb7955-2322-4f50-ad09-5837290ca456.jpg)
Amazing reanimate created by amazing people!


This Reanimation Has:
- CFrame Reanimation
- Align Reanimation
- R15/R6 Support
- Jitterless
- R15 To R6
- Simple, Fling Bullet, Godmode Options
- Stable
- Doesn't use a lot of RAM
- Optimized
- Preloads Assets so no more getobjects lagspikes!
- Automatically gets your Clone on scripts! (no need to change character variable!)
- Built-In Bullet Setting

# Code
```lua
getgenv().Options = {
	["Jitteryness"] = Vector3.new(30.5,0,0), -- Velocity
	["Jitterless"] = true, -- Very Small Jitter, Smaller Delay
	["Type"] = "Raw", -- Raw (Simple), Fling, Bullet, Godmode
	["InstantBullet"] = {
		["Bool"] = true, -- Enables it
		["SmartLock"] = true -- Locks Bullet On Head On Hold; Disables "Bullet Follow Pointer" Thingy on hold.
	}, -- Type has to be Bullet/Godmode
	["R15Method"] = "Align", -- Align,AlignMax Or CFrame
	["R6Method"] = "Align", -- Align,AlignMax Or CFrame
	["BonusProperties"] = true, -- Net, and other stuff.
	["RigAnimations"] = true, -- Enables Default Animate
	["LoadLibrary"] = false, -- Loads LoadLibrary for scripts that still use it.
	["Logging"] = false -- Enables logging (prints debug information in console)
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/StrokeThePea/CatwareReanimate/main/src/Source.lua"))()
```

  # Can I use it in my hub/scripts?
    - Of course! That's what is the reanimation for! No need to credit since the main script automatically prints credits.
  # What exploits are supported?
    - Scriptware (100%)
    - Synapse
    - Krnl
    - Fluxus
    - Oxygen U
    - Comet
    - And many more!
    
   # What are the hats for Bullet?
    - R15: https://www.roblox.com/catalog/5973840187/Left-Sniper-Shoulder (50 Robux)
    - R6: https://www.roblox.com/catalog/63690008/Pal-Hair (Free)
   # Lead Devs:
	- Gelatek: Almost Everything
	- ProductionTakeOne: Optimizations/Special Properties/Help with Godmode
 	- Danix: Code Cleaning and replacing old functions.
    # Contributions/Help:
	- MyWorld: Jitterless
