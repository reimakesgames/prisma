-- what??? why the heck is this here
local function ArcTan(x, y)
	local r = math.atan(y / x)
	if x < 0 then
		r = r + math.pi
	end
	return r
end

return function(Character, ToggleLegRotation, RelativeMovementDirection)
	local LeftHip = Character.Torso["Left Hip"]
	local RightHip = Character.Torso["Right Hip"]
	if not ToggleLegRotation and RelativeMovementDirection.Position.Magnitude > 0 then
		local LeftAngle = ArcTan(RelativeMovementDirection.x, -RelativeMovementDirection.z)
		local RightAngle = math.pi - ArcTan(RelativeMovementDirection.x, RelativeMovementDirection.z)
		LeftHip.C1 = CFrame.new(0, 1, 0)*CFrame.Angles(0, LeftAngle+math.pi, 0)
		RightHip.C1 = CFrame.new(0, 1, 0)*CFrame.Angles(0, RightAngle+math.pi, 0)
		LeftHip.C0 = CFrame.new(-0.5, -1, 0)*CFrame.Angles(0, LeftAngle-math.pi, 0)
		RightHip.C0 = CFrame.new(0.5, -1, 0)*CFrame.Angles(0, RightAngle-math.pi, 0)
	else
		LeftHip.C1 = CFrame.new(0, 1, 0)*CFrame.Angles(0, -(math.pi / 2), 0)
		RightHip.C1 = CFrame.new(0, 1, 0)*CFrame.Angles(0, (math.pi / 2), 0)
		LeftHip.C0 = CFrame.new(-0.5, -1, 0)*CFrame.Angles(0, -(math.pi / 2), 0)
		RightHip.C0 = CFrame.new(0.5, -1, 0)*CFrame.Angles(0, (math.pi / 2), 0)
	end
end
