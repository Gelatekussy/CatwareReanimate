
--[[
	When Forking/Modifying the reanimate please credit the me!
	We would appreciate it since this reanimate took me 8+ hours to code!
]]

if not getgenv().Options then
	getgenv().Options = {
		["Jitteryness"] = Vector3.new(30.5, 0, 0), -- Velocity
		["Type"] = "Raw", -- Raw (Simple), Fling, Bullet, Godmode
		["InstantBullet"] = {
			["Bool"] = true, -- Enables it
			["SmartLock"] = false, -- Locks Fling on Head; Disables Bullet Dragging.
		},
		["R6Method"] = "Align", -- Align,AlignMax Or CFrame
		["R15Method"] = "Align", -- Align,AlignMax Or CFrame
		["BonusProperties"] = true, -- Net, and other stuff.
		["RigAnimations"] = true, -- Enables Default Animate
		["LoadLibrary"] = false, -- Loads LoadLibrary for scripts that still use it.
		["Logging"] = true -- Enables logging (prints debug information in console)
	}
end
local Options = getgenv().Options
local Global = (getgenv and getgenv()) or _G

local function Align(Part0, Part1, Position, Orientation)
	local AlignPosition = Instance.new("AlignPosition")
	AlignPosition.Parent = Part0
	AlignPosition.MaxForce = 13e5
	AlignPosition.Responsiveness = 200
	AlignPosition.Name = "CatwareAP1"

	local AlignOrientation = Instance.new("AlignOrientation")
	AlignOrientation.Parent = Part0
	AlignOrientation.MaxTorque = 9e9
	AlignOrientation.Responsiveness = 200
	AlignOrientation.Name = "CatwareAO"

	local Attachment1 = Instance.new("Attachment")
	Attachment1.Parent = Part0
	Attachment1.Position = Position or Vector3.new(0,0,0)
	Attachment1.Orientation = Orientation or Vector3.new(0,0,0)
	Attachment1.Name = "CatwareAtt1"

	local Attachment2 = Instance.new("Attachment")
	Attachment2.Parent = Part1
	Attachment2.Name = "CatwareAtt2"

	AlignPosition.Attachment0 = Attachment1
	AlignPosition.Attachment1 = Attachment2

	local AlignPosition2 = Instance.new("AlignPosition")
	AlignPosition2.Parent = Part0
	AlignPosition2.Name = "CatwareAP2"

	if Options.R6Method == "AlignMax" or Options.R15Method == "AlignMax" then
		AlignPosition2.RigidityEnabled = true
	else
		AlignPosition2.RigidityEnabled = false
		AlignPosition2.MaxForce = 13e5
		AlignPosition2.Responsiveness = 200
	end

	AlignPosition2.Attachment0 = Attachment1
	AlignPosition2.Attachment1 = Attachment2
	AlignOrientation.Attachment0 = Attachment1
	AlignOrientation.Attachment1 = Attachment2
end

local function ConsoleLog(Text)
	if Options.Logging == true then
		warn("[Catware Reanimation] "..Text)
	end
end

local Storage = game:GetService("ReplicatedStorage")

if not Storage:FindFirstChild("CatwarePreloadData") then
	local Folder = Instance.new("Folder", Storage)
	Folder.Name = "CatwarePreloadData"

	local AudioNo = Instance.new("Sound", Folder)
	AudioNo.Name = "False"
	AudioNo.SoundId = "rbxassetid://1843027392"
	AudioNo:Stop()

	local AudioYes = Instance.new("Sound", Folder)
	AudioYes.Name = "True"
	AudioYes.SoundId = "rbxassetid://12221967"
	AudioYes:Stop()

	local R6FakeRig = game:GetObjects("rbxassetid://8440552086")[1]
	R6FakeRig.Name = "R6FakeRig"
	R6FakeRig.Parent = Folder

	task.wait(0.1)

	if syn then
		ConsoleLog("Synapse Found! Waiting 2 Additional Seconds")
		task.wait(2)
	end

	ConsoleLog("Preloaded R6 Dummy (game.ReplicatedStorage.R6FakeRig)")
