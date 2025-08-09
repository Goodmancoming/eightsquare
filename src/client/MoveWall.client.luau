local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- Find the MovingWall part in Workspace
local movingWall = nil
local anonPoster = Workspace:WaitForChild("AnonPoster")
if anonPoster then
    movingWall = anonPoster:WaitForChild("MovingWall")
end

if not movingWall then
    warn("[MoveWallClient] MovingWall not found in Workspace.AnonPoster")
    return
end

-- Wait for the ProximityPrompt named "Feel"
local prompt = movingWall:WaitForChild("Feel")
if not prompt then
    warn("[MoveWallClient] ProximityPrompt 'Feel' not found on MovingWall")
    return
end

-- Find TargetBlock (search in AnonPoster)
local targetBlock = nil
for k, v in anonPoster:GetChildren() do
    if v.Name == "TargetBlock" and v:IsA("BasePart") then
        targetBlock = v
        break
    end
end

local function moveWall()
    print("[MoveWallClient] ProximityPrompt triggered!")
    -- Destroy the prompt so it can't be triggered again
    if prompt then
        prompt:Destroy()
    end

    -- Tween the wall to the target position or a default offset if not found
    local goal = {}
    if targetBlock then
        goal.Position = targetBlock.Position
        print("[MoveWallClient] Moving wall to TargetBlock at", targetBlock.Position)
    else
        -- Move 10 studs along X as a fallback
        goal.Position = movingWall.Position + Vector3.new(50, 0, 0)
        warn("[MoveWallClient] TargetBlock not found, moving wall by 50 studs on X axis")
    end

    local duration = 1
    if targetBlock then
		duration = (movingWall.Position - goal.Position).Magnitude / 2.5
    end

    local tweenInfo = TweenInfo.new(
        duration, -- duration based on distance, 10 studs/sec
        Enum.EasingStyle.Bounce,
        Enum.EasingDirection.In
    )
    local tween = TweenService:Create(movingWall, tweenInfo, goal)
    tween:Play()
end

prompt.Triggered:Connect(moveWall)
warn("[MoveWallClient] MoveWallClient script loaded and listening for ProximityPrompt.")

