return function(Character, RelativeCameraDirection)
	-- TweenService:Create(NeckJoint, TweenInfo.new(0.1, Enum.EasingStyle.Cubic), {
		-- C0 = CFrame.new(0, 1, 0)
		-- * CFrame.Angles(3 * math.pi / 2, 0, math.pi)
		-- * CFrame.Angles(0, 0, -math.asin(RelativeCameraDirection.x))
		-- * CFrame.Angles(-math.asin(RelativeCameraDirection.y), 0, 0)
	-- }):Play()
	Character.Torso.Neck.C0 = CFrame.new(0, 1, 0)
		* CFrame.Angles(3 * math.pi / 2, 0, math.pi)
		* CFrame.Angles(0, 0, -math.asin(RelativeCameraDirection.X))
		* CFrame.Angles(-math.asin(RelativeCameraDirection.Y), 0, 0)
	return true
end