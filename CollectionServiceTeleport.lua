
local CollectionService = game:GetService("CollectionService")

local connections = {}

----------------------------------------------

local function newTeleport(teleportPart)
	local destination = teleportPart.Destination.Value
	local customText = teleportPart.CustomText
	local prompt = teleportPart.PromptAttachment.ProximityPrompt
	
	print("Teleport from " .. teleportPart.Name .. " to " .. destination.Name .. " loaded")
	
	if destination:IsA("Model") then
		destination.PrimaryPart = destination
	end
	
	if customText.Value ~= "" and customText.Value ~= "false" then
		prompt.ObjectText = customText.Value
	else
		prompt.ObjectText = destination.Name
	end
	prompt.HoldDuration = teleportPart.HoldDuration.Value
	
	connections[teleportPart] = prompt.Triggered:Connect(function(player)
		local character = player.Character
		if character then
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
				humanoidRootPart.CFrame = CFrame.new(destination.Position + Vector3.new(0, 1, 0))
			end
		end
	end)
end

local function removeTeleport(teleportPart)
	connections[teleportPart]:Disconnect()
	connections[teleportPart] = nil
	print("Teleport from " .. teleportPart.Name .. " cleaned up")
end

CollectionService:GetInstanceAddedSignal("FedsTeleport"):Connect(function(instance) 
	newTeleport(instance) 
end)
CollectionService:GetInstanceRemovedSignal("FedsTeleport"):Connect(function(instance) 
	removeTeleport(instance) 
end)
