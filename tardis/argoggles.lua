local Controller = peripheral.find("arController") or error("No AR Controller attached")
local Tardis = peripheral.find("tardisinterface") or error("No TardisInterface attached")

local Screen = {
	Size = { X = 1920, Y = 1080 }
}

Controller.setRelativeMode(true, Screen.Size.X, Screen.Size.Y)

local TardisArray = nil

function DrawString(strTable, x, y, hex, increaseBy)
	local offset = y
	
	for i,v in ipairs(strTable) do
		local thread = coroutine.create(function()
			Controller.drawString(v, x, offset, hex) -- this'll call first
		end)
		
		-- I do this cuz i use to develop roblox games n shit and it would be faster by like 3 times
		coroutine.resume(thread)
		
		offset = offset + increaseBy -- then as thats running this will call allowing for the next one to be one lower
	end
end

local function OnRangeUpdate()
	Controller.clear()
	
	DrawString({
		"\\-- Tardis Interface --/", "", "Out of range"
	}, Offset, 40, 0xffffff, 10)
end

local function OnUpdate()
	Controller.clear()
	
	local Offset = 900 - 100 -- BRO???
	
	DrawString({
		"\\-- Tardis Interface --/", "",
		"Refuel: " .. TardisArray["refuel"],
		"Doors: " .. TardisArray["doors"],
		"Handbrake: " .. TardisArray["handbrake"],
		"Alarm: " .. TardisArray["alarm"],
		"Location: " .. tostring(TardisArray["location"][1]) .. "," .. tostring(TardisArray["location"][2]) .. "," ..  tostring(TardisArray["location"][3]),
		"Dimension: " .. tostring(TardisArray["dimension"][2]),
		"TargetDimension: " .. tostring(TardisArray["targetLocation"][1]) .. "," .. tostring(TardisArray["targetLocation"][2]) .. "," ..  tostring(TardisArray["targetLocation"][3]),
		"TargetDimension: " .. tostring(TardisArray["targetDimension"][2]),
		"Bank: " .. TardisArray["bank"]
	}, Offset, 40, 0xffffff, 10)
end

function AreTablesEqual(table1, table2)
    if #table1 ~= #table2 then
        return false
    end

    for k, v in pairs(table1) do
        if type(v) == "table" then
            if not AreTablesEqual(v, table2[k]) then
                return false
            end
        elseif table2[k] ~= v then
            return false
        end
    end

    return true
end

function RoundToNearestTen(number)
    return math.floor(number / 10 + 0.5) * 10
end

local function NeedsUpdate()
	local s,msg = pcall(function()
		local doors = Tardis.getDoors() -- if out of range of the tardis this will error
	end)
	
	if not s then
		print('RANGE!')
		
		if TardisArray ~= nil then
			-- out of range
			OnRangeUpdate()
			
			TardisArray = nil -- so we dont spam this
		end
		
		return false
	end
	
	local tardisArray = {
		["refuel"] = tostring(Tardis.isRefueling()),
		["doors"] = Tardis.getDoors(),
		["handbrake"] = tostring(Tardis.isHandbrakeFree()),
		["alarm"] = tostring(Tardis.getAlarm()),
		["location"] = {Tardis.getLocation()}, -- [1]:x, [2]:y, [3]:z
		["dimension"] = {Tardis.getCurrentDimension()}, -- [1]:id, [2]:name
		["targetLocation"] = {Tardis.getDestination()}, -- [1]:x, [2]:y, [3]:z
		["targetDimension"] = {Tardis.getDestinationDimension()}, -- [1]:id, [2]:name
		["bank"] = tostring(RoundToNearestTen(Tardis.getArtronBank()))
	}
		
	if TardisArray ~= nil then
		-- check if prevTa is new one or not
		
		if AreTablesEqual(tardisArray, TardisArray) then
			return false
		end
		
	end
		
	TardisArray = tardisArray
	return true
end

while true do
	sleep(1 / 5)
	
	-- check if need to update
	if NeedsUpdate() then
		OnUpdate()
	end
end