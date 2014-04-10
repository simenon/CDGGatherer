Player = {}

function CDGGathererInteractBusy()
	if not Player.Harvesting then
		if IsPlayerInteractingWithObject() then
			if (GetInteractionType() == INTERACTION_HARVEST) then
				Player.Harvesting = true
				_, nodename = GetGameCameraInteractableActionInfo()
				d(string.format("Player harvesting %s", nodename))
			end
		end
	end
end

function CDGGathererLootReceived(_, _, itemName, quantity, _, _, self)
	if not self then
		return
	end

	d(string.format("looted %d %s",quantity,itemName ))
	Player.Harvesting = false
end

function CDGGatherer_OnInitialized()
	Player.Harvesting = false

	EVENT_MANAGER:RegisterForEvent("CDGGatherer",EVENT_LOOT_RECEIVED, CDGGathererLootReceived)
end

function CDGGatherer_OnUpdate()
	CDGGathererInteractBusy()
end
