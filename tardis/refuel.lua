tardis = peripheral.find("tardisinterface")	or error("No tardis interface attached.", 0)

while true do
	os.sleep(0.05)
	
	local speed	= tardis.getSpeed()
	local artronBank = tardis.getArtronBank()
	
	if	speed < 0.1	and	artronBank <= 2559 then
		tardis.setRefuel(true)
		print("Refuelling..")
	else
		tardis.setRefuel(false)
		print("Refuelling complete")
	end
end