end

local NetApi = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/StrokeThePea/CatwareReanimate/main/src/API.lua"))()
local Assets = Storage:FindFirstChild("CatwarePreloadData")

local function Notification(HappyOrNo, First, Second)
	task.spawn(function()
		if HappyOrNo == true then
			Assets.True:Play()
		elseif HappyOrNo == false then
			Assets.False:Play()
		end
	end)

	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = First,
		Text = Second,
	})
end

if workspace:FindFirstChild("CatwareReanim") then
	Notification(false, "Catware Reanimate", "Already Reanimated. Reset to Unreanimate.")
	return
end

local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local FlingPart
local HiddenProps = sethiddenproperty or set_hidden_property or sethiddenprop or setscriptable and function(loc,prop,val) if not loc then return true end local succ,f = pcall(function() local a = loc[prop] end) if not succ then setscriptable(loc,prop,true) end loc[prop] = val end or function() return nil end
local SimRadius = setsimulationradius or set_simulation_radius or HiddenProps() and function(val) HiddenProps(Player,"SimulationRadius",val) end or function() end
local Loops = {}

if Options.BonusProperties == true then
	pcall(function()
        NetApi.Properties()
	end)
end

local Character = workspace[Player.Name]
Global.OriginalCharacter = Character
Character.Archivable = true
Character.Animate.Disabled = true

local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
local HumanoidTracks = Humanoid:GetPlayingAnimationTracks()
local Mouse = game.Players.LocalPlayer:GetMouse()
local CharacterG = Character:GetChildren()
local CharacterD = Character:GetDescendants()
--local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")

if Options.Type == "Raw" then
	FlingPart = nil
elseif Options.Type == "Fling" then
	FlingPart = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
elseif Options.Type == "Bullet" then
	FlingPart = Character:FindFirstChild("Left Leg") or Character:FindFirstChild("LeftUpperArm")
elseif Options.Type == "Godmode" then
	if Humanoid.RigType == Enum.HumanoidRigType.R6 then
		FlingPart = Character:FindFirstChild("HumanoidRootPart")
	elseif Humanoid.RigType == Enum.HumanoidRigType.R15 then
		FlingPart = Character:FindFirstChild("LeftUpperArm") 
	end
end

pcall(function()
	Character:FindFirstChild("Local Ragdoll"):Destroy()
	Character:FindFirstChild("State Handler"):Destroy()
	Character:FindFirstChild("Controls"):Destroy()
	Character:FindFirstChild("FirstPerson"):Destroy()
	Character:FindFirstChild("FakeAdmin"):Destroy()

	for Index, RagdollStuff in pairs(CharacterD) do
		if RagdollStuff:IsA("BallSocketConstraint") or RagdollStuff:IsA("HingeConstraint") then
			RagdollStuff:Destroy()
		end
	end
end)

local FakeHats = Instance.new("Folder", Character)
FakeHats.Name = "HatsSave"

for Index, Accessory in pairs(CharacterG) do
	if Accessory:IsA("Accessory") then
		local NewAccessories = Accessory:Clone()
		NewAccessories.Parent = FakeHats
		NewAccessories.Handle.Transparency = 1
	end
end

local Clone = Assets:FindFirstChild("R6FakeRig"):Clone()
Clone.Name = "CatwareReanim"
Clone.Parent = workspace
Clone.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame

local CloneHumanoid = Clone:FindFirstChildOfClass("Humanoid")
local CloneG = Clone:GetChildren()
local CloneD = Clone:GetDescendants()

CloneHumanoid.BreakJointsOnDeath = false

for Index, Part in pairs(CloneD) do
	if Part:IsA("BasePart") or Part:IsA("Decal") then
		Part.Transparency = 1
	end
end

Global.ReanimationClone = Clone

if Humanoid.RigType == Enum.HumanoidRigType.R6 and Options.Type ~= "Godmode" then
	Character.HumanoidRootPart:Destroy()
end

local BP = nil

