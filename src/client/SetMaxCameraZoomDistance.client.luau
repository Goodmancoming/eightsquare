local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Set your desired maximum camera zoom distance here
local MAX_ZOOM_DISTANCE = 20

LocalPlayer.CameraMaxZoomDistance = MAX_ZOOM_DISTANCE

-- Optional: Re-apply if changed by something else
LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
	if LocalPlayer.CameraMaxZoomDistance ~= MAX_ZOOM_DISTANCE then
		LocalPlayer.CameraMaxZoomDistance = MAX_ZOOM_DISTANCE
	end
end)

