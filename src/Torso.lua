local LerpTools = require(script.Parent:WaitForChild("LerpTools"))

local VectorOne = 0
local VectorTwo = 0

local VO = 0
local VT = 0
-- local VTT = 0

return function(delta, Character, EnableTorsoLag, RelativeCameraDirection, RelativeMovementDirection, DotOfCameraAndRoot)
	LerpTools.DeltaTime = delta
	Character.Humanoid.AutoRotate = false
	-- X axis relative camera direction
	-- Y axis for humanoid root part rotation
	-- Positive rotates it counter clockwise (for some reason)
	-- print((math.floor((RelativeCameraDirection.X) * 100)) * 0.01)
	-- print(180 + math.deg(math.atan2(Character.Humanoid.MoveDirection.Z, Character.Humanoid.MoveDirection.X)))
	if EnableTorsoLag then
		if Character.Humanoid.MoveDirection.Magnitude >= 0.5 then
			if RelativeMovementDirection.X >= 0.3 then
				VO = LerpTools:LinearInterpolate(VO, 10 * -RelativeMovementDirection.X, 80)
			elseif RelativeMovementDirection.X <= -0.3 then
				VO = LerpTools:LinearInterpolate(VO, 10 * -RelativeMovementDirection.X, 80)
			else
				VO = LerpTools:LinearInterpolate(VO, 10 * -RelativeCameraDirection.X, 80)
			end

			-- * This was originally used to check if player was moving backwards
			-- * I've commented it out because its just causing cascading amplification and glitches
			-- if RelativeMovementDirection.Z <= 0.3 then
			-- 	VO = LinearInterpolate(VO, VO * 0.5, 0.3 * (delta * 60))
			-- end

			if DotOfCameraAndRoot <= 0.5 then
				VT = LerpTools:LinearInterpolate(VT, VO * 0.75, 24)
			else
				VT = LerpTools:LinearInterpolate(VT, VO, 48)
			end
		else
			VT = LerpTools:LinearInterpolate(VT, 0, 24)
		end
		-- VTT = LinearInterpolate(VTT, VT, 0.6 * (delta * 60))

		if RelativeCameraDirection.X >= 0.8 then
			VectorOne = LerpTools:LinearInterpolate(VectorOne, 10 * -RelativeCameraDirection.X, 24)
		elseif RelativeCameraDirection.X <= -0.8 then
			VectorOne = LerpTools:LinearInterpolate(VectorOne, 10 * -RelativeCameraDirection.X, 24)
		elseif RelativeCameraDirection.X < 0.5 and RelativeCameraDirection.X > -0.5 then
			VectorOne = LerpTools:LinearInterpolate(VectorOne, 0, 24)
		end
		VectorTwo = LerpTools:LinearInterpolate(VectorTwo, VectorOne, 48)
	else
		-- VT = LinearInterpolate(VT, 10 * RelativeCameraDirection.X, 0.4 * (delta * 60))
		-- * this is literally the only thing i know to make it work, sorry guys lol
		VT = LerpTools:LinearInterpolate(VT, 0, 24)
		VectorTwo = LerpTools:LinearInterpolate(VectorTwo, 0, 48)
		Character.Humanoid.AutoRotate = true
	end

	-- Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(-90), 0)
	Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(VectorTwo) + math.rad(VT), 0)
end