
-- Services
local CollectionService = game:GetService("CollectionService")
local Maid = script.Parent.Parent.Utils:WaitForChild("Maid"))

-- Variables
local inactiveColor = Color3.fromRGB(89, 85, 90)
local weldingColor = Color3.fromRGB(196, 40, 28)
local weldedColor = Color3.fromRGB(0,0,0)
local holdDuration = 0.5
local holdRadius = 15

----------------------------------------------

local function weldPad(deckWeld)
	local prompt = deckWeld.ClickPart.PromptAttachment.ProximityPrompt
	local firstMaid = Maid.new()
	local secondMaid = Maid.new()
	local welding = false
	local weld = nil
	
	deckWeld.ClickPart.Color = inactiveColor
	deckWeld.ClickPart.SurfaceGui.TextLabel.Text = deckWeld.Name
	prompt.ObjectText = deckWeld.Name
	prompt.ActionText = "Weld"
	prompt.HoldDuration = holdDuration
	prompt.MaxActivationDistance = holdRadius
	
	firstMaid:GiveTask(prompt.Triggered:Connect(function(player)
		if not welding then
			welding = true
			deckWeld.ClickPart.Color = weldingColor
			
			secondMaid:GiveTask(deckWeld.WeldPad.Touched:Connect(function(part)
				if not part.Parent:FindFirstChild("Humanoid") and weld == nil then
					weld = Instance.new("Weld")
					weld.Name = "FedWeld"
					weld.Part0, weld.Part1 = deckWeld.WeldPad, part
					weld.C0 = part.CFrame:toObjectSpace(deckWeld.WeldPad.CFrame):inverse()
					weld.Parent = deckWeld.WeldPad
					
					deckWeld.ClickPart.Color = weldedColor
					prompt.ActionText = "Unweld"
					secondMaid:DoCleaning()
				end
			end))
			
			print(player.Name .. " has enabled " .. deckWeld.Name .. " weld")
		else
			welding = false
			deckWeld.ClickPart.Color = inactiveColor
			prompt.ActionText = "Weld"
			
			if weld ~= nil then
				weld:destroy()
				weld = nil
			end
			
			print(player.Name .. " has disabled " .. deckWeld.Name .. " weld")
		end
	end))
	
	firstMaid:GiveTask(deckWeld.WeldPad.ChildRemoved:Connect(function(child)
		if child.Name == "FedWeld" then
			welding = false
			weld = nil
			deckWeld.ClickPart.Color = inactiveColor
		end
	end))
	
	firstMaid:GiveTask(CollectionService:GetInstanceRemovedSignal("FedsDeckWeld"):Connect(function()
		print(deckWeld.Name .. " cleaned up")
		firstMaid:Destroy()
		secondMaid:Destroy()
	end))
end

CollectionService:GetInstanceAddedSignal("FedsDeckWeld"):Connect(function(instance) 
	weldPad(instance) 
end)