if Options.Type == "Bullet" or Options.Type == "Godmode" then
	Global.Disconnect = false
	
	task.spawn(function() 
		if Options.Type == "Bullet" then 
			task.wait(1)
		elseif Options.Type == "Godmode" then
			task.wait(6)
		end

		if Options.InstantBullet.Bool == true then
			Global.Disconnect = true
			Humanoid:ChangeState(16)
			FlingPart.Transparency = 1
			FlingPart:ClearAllChildren()

			local HighLight = Instance.new("SelectionBox")
			HighLight.Adornee = FlingPart
			HighLight.Parent = FlingPart 
			HighLight.LineThickness = 0.05

			BP = Instance.new("BodyPosition")
			local Thrust = Instance.new("BodyThrust")
			BP.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
			BP.P = 22500
			BP.D = 125
			BP.Position = FlingPart.Position
			BP.Parent = FlingPart
			Thrust.Force = Vector3.new(130,130,130)

			if Options.Type == "Godmode" then
				Thrust.Force = Vector3.new(150,150,150)
			end

			Thrust.Parent = FlingPart
			local OnHold = false

			table.insert(Loops, Mouse.Button1Down:Connect(function()
				OnHold = true
			end))

			table.insert(Loops, Mouse.Button1Up:Connect(function()
				OnHold = false
			end))

			table.insert(Loops, RunService.Heartbeat:Connect(function()
				pcall(function()
				if Options.InstantBullet.SmartLock == false then
					if OnHold then
						if Mouse.Target ~= nil then
							BP.Position = Mouse.Hit.p
							Thrust.Location = Mouse.Hit.p
						end
					else
						BP.Position = Character.Head.Position + Vector3.new(0,-10,0)
						Thrust.Location = Character.Head.Position + Vector3.new(0,-10,0)
					end
				else -- HEREEE

					if OnHold then
						if game.Players:GetPlayerFromCharacter(Mouse.Target.Parent) then
							if Mouse.Target.Parent.Name ~= Players.LocalPlayer.Name then
								if Mouse.Target ~= nil then
									Thrust.Location = Mouse.Target.Parent:FindFirstChild("Head").CFrame.p + Vector3.new(0,-2,0)
									BP.Position = Mouse.Target.Parent:FindFirstChild("Head").CFrame.p + Vector3.new(0,-2,0)
								end
							end
						elseif game.Players:GetPlayerFromCharacter(Mouse.Target.Parent.Parent) then
							if Mouse.Target.Parent.Parent.Name ~= Players.LocalPlayer.Name then
								if Mouse.Target ~= nil then
									Thrust.Location = Mouse.Target.Parent.Parent:FindFirstChild("Head").CFrame.p + Vector3.new(0,-2,0)
									BP.Position = Mouse.Target.Parent.Parent:FindFirstChild("Head").CFrame.p + Vector3.new(0,-2,0)
								end
							end
						end
					else
						BP.Position = Character.Head.Position + Vector3.new(0,-10,0)
						Thrust.Location = Character.Head.Position + Vector3.new(0,-10,0)
					end -- end the smart flign thing
				end -- end of the onhold statement
			end)
			
			end)) -- end of the loop

		end	-- end of the instantbullet stastment
	end)

	if Humanoid.RigType == Enum.HumanoidRigType.R6 and Options.R6Method ~= "CFrame" and Options.Type == "Bullet" then
		if Character:FindFirstChild("Pal Hair") then
			Character:FindFirstChild("Pal Hair").Handle:ClearAllChildren()
			Align(Character:FindFirstChild("Pal Hair").Handle, Clone:FindFirstChild("Left Leg"), Vector3.new(0,0,0), Vector3.new(90,0,0))
		else
			ConsoleLog("Pal Hair Not Found! (Bullet)")
		end
	end
	if Humanoid.RigType == Enum.HumanoidRigType.R15 and Options.R15Method ~= "CFrame" then
		if Character:FindFirstChild("SniperShoulderL") then
			Character:FindFirstChild("SniperShoulderL").Handle:ClearAllChildren()
			Align(Character:FindFirstChild("SniperShoulderL").Handle, Clone:FindFirstChild("Left Arm"), Vector3.new(0,-0.5,0), Vector3.new(0,0,0))
		else
			ConsoleLog("Left Sniper Shoulder Not Found! (Bullet)")
		end
	end
