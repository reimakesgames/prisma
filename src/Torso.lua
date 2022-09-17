local function LinearInterpolate(x: number, y: number, alpha: number)
	return x * (1 - alpha) + y * alpha
end

local VectorOne = 0
local VectorTwo = 0

local VO = 0
local VT = 0

return function(delta, Character, RelativeCameraDirection)
	Character.Humanoid.AutoRotate = false
	-- X axis relative camera direction
	-- Y axis for humanoid root part rotation
	-- Positive rotates it counter clockwise (for some reason)
	-- print((math.floor((RelativeCameraDirection.X) * 100)) * 0.01)
	-- print(180 + math.deg(math.atan2(Character.Humanoid.MoveDirection.Z, Character.Humanoid.MoveDirection.X)))

	-- !TODO: add strafing tilt
	-- local RelativeMovementDirection = Character.HumanoidRootPart.CFrame:ToObjectSpace(CFrame.new(Character.Humanoid.MoveDirection)).LookVector

	if Character.Humanoid.MoveDirection.Magnitude >= 0.5 then
		-- if RelativeMovementDirection.X >= 0.8 then
			-- VO = LinearInterpolate(VO, -45, 0.4 * (delta * 60))
		-- elseif RelativeMovementDirection.X <= -0.8 then
			-- VO = LinearInterpolate(VO, 45, 0.4 * (delta * 60))
		-- else
			VO = LinearInterpolate(VO, 10 * -RelativeCameraDirection.X, 0.4 * (delta * 60))
		-- end
		VT = LinearInterpolate(VT, VO, 0.9 * (delta * 60))
	else
		VT = LinearInterpolate(VT, 0, 0.4 * (delta * 60))
	end

	if RelativeCameraDirection.X >= 0.8 then
		VectorOne = LinearInterpolate(VectorOne, 10 * -RelativeCameraDirection.X, 0.4 * (delta * 60))
	elseif RelativeCameraDirection.X <= -0.8 then
		VectorOne = LinearInterpolate(VectorOne, 10 * -RelativeCameraDirection.X, 0.4 * (delta * 60))
	elseif RelativeCameraDirection.X < 0.5 and RelativeCameraDirection.X > -0.5 then
		VectorOne = LinearInterpolate(VectorOne, 0, 0.4 * (delta * 60))
	end
	VectorTwo = LinearInterpolate(VectorTwo, VectorOne, 0.9 * (delta * 60))

	-- Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(-90), 0)
	Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(VectorTwo) + math.rad(VT), 0)
end