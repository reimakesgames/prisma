local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Packages = script.Parent
local Link = require(Packages.link)

local ToServer, ToClient

local PlayerCameraCFrames: { [Player]: CFrame } = {}

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

local function RenderNeck(Player, CameraCFrame)
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

	TweenService:Create(NeckJoint, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
		C0 = CFrame.new(0, 1, 0)
		* CFrame.Angles(3 * math.pi / 2, 0, math.pi)
		* CFrame.Angles(0, 0, -math.asin(RelativeCameraDirection.x))
		* CFrame.Angles(-math.asin(RelativeCameraDirection.y), 0, 0)
	}):Play()
	-- NeckJoint.C0 = CFrame.new(0, 1, 0)
	-- 	* CFrame.Angles(3 * math.pi / 2, 0, math.pi)
	-- 	* CFrame.Angles(0, 0, -math.asin(RelativeCameraDirection.x))
	-- 	* CFrame.Angles(-math.asin(RelativeCameraDirection.y), 0, 0)
	return true
end

-- TODO implement this as a toggleable
-- this function is here because this is the test for the mouse looking function.
-- its currently unimplemented because of networking jank

-- local function Test()
-- 	if not IsCharacterAlive(Players.LocalPlayer) then
-- 		return CFrame.new()
-- 	end

-- 	local Character = Players.LocalPlayer.Character

-- 	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
-- 	if not HumanoidRootPart then
-- 		return CFrame.new()
-- 	end

-- 	return HumanoidRootPart.CFrame
-- end

local function Render(_)
	local LocalCameraCFrame = workspace.CurrentCamera.CFrame
	-- local HumanoidRootPartCFrame = Test()
	-- LocalCameraCFrame = CFrame.lookAt(HumanoidRootPartCFrame.Position, Players.LocalPlayer:GetMouse().Hit.Position)

	RenderNeck(Players.LocalPlayer, LocalCameraCFrame)
	ToServer:FireServer(LocalCameraCFrame)

	for Player, CameraCFrame in PlayerCameraCFrames do
		if not RenderNeck(Player, CameraCFrame) then
			continue
		end
	end
end

local function ClientRecieve(Player: Player, CameraCFrame: CFrame)
	PlayerCameraCFrames[Player] = CameraCFrame
end

local function ServerRecieve(Player: Player, CameraCFrame: CFrame)
	ToClient:FireSelectedClients({Player}, false, CameraCFrame)
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


local Prisma = {}

return Prisma