end

table.insert(Loops, UserInput.JumpRequest:Connect(function()
	CloneHumanoid.Jump = true
	CloneHumanoid.Sit = false
end))

table.insert(Loops, RunService.Stepped:Connect(function()
	for Index, Part in pairs(CharacterD) do
		if Part.Parent and Part:IsA("BasePart") then
			Part.CanCollide = false
			Part.CanQuery = false
			Part.RootPriority = 127
		end
	end

	for Index, Part in pairs(CloneD) do
		if Part.Parent and Part:IsA("BasePart") then
			Part.CanCollide = false
		end
	end

	CloneHumanoid:Move(Humanoid.MoveDirection, false)
	if Options.BonusProperties == true then
		NetApi.Net()
	end
	for Index, Track in pairs(HumanoidTracks) do
		Track:Stop()
	end
end))



for Index, Motor6D in pairs(CharacterD) do
	if Motor6D:IsA("Motor6D") and Motor6D.Name ~= "Neck" then
		Motor6D:Destroy()
	end
end

local function ReCreateAccessoryWelds(Accessory)
	if not Accessory:IsA("Accessory") then return end

	local Handle = Accessory:FindFirstChild("Handle")
	pcall(function() Handle:FindFirstChild("AccessoryWeld"):Destroy() end)

	local NewWeld = Instance.new("Weld")
	NewWeld.Parent = Accessory.Handle
	NewWeld.Name = "AccessoryWeld"
	NewWeld.Part0 = Handle

	local Attachment = Handle:FindFirstChildOfClass("Attachment")

	if Attachment then
		NewWeld.C0 = Attachment.CFrame
		NewWeld.C1 = Clone:FindFirstChild(tostring(Attachment), true).CFrame
		NewWeld.Part1 = Clone:FindFirstChild(tostring(Attachment), true).Parent
	else
		NewWeld.Part1 = Clone:FindFirstChild("Head")
		NewWeld.C1 = CFrame.new(0,Clone:FindFirstChild("Head").Size.Y / 2,0) * Accessory.AttachmentPoint:Inverse()
	end

	Handle.CFrame = NewWeld.Part1.CFrame * NewWeld.C1 * NewWeld.C0:Inverse()
end


for Index, Part in pairs(CharacterD) do
	if Part:IsA("BasePart") then
		-- Network(Part)
	end

	if Part:IsA("Accessory") then
		local NewAccessories = Part:Clone()
		NewAccessories.Parent = Clone
		NewAccessories.Handle.Transparency = 1

		ReCreateAccessoryWelds(NewAccessories)
		Part.Handle:BreakJoints()
	end
end

Character.Parent = Clone

