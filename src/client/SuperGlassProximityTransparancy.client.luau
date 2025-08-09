local Workspace = game:GetService("Workspace")
local part = Workspace:WaitForChild("Superglass")
local tweenservvice = game:GetService("TweenService")

local prompt = part:FindFirstChildOfClass("ProximityPrompt")
if not prompt then
	prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = ""
	prompt.ObjectText = ""
	prompt.HoldDuration = 1
	prompt.Parent = part
	prompt.KeyboardKeyCode = Enum.KeyCode.Eight
end

local hasActivated = false

prompt.Triggered:Connect(function()
	if hasActivated then return end
	hasActivated = true
	prompt.Enabled = false

	local RunService = game:GetService("RunService")
	local duration = 12
	local startTransparency = part.Transparency
	local startReflectance = part.Reflectance
	local endTransparency = 2.5
	local endReflectance = 888
	local elapsed = 0

	while elapsed < duration do
		local dt = RunService.RenderStepped:Wait()
		elapsed = elapsed + dt
		local alpha = math.clamp(elapsed / duration, 0, 1)
		part.Transparency = startTransparency + (endTransparency - startTransparency) * alpha
		part.Reflectance = startReflectance + (endReflectance - startReflectance) * alpha
	end
	part.Transparency = endTransparency
	part.Reflectance = endReflectance
	part.CanCollide = false
	prompt.Enabled = false
end)
