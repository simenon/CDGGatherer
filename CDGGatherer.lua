function CDGGathererInteractBusy()
	if IsPlayerInteractingWithObject() then
		if (GetInteractionType() == INTERACTION_HARVEST) then
			d(string.format("Player harvesting"))
		end
	end
end

function CDGGathererLootReceived(_, _, itemName, quantity, _, _, self)
	if not self then
		return
	end

	d(string.format("looted %d %s",quantity,itemName ))
end

function CDGGatherer_OnInitialized()
	EVENT_MANAGER:RegisterForEvent("CDGGatherer",EVENT_LOOT_RECEIVED, CDGGathererLootReceived)
end

function CDGGatherer_OnUpdate()
	CDGGathererInteractBusy()
end