table.insert(Loops, RunService.Heartbeat:Connect(function()
	for Index, Part in pairs(CharacterD) do
		if Part:IsA("BasePart") then
			if Part and Part.Parent then
                if Options.Type == "Fling" and FlingPart and Part.Name ~= FlingPart.Name then
                    Part.Velocity = Options.Jitteryness or Vector3.new(28.5,0,0) + Clone:FindFirstChild("Torso").CFrame.LookVector * 10
                elseif Options.Type ~= "Fling" then
                    Part.Velocity = Options.Jitteryness or Vector3.new(28.5,0,0) + Clone:FindFirstChild("Torso").CFrame.LookVector * 10
                end
			end
		elseif Part:IsA("Accessory") then
			if Part and Part:FindFirstChild("Handle") and Part.Parent then
				if Options.R6Method == "CFrame" or Options.R15Method == "CFrame" then
					local Handle = Part:FindFirstChild("Handle")

					if Handle then
						if Options.Type == "Bullet" and Part.Name ~= "Pal Hair" and Humanoid.RigType == Enum.HumanoidRigType.R6  then
							Handle.CFrame = Clone:FindFirstChild(Handle.Parent.Name).Handle.CFrame
						elseif Options.Type == "Bullet" and Part.Name ~= "SniperShoulderL" and Humanoid.RigType == Enum.HumanoidRigType.R15 then
							Handle.CFrame = Clone:FindFirstChild(Handle.Parent.Name).Handle.CFrame
						elseif Options.Type ~= "Bullet" then
							Handle.CFrame = Clone:FindFirstChild(Handle.Parent.Name).Handle.CFrame
						end
					end
				end
			end
		end
	end

	if Humanoid.RigType == Enum.HumanoidRigType.R6 and Options.R6Method ~= "CFrame" then
		if Options.Type == "Fling" then
			Character:FindFirstChild("Torso").CFrame = Clone:FindFirstChild("Torso").CFrame

			if FlingPart then
				FlingPart.Velocity = Vector3.new(1200,1200,1200)
			end
		end
	elseif Humanoid.RigType == Enum.HumanoidRigType.R15 then
		Character:FindFirstChild("UpperTorso").CFrame = Clone:FindFirstChild("Torso").CFrame * CFrame.new(0,0.19,0)
		Character:FindFirstChild("HumanoidRootPart").CFrame = Character:FindFirstChild("UpperTorso").CFrame * CFrame.new(0,-0.02,0)		
		if FlingPart then
			FlingPart.Velocity = Vector3.new(100,100,100)
			FlingPart.RotVelocity = Vector3.new(1000,1000,1000)
		end
	end

	pcall(function()
		if Humanoid.RigType == Enum.HumanoidRigType.R6 and Options.R6Method == "CFrame" then
			Character:FindFirstChild("Torso").CFrame = Clone:FindFirstChild("Torso").CFrame

			if Options.Type == "Godmode" then
					if Global.Disconnect == false then
						Character:FindFirstChild("HumanoidRootPart").CFrame = Clone:FindFirstChild("HumanoidRootPart").CFrame
					end
				Character:FindFirstChild("Head").CFrame = Clone:FindFirstChild("Head").CFrame
			end

			if Options.Type == "Bullet" then -- bullet check
				if Character:FindFirstChild("Pal Hair") then -- hat detect
					Character:FindFirstChild("Pal Hair").Handle.CFrame = Clone:FindFirstChild("Left Leg").CFrame * CFrame.Angles(math.rad(90),0,0)
				end

				if Global.Disconnect == false then -- disconnectio
					Character:FindFirstChild("Left Leg").CFrame = Clone:FindFirstChild("Left Leg").CFrame
				end
			else -- if no bullet then 
				Character:FindFirstChild("Left Leg").CFrame = Clone:FindFirstChild("Left Leg").CFrame
			end

			Character:FindFirstChild("Left Arm").CFrame = Clone:FindFirstChild("Left Arm").CFrame
			Character:FindFirstChild("Right Arm").CFrame = Clone:FindFirstChild("Right Arm").CFrame
			Character:FindFirstChild("Right Leg").CFrame = Clone:FindFirstChild("Right Leg").CFrame
		elseif Humanoid.RigType == Enum.HumanoidRigType.R15 and Options.R15Method == "CFrame" then
			Character:FindFirstChild("LowerTorso").CFrame = Clone:FindFirstChild("Torso").CFrame * CFrame.new(0,-0.8,0)

			if Options.Type == "Godmode" then
				Character:FindFirstChild("Head").CFrame = Clone:FindFirstChild("Head").CFrame
			end

			if Options.Type == "Bullet" or Options.Type == "Godmode" then
					if Character:FindFirstChild("SniperShoulderL") then
						Character:FindFirstChild("SniperShoulderL").Handle.CFrame = Clone:FindFirstChild("Left Arm").CFrame * CFrame.new(0,0.5,0)
					end

					if Global.Disconnect == false then
						Character:FindFirstChild("LeftUpperArm").CFrame = Clone:FindFirstChild("Left Arm").CFrame * CFrame.new(0,0.4,0)
					end
			else
				Character:FindFirstChild("LeftUpperArm").CFrame = Clone:FindFirstChild("Left Arm").CFrame * CFrame.new(0,0.4,0)
			end

			Character:FindFirstChild("LeftLowerArm").CFrame = Clone:FindFirstChild("Left Arm").CFrame * CFrame.new(0,-0.18,0)
			Character:FindFirstChild("LeftHand").CFrame = Clone:FindFirstChild("Left Arm").CFrame * CFrame.new(0,-0.82,0)

			Character:FindFirstChild("RightUpperArm").CFrame = Clone:FindFirstChild("Right Arm").CFrame * CFrame.new(0,0.4,0)
			Character:FindFirstChild("RightLowerArm").CFrame = Clone:FindFirstChild("Right Arm").CFrame * CFrame.new(0,-0.18,0)
			Character:FindFirstChild("RightHand").CFrame = Clone:FindFirstChild("Right Arm").CFrame * CFrame.new(0,-0.82,0)

			Character:FindFirstChild("LeftUpperLeg").CFrame = Clone:FindFirstChild("Left Leg").CFrame * CFrame.new(0,0.59,0)
			Character:FindFirstChild("LeftLowerLeg").CFrame = Clone:FindFirstChild("Left Leg").CFrame * CFrame.new(0,-0.16,0)
			Character:FindFirstChild("LeftFoot").CFrame = Clone:FindFirstChild("Left Leg").CFrame * CFrame.new(0,-0.85,0)

			Character:FindFirstChild("RightUpperLeg").CFrame = Clone:FindFirstChild("Right Leg").CFrame * CFrame.new(0,0.59,0)
			Character:FindFirstChild("RightLowerLeg").CFrame = Clone:FindFirstChild("Right Leg").CFrame * CFrame.new(0,-0.16,0)
			Character:FindFirstChild("RightFoot").CFrame = Clone:FindFirstChild("Right Leg").CFrame * CFrame.new(0,-0.85,0)
		end
	end)
end))

