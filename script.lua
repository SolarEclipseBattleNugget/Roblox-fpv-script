local speedM = 5

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
--local target = game.Workspace:WaitForChild("Part")

local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local humanoid = chr:WaitForChild("Humanoid")
local rootP = chr:WaitForChild("HumanoidRootPart")

local target = Instance.new("Part")
target.Parent = game.Workspace
target.Anchored = true
target.Size = Vector3.new(2, 1, 2)
target.Position = rootP.CFrame.Position + Vector3.new(0, 5, -10)
target.Name = "Part"
target.Anchored = false
local targetV = target.AssemblyLinearVelocity

local Camera = workspace:WaitForChild("Camera")
task.wait(2)
Camera.CameraType = Enum.CameraType.Scriptable

RunService.Heartbeat:Connect(function()
	Camera.CFrame = target.CFrame
end)



local DEADZONE = 0.1

local leftStick = Vector2.zero
local rightStick = Vector2.zero

local function raycast(origin, direction, ignoreList)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = ignoreList or {}
	params.IgnoreWater = true

	return workspace:Raycast(origin, direction, params)
end

-- Applies a circular deadzone and rescales the remaining range
local function applyDeadzone(input, deadzone)
	local magnitude = input.Magnitude

	if magnitude <= deadzone then
		return Vector2.zero
	end

	-- Rescale from [deadzone, 1] -> [0, 1]
	local normalizedMagnitude = (magnitude - deadzone) / (1 - deadzone)

	return input.Unit * math.clamp(normalizedMagnitude, 0, 1)
end

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
		return
	end
print(input.KeyCode)
targetV = target.AssemblyLinearVelocity

	if input.KeyCode == Enum.KeyCode.Thumbstick1 then
		leftStick = applyDeadzone(input.Position, DEADZONE)

	elseif input.KeyCode == Enum.KeyCode.Thumbstick2 then
		rightStick = applyDeadzone(input.Position, DEADZONE)
	elseif input.KeyCode == Enum.KeyCode.ButtonL2 then
		target.Rotation = Vector3.new(0, 0, 0)
		target.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end	
end)




RunService.RenderStepped:Connect(function()
	-- Current filtered stick values
	print("Left:", leftStick, "Right:", rightStick)
	

	-- Example:
	-- local movement = Vector3.new(leftStick.X, 0, -leftStick.Y)
	-- local camera = Vector2.new(rightStick.X, rightStick.Y)
		if leftStick.Y > 0.2 then
		target.AssemblyLinearVelocity = (target.CFrame.UpVector * leftStick.Y * 80) - Vector3.new(0, 50, 0)
	elseif raycast(target.Position, -target.CFrame.UpVector * 3) == nil then
		target.AssemblyLinearVelocity = Vector3.new(0, -20 + speedM * leftStick.Y, 0)
	end
	
--[[	if leftStick.X ~= 0 then
		target.AssemblyAngularVelocity = Vector3.new(0, -leftStick.X * 10, 0) 
	end
	if rightStick.Y ~= 0 then
		target.AssemblyAngularVelocity = Vector3.new(-rightStick.Y * 10, 0, 0) 
	end
	if rightStick.X ~= 0 then
		target.AssemblyAngularVelocity = Vector3.new(0, 0, -rightStick.X * 10) 
	end--]]
	
	if leftStick.X ~= 0  and leftStick.X > 0.4 or leftStick.X < -0.4 then
		target.CFrame = target.CFrame * CFrame.Angles(0, -leftStick.X / 10, 0) 
	end
	if rightStick.Y ~= 0 and rightStick.Y > 0.15 or rightStick.Y < -0.15 then
		target.CFrame = target.CFrame * CFrame.Angles(-rightStick.Y / 10, 0, 0) 
	end
	if rightStick.X ~= 0 and rightStick.X > 0.15 or rightStick.X < -0.15 then
		target.CFrame = target.CFrame * CFrame.Angles(0, 0, -rightStick.X / 10) 
	end
end)
