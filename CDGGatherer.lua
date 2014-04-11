local Player = {}
local SavedVars
local pin = { 
	level = 40,
	texture = "ESOUI/art/crafting/blackcircle.dds",
	size = 32,
--	insetX = 12,
--	insetY = 7,
}
local PinTooltipCreator = {
	creator = function(pin)	
		InformationTooltip:AddLine( pin.m_PinTag[3] , "", ZO_HIGHLIGHT_TEXT:UnpackRGB())
		
	end,
	tooltip = InformationTooltip,
}



local function AddCallbackCDGMapPin(pinManager)
	if (GetMapType() == MAPTYPE_COSMIC) then 
		return 
	end
	
	zone = GetUnitZone("player")
	subzone = GetMapName()
	
	for _, v in pairs(savedVars[zone][subzone]) do		
		for _, w in pairs(v) do
			pinManager:CreatePin( _G["CDGMapPin"], w, w[1], w[2])
		end
	end	
end

function doesNodeExist(zone,subzone,x,y,node)
	local tolerance = 0.01

	for _, v in pairs(savedVars[zone][subzone][node]) do		
		if ((x - tolerance) <= v[1])  and ((x + tolerance) >= v[1]) then
			if ((y - tolerance) <= v[2])  and ((y + tolerance) >= v[2]) then
				d("allready found this node before")
				return true
			end
		end
	end
	return false
end

function CDGGathererInteractBusy()
	if not Player.Harvesting then
		if IsPlayerInteractingWithObject() then
			if (GetInteractionType() == INTERACTION_HARVEST) then
				Player.Harvesting = true
				_, nodename, _, _, _ = GetGameCameraInteractableActionInfo()
				SetMapToPlayerLocation()
				x,y, _ = GetMapPlayerPosition("player")
				zone = GetUnitZone("player")
				subzone = GetMapName()
				if not savedVars[zone] then
					savedVars[zone] = {}
				end
				if not savedVars[zone][subzone] then
					savedVars[zone][subzone] = {}
				end
				if not savedVars[zone][subzone][nodename] then
					savedVars[zone][subzone][nodename] = {}
				end
				
				if not doesNodeExist(zone,subzone,x,y,nodename) then
					table.insert( savedVars[zone][subzone][nodename], { x, y, nodename } )
				end
				
				d(string.format("Player harvesting %s @ %f,%f %s %s", nodename, x, y, zone, subzone))
				
--				ZO_WorldMap_AddCustomPin( "CDGMapPin", AddCallbackCDGMapPin, nil, pin, PinTooltipCreator )	
--				ZO_WorldMap_SetCustomPinEnabled( _G["CDGMapPin"], true )
--				ZO_WorldMap_RefreshCustomPinsOfType(_G["CDGMapPin"])
				
			end
		end
	end
end

function CDGGathererLootReceived(_, _, itemName, quantity, _, _, self)
	if not self then
		return
	end

	itemName = string.gsub(itemName,"%^[pn]","")
	d(string.format("looted %d %s",quantity,itemName ))
	Player.Harvesting = false
end

function CDGGathererLootItemFailed()
	if Player.Harvesting then
		Player.Harvesting = false
		d(string.format("Stopped harvesting" ))			
	end
end

function CDGGathererChatterEnd()
	if Player.Harvesting then
		Player.Harvesting = false
		d(string.format("Stopped harvesting" ))		
	end
end

function CDGGathererAddOnLoaded (eventCode, addOnName)
    if(addOnName == "CDGGatherer") then
		savedVars = ZO_SavedVars:New("CDGGatherer_SavedVariables", 4, nil)
    end
end

function CDGGathererMoneyUpdate(eventCode, newMoney, oldMoney, reason)
	d(string.format("%d Gold", newMoney - oldMoney))
end

function CDGGatherer_OnInitialized()
	Player.Harvesting = false
	
	EVENT_MANAGER:RegisterForEvent("CDGGatherer",EVENT_MONEY_UPDATE, CDGGathererMoneyUpdate)
	EVENT_MANAGER:RegisterForEvent("CDGGatherer",EVENT_CHATTER_END, CDGGathererChatterEnd)
	EVENT_MANAGER:RegisterForEvent("CDGGatherer",EVENT_LOOT_ITEM_FAILED, CDGGathererLootItemFailed)
	EVENT_MANAGER:RegisterForEvent("CDGGatherer",EVENT_LOOT_RECEIVED, CDGGathererLootReceived)
	EVENT_MANAGER:RegisterForEvent("CDGGatherer",EVENT_ADD_ON_LOADED, CDGGathererAddOnLoaded)
end

function CDGGatherer_OnUpdate()
	CDGGathererInteractBusy()
end
