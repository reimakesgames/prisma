local LerpUtil = require(script.Parent.LerpTools)
local LeftArmValue = 0.0
local RightArmValue = 0.0

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
		-- local Joint = Player.Character.Torso["Left Shoulder"]
		-- Joint.C0 = LEFT_SHOULDER_CFRAME
		-- * CFrame.Angles(0, math.rad(-90), 0)
		-- * CFrame.Angles(0, 0, -math.asin(RelativeCameraDirection.Y))
		LeftArmValue = LerpUtil:LinearInterpolate(LeftArmValue, -math.asin(RelativeCameraDirection.Y), 16)
	elseif Player.Character.Torso:FindFirstChild("Left Shoulder") then
		-- local Joint = Player.Character.Torso["Left Shoulder"]
		-- Joint.C0 = LEFT_SHOULDER_CFRAME
		-- * CFrame.Angles(0, math.rad(-90), 0)
		LeftArmValue = LerpUtil:LinearInterpolate(LeftArmValue, 0, 16)
	end

	if ArmStates[2] and Player.Character.Torso:FindFirstChild("Right Shoulder") then
		-- local Joint = Player.Character.Torso["Right Shoulder"]
		-- Joint.C0 = RIGHT_SHOULDER_CFRAME
		-- * CFrame.Angles(0, math.rad(90), 0)
		-- * CFrame.Angles(0, 0, math.asin(RelativeCameraDirection.Y))
		RightArmValue = LerpUtil:LinearInterpolate(RightArmValue, math.asin(RelativeCameraDirection.Y), 16)
	elseif Player.Character.Torso:FindFirstChild("Right Shoulder") then
		-- local Joint = Player.Character.Torso["Right Shoulder"]
		-- Joint.C0 = RIGHT_SHOULDER_CFRAME
		-- * CFrame.Angles(0, math.rad(90), 0)
		RightArmValue = LerpUtil:LinearInterpolate(RightArmValue, 0, 16)
	end

	local LeftJoint = Player.Character.Torso["Left Shoulder"]
	LeftJoint.C0 = LEFT_SHOULDER_CFRAME
	* CFrame.Angles(0, math.rad(-90), 0)
	* CFrame.Angles(0, 0, LeftArmValue)
	local RightJoint = Player.Character.Torso["Right Shoulder"]
	RightJoint.C0 = RIGHT_SHOULDER_CFRAME
	* CFrame.Angles(0, math.rad(90), 0)
	* CFrame.Angles(0, 0, RightArmValue)
end