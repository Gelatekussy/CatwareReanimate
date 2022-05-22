local HiddenProps = sethiddenproperty or set_hidden_property or sethiddenprop or setscriptable and function(loc,prop,val) if not loc then return true end local succ,f = pcall(function() local a = loc[prop] end) if not succ then setscriptable(loc,prop,true) end loc[prop] = val end or function() return nil end
local SimRadius = setsimulationradius or set_simulation_radius or HiddenProps() and function(val) HiddenProps(Player,"SimulationRadius",val) end or function() end
local RunService = game:GetService("RunService")
local API = {}
local Players = game.Players
local CharacterDescendants = game.Players.LocalPlayer.Character:GetDescendants()
function API.Properties()
    settings().Physics.AllowSleep = false
    settings().Physics.ForceCSGv2 = false
    settings().Physics.DisableCSGv2 = true
    settings().Physics.UseCSGv2 = false
    settings().Rendering.EagerBulkExecution = true
    settings().Physics.ThrottleAdjustTime = math.huge
    settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
    HiddenProps(workspace, "HumanoidOnlySetCollisionsOnStateChange", Enum.HumanoidOnlySetCollisionsOnStateChange.Disabled)
    HiddenProps(workspace, "InterpolationThrottling", Enum.InterpolationThrottlingMode.Disabled)
    Players.LocalPlayer.ReplicationFocus = workspace
end

function API.Net()
	HiddenProps(Players.LocalPlayer, "MaximumSimulationRadius", 1000)
	HiddenProps(Players.LocalPlayer, "SimulationRadius", 1000)
	SimRadius(1000)
	for Index,Part in pairs(CharacterDescendants) do
			if Part:IsA("BasePart") then
			HiddenProps(Part, "NetworkIsSleeping", false)
			Part.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
			HiddenProps(Part, "NetworkOwnershipRule", Enum.NetworkOwnership.Manual)
		end
	end
end

return API
