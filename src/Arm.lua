local LEFT_SHOULDER_CFRAME = CFrame.new(
	-1, 0.5, 0
	-- 0, 0, -1,
	-- 0, 1, 0,
	-- 1, 0, 0
)

local RIGHT_SHOULDER_CFRAME = CFrame.new(
	1, 0.5, 0
	-- 0, 0, 1,
	-- 0, 1, -0,
	-- -1, 0, 0
)

return function(ArmStates: Array<boolean>, Player, RelativeCameraDirection: CFrame)
	if ArmStates[1] and Player.Character.Torso:FindFirstChild("Left Shoulder") then
		local Joint = Player.Character.Torso["Left Shoulder"]
		Joint.C0 = LEFT_SHOULDER_CFRAME
		* CFrame.Angles(0, math.rad(-90), math.rad(-90))
		* CFrame.Angles(0, 0, -math.asin(RelativeCameraDirection.Y))
	elseif Player.Character.Torso:FindFirstChild("Left Shoulder") then
		local Joint = Player.Character.Torso["Left Shoulder"]
		Joint.C0 = LEFT_SHOULDER_CFRAME
		* CFrame.Angles(0, math.rad(-90), 0)
	end

	if ArmStates[2] and Player.Character.Torso:FindFirstChild("Right Shoulder") then
		local Joint = Player.Character.Torso["Right Shoulder"]
		Joint.C0 = RIGHT_SHOULDER_CFRAME
		* CFrame.Angles(0, math.rad(90), math.rad(90))
		* CFrame.Angles(0, 0, math.asin(RelativeCameraDirection.Y))
	elseif Player.Character.Torso:FindFirstChild("Right Shoulder") then
		local Joint = Player.Character.Torso["Right Shoulder"]
		Joint.C0 = RIGHT_SHOULDER_CFRAME
		* CFrame.Angles(0, math.rad(90), 0)
	end
end