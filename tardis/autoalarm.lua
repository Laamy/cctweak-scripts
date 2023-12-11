tardis = peripheral.find("tardisinterface") or error("No tardis interface attached.", 0)

while true do
	os.sleep(0.05)
	
	local alarm = tardis.getAlarm()
	
	if alarm then
		print("Alarm activated, disabling in 15 seconds")
		os.sleep(15)
		
		print("Alarm disabled")
		
		pcall(function() -- this has a bug which causes an error, lets catch it...
			tardis.setAlarm(false)
		end)
	end
end

print("script stopping")