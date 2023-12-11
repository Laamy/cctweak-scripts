tardis = peripheral.find("tardisinterface") or error("No tardis interface attached.", 0)
chatBox = peripheral.find("chatBox") or error("No chatbox attached.", 0)

local function SendMsg(msg) 
	chatBox.sendMessage(msg, "Timeship", "<>", "", 64)
end

local function onTardisLeave()
	--SendMsg("Welcome Captian, all systems active.")
	
	local subsystems_low = {}
	
	for i,v in ipairs(tardis.getSubSystems()) do
		if tardis.getSubSystemStatus(v) and
			tardis.getSubSystemHealth(v) < 0.1 then -- sub system exists & hp is under 0.1/1
			table.insert(subsystems_low, v)
		end
	end
	
	local subSystemString = table.concat(subsystems_low, ", ")
	
	SendMsg(#subsystems_low > 0 and
		"Welcome Captian, some systems require attention " .. subSystemString .. "." or
		"Welcome Captian, all systems are online.")
end

local function onTardisEnter()
	SendMsg("Goodbye Captian.")
end

local lastSigns = false

while true do
	os.sleep(0.05)
	
	local signs = tardis.getLifeSigns()
	
	if lastSigns ~= signs then
		
		-- its changed so lets throw out the new events
		(signs and onTardisLeave or onTardisEnter)() -- throw events
		
		lastSigns = signs
	end
end