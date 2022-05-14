if workspace:FindFirstChild("CatwareReanim") then
	Notification(false,"Catware Reanimate", "Already Reanimated. Reset to Unreanimate.")
	return
end

local function Align(Part0,Part1,Position,Orientation)
    local AlignPosition = Instance.new("AlignPosition")
    AlignPosition.Parent = Part0
    AlignPosition.MaxForce = 13e5
    AlignPosition.Responsiveness = 200
    
    local AlignOrientation = Instance.new("AlignOrientation")
    AlignOrientation.Parent = Part0
    AlignOrientation.MaxTorque = 9e9
    AlignOrientation.Responsiveness = 200

    local Attachment1 = Instance.new("Attachment")
    Attachment1.Parent = Part0
    Attachment1.Position = Position or Vector3.new(0,0,0)
    Attachment1.Orientation = Orientation or Vector3.new(0,0,0)

    local Attachment2 = Instance.new("Attachment")
    Attachment2.Parent = Part1

    AlignPosition.Attachment0 = Attachment1
    AlignPosition.Attachment1 = Attachment2
    
	local AlignPosition2 = Instance.new("AlignPosition")
	AlignPosition2.Parent = Part0
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
	--warn("Catware Reanimation Config: "..Text)
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
	wait(0.1)
	if syn then
		ConsoleLog("Synapse Found! Waiting 2 Additional Seconds")
		wait(2)
	end
	ConsoleLog("Preloaded R6 Dummy (game.ReplicatedStorage.R6FakeRig)")
