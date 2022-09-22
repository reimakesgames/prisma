local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Packages = script.Parent
local Link = require(Packages.link)

local HeadFragment = require(script.Head)
local TorsoFragment = require(script.Torso)
local ArmFragment = require(script.Arm)
local LegFragment = require(script.Leg)

local ToServer, ToClient

local PlayerCameraCFrames: { [Player]: CFrame } = {}
local PlayerArmStates: { [Player]: Array<boolean> } = {}

local Prisma = {
	MouseTracking = false;
	LeftArmEnabled = false;
	RightArmEnabled = false;
	TorsoLagEnabled = true;
	LegRotationEnabled = true;
}

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

local function ConvertToMouseDirection()
	if not IsCharacterAlive(LocalPlayer) then
		return CFrame.new()
	end

	local Character = LocalPlayer.Character

	local Head = Character:FindFirstChild("Head")
	if not Head then
		return CFrame.new()
	end

	return Head.CFrame
end

local function RenderEverything(deltaTime, Player, CameraCFrame, ArmStates: Array<boolean>)
	-- Add checks here so fragments have 0 boilerplate
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

	if not Character:FindFirstChild("Torso") or not Character.Torso:FindFirstChild("Neck") then
		return false
	end

	if not Character.Torso:FindFirstChild("Left Hip") or not Character.Torso:FindFirstChild("Right Hip") then
		return false
	end

	-- Runs everything and the required variables
	local RelativeCameraDirection = HumanoidRootPart.CFrame:ToObjectSpace(CameraCFrame).LookVector
	local RelativeMovementDirection = Character.HumanoidRootPart.CFrame:ToObjectSpace(CFrame.new(Character.HumanoidRootPart.CFrame.Position + Character.Humanoid.MoveDirection))
	local DotOfCameraAndRoot = CameraCFrame.LookVector:Dot(HumanoidRootPart.CFrame.LookVector)

	HeadFragment(Player.Character, RelativeCameraDirection)
	ArmFragment(ArmStates, Player, RelativeCameraDirection)
	LegFragment(Character, Prisma.LegRotationEnabled, RelativeMovementDirection)

	if Player == LocalPlayer then
		TorsoFragment(deltaTime, Player.Character, Prisma.TorsoLagEnabled, RelativeCameraDirection, RelativeMovementDirection, DotOfCameraAndRoot)
	end

	return true
end

local function Render(deltaTime)
	local LocalCameraCFrame = workspace.CurrentCamera.CFrame
	if Prisma.MouseTracking then
		local HeadCFrame = ConvertToMouseDirection()
		LocalCameraCFrame = CFrame.lookAt(HeadCFrame.Position, Players.LocalPlayer:GetMouse().Hit.Position)
	end

	local MyArmStates = {Prisma.LeftArmEnabled, Prisma.RightArmEnabled}

	RenderEverything(deltaTime, Players.LocalPlayer, LocalCameraCFrame, MyArmStates)
	ToServer:FireServer(LocalCameraCFrame, MyArmStates)

	for Player, CameraCFrame in PlayerCameraCFrames do
		if not RenderEverything(deltaTime, Player, CameraCFrame, PlayerArmStates[Player]) then
			continue
		end
	end
end

local function ClientRecieve(Player: Player, CameraCFrame: CFrame, ArmStates: Array<boolean>)
	PlayerCameraCFrames[Player] = CameraCFrame
	PlayerArmStates[Player] = ArmStates
end

local function ServerRecieve(Player: Player, CameraCFrame: CFrame, ArmStates: Array<boolean>)
	ToClient:FireSelectedClients({Player}, false, Player, CameraCFrame, ArmStates)
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

function Prisma:ToggleMouseTracking(bool: boolean)
	Prisma.MouseTracking = bool
end

function Prisma:ToggleArms(Left: boolean, Right: boolean)
	Prisma.LeftArmEnabled = Left
	Prisma.RightArmEnabled = Right
end

function Prisma:ToggleLeftArm(Enabled: boolean)
	Prisma.LeftArmEnabled = Enabled
end

function Prisma:ToggleRightArm(Enabled: boolean)
	Prisma.RightArmEnabled = Enabled
end

function Prisma:ToggleTorsoLag(Enabled: boolean)
	Prisma.TorsoLagEnabled = Enabled
end

function Prisma:ToggleLegRotation(Enabled: boolean)
	Prisma.LegRotationEnabled = Enabled
end

return Prisma
