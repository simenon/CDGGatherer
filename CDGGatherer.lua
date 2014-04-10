local function CDGGathererInteractBusy()
	if IsPlayerInteractingWithObject() and getInteractionType() == INTERACTION_HARVEST then
		d(string.format("Player harvesting "))
	end
end

local function CDGGathererLootReceived(eventCode, receivedBy, itemName, quantity, itemSound, lootType, self)
	d(string.format("%d: %d %s looted by %s type %s [%s]",eventCode,quantity,itemName,receivedBy,lootType, tostring(self)    ))
end

function CDGGatherer_OnInitialized()
	EVENT_MANAGER:RegisterForEvent("CDGGatherer",EVENT_INTERACT_BUSY, CDGGathererInteractBusy)
	EVENT_MANAGER:RegisterForEvent("CDGGatherer",EVENT_LOOT_RECEIVED, CDGGathererLootReceived)
end
