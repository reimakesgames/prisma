local function LinearInterpolate(x: number, y: number, alpha: number)
	return x * (1 - alpha) + y * alpha
end

local VectorOne = 0
local VectorTwo = 0

return function(delta, Character, RelativeCameraDirection)
	Character.Humanoid.AutoRotate = false
	-- X axis relative camera direction
	-- Y axis for humanoid root part rotation
	-- Positive rotates it counter clockwise (for some reason)
	-- print((math.floor((RelativeCameraDirection.X) * 100)) * 0.01)
	if RelativeCameraDirection.X >= 0.8 then
		VectorOne = LinearInterpolate(VectorOne, 10 * -RelativeCameraDirection.X, 0.4 * (delta * 60))
	elseif RelativeCameraDirection.X <= -0.8 then
		VectorOne = LinearInterpolate(VectorOne, 10 * -RelativeCameraDirection.X, 0.4 * (delta * 60))
	elseif RelativeCameraDirection.X < 0.5 and RelativeCameraDirection.X > -0.5 then
		VectorOne = LinearInterpolate(VectorOne, 0, 0.4 * (delta * 60))
	end
	VectorTwo = LinearInterpolate(VectorTwo, VectorOne, 0.9 * (delta * 60))

	Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(VectorTwo), 0)
end