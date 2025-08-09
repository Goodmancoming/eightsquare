local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Find the AnomalousChair model in Workspace
local chairModel = Workspace:WaitForChild("AnomalousChair")
if not chairModel or not chairModel:IsA("Model") then
	warn("[AnomalousChairFacePlayer] Could not find AnomalousChair model in Workspace.")
	return
end

-- Use the PrimaryPart as the reference for the "front"
local primaryPart = chairModel:WaitForChild("PrimaryPart")
if not primaryPart then
	warn("[AnomalousChairFacePlayer] AnomalousChair model has no PrimaryPart set.")
	return
end

-- Helper to check if the player is sitting on the chair
local function isPlayerSittingOnChair()
	local character = LocalPlayer.Character
	if not character then return false end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return false end
	local seatPart = humanoid.SeatPart
	if not seatPart then return false end
	-- Check if seatPart is a descendant of the chair model
	local parent = seatPart
	while parent do
		if parent == chairModel then
			return true
		end
		parent = parent.Parent
	end
	return false
end

-- Debug print to confirm script is running
print("[AnomalousChairFacePlayer] Script running. Chair found:", chairModel:GetFullName())

RunService.RenderStepped:Connect(function()
	if not chairModel.Parent then return end
	if not chairModel.PrimaryPart then return end
	local primaryCFrame = chairModel.PrimaryPart.CFrame
	local chairPos = primaryCFrame.Position

	local targetPos
	if isPlayerSittingOnChair() then
		-- Face towards (0, chairY, 0)
		targetPos = Vector3.new(0, chairPos.Y, 0)
	else
		-- Face towards the player (projected to chair's Y)
		local character = LocalPlayer.Character
		if not character then return end
		local hrp = character:WaitForChild("HumanoidRootPart")
		if not hrp then return end
		local playerPos = hrp.Position
		targetPos = Vector3.new(playerPos.X, chairPos.Y, playerPos.Z)
	end

	-- Calculate look vector
	local lookVector = (targetPos - chairPos)
	if lookVector.Magnitude < 0.01 then
		return
	end
	lookVector = lookVector.Unit

	-- Build upright CFrame at PrimaryPart's position, facing lookVector
	local up = Vector3.new(0, 1, 0)
	local newPrimaryCFrame = CFrame.lookAt(chairPos, chairPos + lookVector, up)

	-- Move the whole model so that PrimaryPart's CFrame becomes newPrimaryCFrame
	chairModel:PivotTo(newPrimaryCFrame)
end)

--[[
DIAGNOSIS:
- This script ensures the PrimaryPart's +Z ("front") faces the player or origin.
- If the chair does not visually face the player/origin, check the PrimaryPart's orientation and the Model's pivot in Studio.
- The PrimaryPart's FrontSurface (+Z) should be set to the intended "front" of the chair.
- This script rotates the entire model so that the PrimaryPart's +Z faces the target.
- The script now uses the PrimaryPart already set on the model, and does not attempt to set it.
]]