ConsoleLog("Applied Velocity: "..tostring(Options.Jitteryness))

if Humanoid.RigType == Enum.HumanoidRigType.R6 and Options.R6Method ~= "CFrame" then
	if Options.Type == "Godmode" then
		Align(Character:FindFirstChild("Head"),Clone:FindFirstChild("Head"))
		Align(Character:FindFirstChild("HumanoidRootPart"),Clone:FindFirstChild("HumanoidRootPart"))
	end

	Align(Character:FindFirstChild("Torso"), Clone:FindFirstChild("Torso"))
	Align(Character:FindFirstChild("Right Arm"), Clone:FindFirstChild("Right Arm"))
	Align(Character:FindFirstChild("Left Arm"), Clone:FindFirstChild("Left Arm"))
	Align(Character:FindFirstChild("Right Leg"), Clone:FindFirstChild("Right Leg"))
	Align(Character:FindFirstChild("Left Leg"), Clone:FindFirstChild("Left Leg"))
elseif Humanoid.RigType == Enum.HumanoidRigType.R15 and Options.R15Method ~= "CFrame" then
	Character:FindFirstChild("HumanoidRootPart").Anchored = true

	if Options.Type == "Godmode" then
		Align(Character:FindFirstChild("Head"),Clone:FindFirstChild("Head"))
	end

	Align(Character:FindFirstChild("LowerTorso"),Clone:FindFirstChild("Torso"),Vector3.new(0,0.8,0))
	Align(Character:FindFirstChild("RightUpperArm"),Clone:FindFirstChild("Right Arm"),Vector3.new(0,-0.4,0))
	Align(Character:FindFirstChild("RightLowerArm"),Clone:FindFirstChild("Right Arm"),Vector3.new(0,0.2-0.015,0))
	Align(Character:FindFirstChild("RightHand"),Clone:FindFirstChild("Right Arm"),Vector3.new(0,0.85,0))

	Align(Character:FindFirstChild("LeftUpperArm"),Clone:FindFirstChild("Left Arm"),Vector3.new(0,-0.4,0))
	Align(Character:FindFirstChild("LeftLowerArm"),Clone:FindFirstChild("Left Arm"),Vector3.new(0,0.2-0.015,0))
	Align(Character:FindFirstChild("LeftHand"),Clone:FindFirstChild("Left Arm"),Vector3.new(0,0.85,0))

	Align(Character:FindFirstChild("RightUpperLeg"),Clone:FindFirstChild("Right Leg"),Vector3.new(0,-0.5,0))
	Align(Character:FindFirstChild("RightLowerLeg"),Clone:FindFirstChild("Right Leg"),Vector3.new(0,0.2,0))
	Align(Character:FindFirstChild("RightFoot"),Clone:FindFirstChild("Right Leg"),Vector3.new(0,0.85,0))

	Align(Character:FindFirstChild("LeftUpperLeg"),Clone:FindFirstChild("Left Leg"),Vector3.new(0,-0.5,0))
	Align(Character:FindFirstChild("LeftLowerLeg"),Clone:FindFirstChild("Left Leg"),Vector3.new(0,0.2,0))
	Align(Character:FindFirstChild("LeftFoot"),Clone:FindFirstChild("Left Leg"),Vector3.new(0,0.85,0))

	task.wait()
	Character:FindFirstChild("HumanoidRootPart").Anchored = false
