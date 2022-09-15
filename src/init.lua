local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Packages = script.Parent
local Link = require(Packages.link)

local HeadFragment = require(script.Head)
local TorsoFragment = require(script.Torso)

local ToServer, ToClient

local PlayerCameraCFrames: { [Player]: CFrame } = {}

local Prisma = {
	MouseTracking = false
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

local function RenderEverything(deltaTime, Player, CameraCFrame)
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

	-- Runs everything and the required variables
	local RelativeCameraDirection = HumanoidRootPart.CFrame:ToObjectSpace(CameraCFrame).LookVector

	HeadFragment(Player.Character, RelativeCameraDirection)
	TorsoFragment(deltaTime, Player.Character, RelativeCameraDirection)

	return true
end

local function Render(deltaTime)
	local LocalCameraCFrame = workspace.CurrentCamera.CFrame
	if Prisma.MouseTracking then
		local HeadCFrame = ConvertToMouseDirection()
		LocalCameraCFrame = CFrame.lookAt(HeadCFrame.Position, Players.LocalPlayer:GetMouse().Hit.Position)
	end

	RenderEverything(deltaTime, Players.LocalPlayer, LocalCameraCFrame)
	ToServer:FireServer(LocalCameraCFrame)

	for Player, CameraCFrame in PlayerCameraCFrames do
		if not RenderEverything(deltaTime, Player, CameraCFrame) then
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
