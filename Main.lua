Options = {
	["Jitteryness"] = Vector3.new(30.5,0,0), -- Velocity
	["Type"] = "Godmode", -- Raw (Simple), Fling, Bullet, Godmode
	["InstantBullet"] = {
		["Bool"] = true, -- Enables it
		["SmartLock"] = true -- Locks Bullet On Head
	}, -- Type has to be Bullet/Godmode
	["R15Method"] = "Align", -- Align,AlignMax Or CFrame
	["R6Method"] = "Align", -- Align,AlignMax Or CFrame
	["BonusProperties"] = true, -- Net, and other stuff.
	["RigAnimations"] = true, -- Enables Default Animate
	["LoadLibrary"] = false -- Loads LoadLibrary for scripts that still use it.
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/StrokeThePea/CatwareReanimate/main/src/Source.lua"))()