end

if Options.R6Method ~= "CFrame" then
	for Index, Accessory in pairs(CharacterG) do
		if Accessory:IsA("Accessory") then
			Align(Accessory.Handle, Clone[Accessory.Name].Handle)
		end
	end
end

if workspace:FindFirstChildOfClass("Camera") then
	workspace:FindFirstChildOfClass("Camera").CameraSubject = CloneHumanoid
end

game.Players.LocalPlayer.Character = Clone

if Options.Type ~= "Godmode" then
	table.insert(Loops, Humanoid.Died:Connect(function()
		Character.Parent = workspace

		for Index, Loop in pairs(Loops) do
			Loop:Disconnect()
		end

		Global.OriginalCharacter = nil
		Global.ReanimationClone = nil
		Global.Disconnect = nil
		Clone:Destroy()
		Players.LocalPlayer.Character = workspace[Players.LocalPlayer.Name]

		if workspace:FindFirstChildOfClass("Camera") then
			workspace:FindFirstChildOfClass("Camera").CameraSubject = Humanoid
		end
	end))
else
	task.spawn(function()
		game:GetService("StarterGui"):SetCore("ResetButtonCallback", false)
		task.wait(Players.RespawnTime + game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 750)

		local Neck = Character:FindFirstChild("Neck",true)

		if Neck then
			Neck.Parent = nil
		end

		game:GetService("StarterGui"):SetCore("ResetButtonCallback", true)

		local Bind = Instance.new("BindableEvent")
		Bind.Parent = Character

		task.wait(0.15)

		Bind.Event:Connect(function()
			Character.Parent = workspace

			for Index, Loop in pairs(Loops) do
				Loop:Disconnect()
			end

			Global.OriginalCharacter = nil
			Global.ReanimationClone = nil
			Global.Disconnect = nil
			Clone:Destroy()
			Players.LocalPlayer.Character = workspace[Players.LocalPlayer.Name]

			if workspace:FindFirstChildOfClass("Camera") then
				workspace:FindFirstChildOfClass("Camera").CameraSubject = Humanoid
			end

			game:GetService("StarterGui"):SetCore("ResetButtonCallback", true)
		end)

		game:GetService("StarterGui"):SetCore("ResetButtonCallback", Bind)
	end)
end

table.insert(Loops, Players.LocalPlayer.CharacterAdded:Connect(function()
	for Index, Loop in pairs(Loops) do
		Loop:Disconnect()
	end

	Global.OriginalCharacter = nil
	Global.ReanimationClone = nil
	Global.Disconnect = nil

	Clone:Destroy()
end))

ConsoleLog("Everything is loaded!")

Notification(true, "Catware Reanimate", "Loaded! Credits: Gelatek, ProductionTakeOne, Danix")
warn("Made By: Gelatek, ProductionTakeOne, Danix [Version 1.3]")

if Options.LoadLibrary == true then
	loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/StrokeThePea/CatwareReanimate/main/src/LoadLibrary.lua"))()
end
if Options.RigAnimations == true then
	loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/StrokeThePea/CatwareReanimate/main/src/Animations.lua"))()
end