end
local Assets = Storage:FindFirstChild("CatwarePreloadData")
local function Notification(HappyOrNo,First,Second)
	spawn(function()
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

local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local SimRadius,HiddenProps,FlingPart
local Loops = {}
if not syn then
	ConsoleLog("Executor Isn't Synapse! Enabling Network Functions")
	SimRadius = setsimulationradius or set_simulaiton_radius or function() end
	HiddenProps = sethiddenproperty or set_hidden_property or function() end
else
	ConsoleLog("Executor Is Synapse! Disabling Network Functions")
	SimRadius = function() end
	HiddenProps = function() end
end

if Options.BonusProperties == true then
	settings().Physics.AllowSleep = false
	settings().Physics.ForceCSGv2 = false
	settings().Physics.DisableCSGv2 = true
	settings().Physics.UseCSGv2 = false
	settings().Rendering.EagerBulkExecution = true
	settings().Physics.ThrottleAdjustTime = math.huge
	settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
	HiddenProps(workspace,"HumanoidOnlySetCollisionsOnStateChange", Enum.HumanoidOnlySetCollisionsOnStateChange.Disabled)
	HiddenProps(workspace, 'InterpolationThrottling', Enum.InterpolationThrottlingMode.Disabled)
	Players.LocalPlayer.ReplicationFocus = workspace
end

local Character = Players.LocalPlayer["Character"]
getgenv().OriginalCharacter = Character
Character.Archivable = true
Character.Animate.Disabled = true
if Options.Type == "Raw" then
	FlingPart = nil
elseif Options.Type == "Fling" then
	FlingPart = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
elseif Options.Type == "Bullet" then
	FlingPart = Character:FindFirstChild("Left Leg") or Character:FindFirstChild("LeftUpperArm")
end

local CharacterG = Character:GetChildren()
local CharacterD = Character:GetDescendants()
pcall(function()
	Character:FindFirstChild("Local Ragdoll"):Destroy()
	Character:FindFirstChild("State Handler"):Destroy()
	Character:FindFirstChild("Controls"):Destroy()
	Character:FindFirstChild("FirstPerson"):Destroy()
	Character:FindFirstChild("Sound"):Destroy()
	Character:FindFirstChild("FakeAdmin"):Destroy()
	for Index,RagdollStuff in pairs(CharacterD) do
		if RagdollStuff:IsA("BallSocketConstraint") or RagdollStuff:IsA("HingeConstraint") then
			RagdollStuff:Destroy()
		end
	end
end)
local FakeHats = Instance.new("Folder", Character)
FakeHats.Name = "HatsSave"
for Index,Accessory in pairs(CharacterG) do
	if Accessory:IsA("Accessory") then
		local NewAccessories = Accessory:Clone()
		NewAccessories.Parent = FakeHats
		NewAccessories.Handle.Transparency = 1
	end
end
local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
local HumanoidTracks = Humanoid:GetPlayingAnimationTracks()
local Mouse = game.Players.LocalPlayer:GetMouse()
local Clone = Assets:FindFirstChild("R6FakeRig"):Clone()
Clone.Name = "CatwareReanim"
Clone.Parent = workspace
Clone.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame
local CloneHumanoid = Clone:FindFirstChildOfClass("Humanoid")
local CloneG = Clone:GetChildren()
local CloneD = Clone:GetDescendants()
for Index,Part in pairs(CloneD) do
	if Part:IsA("BasePart") then 
		Part.Transparency = 1
	elseif Part:IsA("Decal") then
		Part.Transparency = 1
	end
end
getgenv().ReanimationClone = Clone
if Humanoid.RigType == Enum.HumanoidRigType.R6 then
Character.HumanoidRootPart:Destroy()
end

local BP = nil
if Options.Type == "Bullet" then
	getgenv().Disconnect = false
		spawn(function() wait(1.5)
			if Options.InstantBullet == true then
			getgenv().Disconnect = true
			Humanoid:ChangeState(16)
			FlingPart:ClearAllChildren() 
			BP = Instance.new("BodyPosition")
			local Thrust = Instance.new("BodyThrust")
			BP.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
			BP.P = 22500
			BP.D = 125
			BP.Parent = FlingPart
			Thrust.Force = Vector3.new(125,125,125)
			Thrust.Parent = FlingPart
			local OnHold = false
			table.insert(Loops,Mouse.Button1Down:Connect(function()
				 OnHold = true
			end))
			table.insert(Loops,Mouse.Button1Up:Connect(function()
				 OnHold = false
			end))
			table.insert(Loops,RunService.Heartbeat:Connect(function()
				if OnHold then
					if Mouse.Target ~= nil then
						BP.Position = Mouse.Hit.p
						Thrust.Location = Mouse.Hit.p
					end
				else
					BP.Position = Character.Head.Position + Vector3.new(0,-10,0)
					Thrust.Location = Mouse.Hit.p + Character.Head.Position + Vector3.new(0,-10,0)
				end
			end))
			end	
			if Humanoid.RigType == Enum.HumanoidRigType.R6 then
				pcall(function() Character:FindFirstChild("Pal Hair").Handle:ClearAllChildren() end)
			else
				pcall(function() Character:FindFirstChild("SniperShoulderL").Handle:ClearAllChildren() end)
			end
			if Humanoid.RigType == Enum.HumanoidRigType.R6 and Options.R6Method ~= "CFrame" then
				if Character:FindFirstChild("Pal Hair") then
					Character:FindFirstChild("Pal Hair").Handle:ClearAllChildren()
					Align(Character:FindFirstChild("Pal Hair").Handle,Clone:FindFirstChild("Left Leg"),Vector3.new(0,0,0),Vector3.new(90,0,0))
				else
					ConsoleLog("Pal Hair Not Found! (Bullet)")
				end
			else
				if Character:FindFirstChild("SniperShoulderL") and Options.R15Method ~= "CFrame" then
					Character:FindFirstChild("SniperShoulderL").Handle:ClearAllChildren()
					Align(Character:FindFirstChild("SniperShoulderL").Handle,Clone:FindFirstChild("Left Arm"),Vector3.new(0,-0.5,0),Vector3.new(0,0,0))
				else
					ConsoleLog("Left Sniper Shoulder Not Found! (Bullet)")
				end
			end
	end)
end

table.insert(Loops,UserInput.JumpRequest:Connect(function()
	CloneHumanoid.Jump = true
	CloneHumanoid.Sit = false
end))
table.insert(Loops,RunService.Stepped:Connect(function()
	for Index,Part in pairs(CharacterD) do
		if Part.Parent and Part:IsA("BasePart") then
			Part.CanCollide = false 
			Part.CanQuery = false 
			Part.RootPriority = 127
		end
	end
	for Index,Part in pairs(CloneD) do
		if Part.Parent and Part:IsA("BasePart") then
			Part.CanCollide = false 
		end
	end
	CloneHumanoid:Move(Humanoid.MoveDirection, false)
	for Index,Track in pairs(HumanoidTracks) do
		Track:Stop()
	end
	if Options.BonusProperties == true then
		HiddenProps(Players.LocalPlayer, "MaximumSimulationRadius", 1000)
		HiddenProps(Players.LocalPlayer, "SimulationRadius", 1000)
		SimRadius(1000)
	end
end))

for Index,Motor6D in pairs(CharacterD) do
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


for Index,Part in pairs(CharacterD) do
	if Part:IsA("BasePart") then
		--Network(Part)
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
spawn(function()
	wait(3) Humanoid:FindFirstChildOfClass("Animator"):Destroy()
end)
table.insert(Loops,RunService.Heartbeat:Connect(function()
	for Index,Part in pairs(CharacterD) do
		if Part:IsA("BasePart") then
			if Part and Part.Parent then
				if Options.BonusProperties == true then
					if Options.Type == "Fling" and FlingPart and Part.Name ~= FlingPart.Name then
						Part.Velocity = Options.Jitteryness or Vector3.new(28.5,0,0)
					elseif Options.Type ~= "Fling" then
						Part.Velocity = Options.Jitteryness or Vector3.new(28.5,0,0)
					end
					HiddenProps(Part, "NetworkIsSleeping", false)
					Part.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
					HiddenProps(Part, "NetworkOwnershipRule", Enum.NetworkOwnership.Manual)
				end
			end
		
		elseif Part:IsA("Accessory") then
			if Part and Part:FindFirstChild("Handle") and Part.Parent then
				if Options.R6Method == "CFrame" or Options.R15Method == "CFrame" then
					local Handle = Part:FindFirstChild("Handle")
					if Handle then
						if Options.Type == "Bullet" and Part.Name ~= "Pal Hair" and Part.Name ~= "SniperShoulderL" then
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
		Character:FindFirstChild("HumanoidRootPart").CFrame = Character:FindFirstChild("UpperTorso").CFrame * CFrame.new(0,-0.05,0)
		if FlingPart then
			FlingPart.Velocity = Vector3.new(500,500,500)
		end
	end
	pcall(function()
		if Humanoid.RigType == Enum.HumanoidRigType.R6 and Options.R6Method == "CFrame" then
			Character:FindFirstChild("Torso").CFrame = Clone:FindFirstChild("Torso").CFrame
			if Options.Type == "Bullet" then
				if Character:FindFirstChild("Pal Hair") then
					Character:FindFirstChild("Pal Hair").Handle.CFrame = Clone:FindFirstChild("Left Leg").CFrame * CFrame.Angles(math.rad(90),0,0)
				else
				
				end
				if getgenv().Disconnect == false then
					Character:FindFirstChild("Left Arm").CFrame = Clone:FindFirstChild("Left Arm").CFrame
				end
			else 
				Character:FindFirstChild("Left Arm").CFrame = Clone:FindFirstChild("Left Arm").CFrame
			end
			Character:FindFirstChild("Right Arm").CFrame = Clone:FindFirstChild("Right Arm").CFrame
			Character:FindFirstChild("Left Leg").CFrame = Clone:FindFirstChild("Left Leg").CFrame
			Character:FindFirstChild("Right Leg").CFrame = Clone:FindFirstChild("Right Leg").CFrame
		elseif Humanoid.RigType == Enum.HumanoidRigType.R15 and Options.R15Method == "CFrame" then
			Character:FindFirstChild("LowerTorso").CFrame = Clone:FindFirstChild("Torso").CFrame * CFrame.new(0,-0.8,0)
			
			if Options.Type == "Bullet" then
				if Character:FindFirstChild("SniperShoulderL") then
					Character:FindFirstChild("SniperShoulderL").Handle.CFrame = Clone:FindFirstChild("Left Arm").CFrame * CFrame.new(0,0.5,0)
				else
				
				end
				if getgenv().Disconnect == false then
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
ConsoleLog("Applied Velocity: ".. tostring(Options.Jitteryness))
 
if Humanoid.RigType == Enum.HumanoidRigType.R6 and Options.R6Method ~= "CFrame" then
	Align(Character:FindFirstChild("Torso"),Clone:FindFirstChild("Torso"))
	Align(Character:FindFirstChild("Right Arm"),Clone:FindFirstChild("Right Arm"))
	Align(Character:FindFirstChild("Left Arm"),Clone:FindFirstChild("Left Arm"))
	Align(Character:FindFirstChild("Right Leg"),Clone:FindFirstChild("Right Leg"))
	Align(Character:FindFirstChild("Left Leg"),Clone:FindFirstChild("Left Leg"))
elseif Humanoid.RigType == Enum.HumanoidRigType.R15 and Options.R15Method ~= "CFrame" then
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
end
if Options.R6Method ~= "CFrame" then
	for Index,Accessory in pairs(CharacterG) do
		if Accessory:IsA("Accessory") then
			Align(Accessory.Handle,Clone[Accessory.Name].Handle)
		end
	end
end
if workspace:FindFirstChildOfClass("Camera") then
	workspace:FindFirstChildOfClass("Camera").CameraSubject = CloneHumanoid
end
game.Players.LocalPlayer.Character = Clone

table.insert(Loops,Humanoid.Died:Connect(function()
	Character.Parent = workspace
	for Index,Loop in pairs(Loops) do
		Loop:Disconnect()
	end
	getgenv().OriginalCharacter = nil
	getgenv().ReanimationClone = nil
	getgenv().Disconnect = nil
	Clone:Destroy()
	Players.LocalPlayer.Character = workspace[Players.LocalPlayer.Name]
	if workspace:FindFirstChildOfClass("Camera") then
		workspace:FindFirstChildOfClass("Camera").CameraSubject = Humanoid
	end
end))
table.insert(Loops,Players.LocalPlayer.CharacterAdded:Connect(function()
	for Index,Loop in pairs(Loops) do
		Loop:Disconnect()
	end
	getgenv().OriginalCharacter = nil
	getgenv().ReanimationClone = nil
	getgenv().Disconnect = nil
	Clone:Destroy()
end))
ConsoleLog("Everything Loaded!")

Notification(true,"Catware Reanimate", "Loaded! Credits: Gelatek,ProductionTakeOne")
loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/StrokeThePea/CatwareReanimate/main/src/Animations.lua"))()



