local function CDGGathererLootReceived(eventCode, receivedBy, itemName, quantity, itemSound, lootType, self)
	d(string.format("%d: %d %s looted by %s type %s [%s]",eventCode,quantity,itemName,receivedBy,lootType, tostring(self)    ))
end

function CDGGatherer_OnInitialized()
	EVENT_MANAGER:RegisterForEvent("CDGGatherer",EVENT_LOOT_RECEIVED, CDGGathererLootReceived)
end
