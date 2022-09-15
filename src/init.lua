local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Packages = script.Parent
local Link = require(Packages.link)

local TorsoLagVector = Instance.new("NumberValue", script)
local TorsoLagVector2 = Instance.new("NumberValue", script)

local ToServer, ToClient

local PlayerCameraCFrames: { [Player]: CFrame } = {}

local Prisma = {
	MouseTracking = false
}

local function LinearInterpolate(x: number, y: number, alpha: number)
	return x * (1 - alpha) + y * alpha
end

local function IsCharacterAlive(Player: Player)
	local Character = Player.Character
	if not Character then
		return false
	end

	local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
	if not Humanoid then
		return false
	end

	local State = Humanoid:GetState()
	if State == Enum.HumanoidStateType.Dead then
		return false
	end

	return true
end

local function RenderNeck(delta, Player, CameraCFrame)
	if Player.Parent == nil then
		PlayerCameraCFrames[Player] = nil
		return false
	end

	if not IsCharacterAlive(Player) then
		return false
	end

	local Character = Player.Character

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return false
	end

	local Torso = Character:FindFirstChild("Torso")
	if not Torso then
		return false
	end

	local NeckJoint = Torso:FindFirstChild("Neck")
	if not NeckJoint then
		return false
	end

	local RelativeCameraDirection = HumanoidRootPart.CFrame:ToObjectSpace(CameraCFrame).LookVector

	if LocalPlayer == Player then
		Player.Character.Humanoid.AutoRotate = false
		-- X axis relative camera direction
		-- Y axis for humanoid root part rotation
		-- Positive rotates it counter clockwise (for some reason)
		-- print((math.floor((RelativeCameraDirection.X) * 100)) * 0.01)
		if RelativeCameraDirection.X >= 0.8 then
			TorsoLagVector.Value = LinearInterpolate(TorsoLagVector.Value, 10 * -RelativeCameraDirection.X, 0.4 * (delta * 60))
		elseif RelativeCameraDirection.X <= -0.8 then
			TorsoLagVector.Value = LinearInterpolate(TorsoLagVector.Value, 10 * -RelativeCameraDirection.X, 0.4 * (delta * 60))
		elseif RelativeCameraDirection.X < 0.5 and RelativeCameraDirection.X > -0.5 then
			TorsoLagVector.Value = LinearInterpolate(TorsoLagVector.Value, 0, 0.4 * (delta * 60))
		end
		TorsoLagVector2.Value = LinearInterpolate(TorsoLagVector2.Value, TorsoLagVector.Value, 0.9 * (delta * 60))

		HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(TorsoLagVector2.Value), 0)
	end

	-- TweenService:Create(NeckJoint, TweenInfo.new(0.1, Enum.EasingStyle.Cubic), {
		-- C0 = CFrame.new(0, 1, 0)
		-- * CFrame.Angles(3 * math.pi / 2, 0, math.pi)
		-- * CFrame.Angles(0, 0, -math.asin(RelativeCameraDirection.x))
		-- * CFrame.Angles(-math.asin(RelativeCameraDirection.y), 0, 0)
	-- }):Play()
	NeckJoint.C0 = CFrame.new(0, 1, 0)
		* CFrame.Angles(3 * math.pi / 2, 0, math.pi)
		* CFrame.Angles(0, 0, -math.asin(RelativeCameraDirection.x))
		* CFrame.Angles(-math.asin(RelativeCameraDirection.y), 0, 0)
	return true
end

local function ConvertToMouseDirection()
	if not IsCharacterAlive(Players.LocalPlayer) then
		return CFrame.new()
	end

	local Character = Players.LocalPlayer.Character

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return CFrame.new()
	end

	return HumanoidRootPart.CFrame
end

local function Render(delta)
	local LocalCameraCFrame = workspace.CurrentCamera.CFrame
	if Prisma.MouseTracking then
		local HumanoidRootPartCFrame = ConvertToMouseDirection()
		LocalCameraCFrame = CFrame.lookAt(HumanoidRootPartCFrame.Position, Players.LocalPlayer:GetMouse().Hit.Position)
	end

	RenderNeck(delta, Players.LocalPlayer, LocalCameraCFrame)
	ToServer:FireServer(LocalCameraCFrame)

	for Player, CameraCFrame in PlayerCameraCFrames do
		if not RenderNeck(delta, Player, CameraCFrame) then
			continue
		end
	end
end

local function ClientRecieve(Player: Player, CameraCFrame: CFrame)
	PlayerCameraCFrames[Player] = CameraCFrame
end

local function ServerRecieve(Player: Player, CameraCFrame: CFrame)
	ToClient:FireSelectedClients({Player}, false, Player, CameraCFrame)
end

if RunService:IsServer() then
	ToServer = Link.CreateEvent("ToServer")
	ToClient = Link.CreateEvent("ToClient")
	ToServer.Event:Connect(ServerRecieve)
elseif RunService:IsClient() then
	ToServer = Link.WaitEvent("ToServer")
	ToClient = Link.WaitEvent("ToClient")
	ToClient.Event:Connect(ClientRecieve)
	RunService:BindToRenderStep("PRISMA_main", Enum.RenderPriority.Last.Value + 50, Render)
end

function Prisma.EnableMouseTracking(bool: boolean)
	Prisma.MouseTracking = bool
end

return Prisma
