tardis = peripheral.find("tardisinterface") or error("No tardis interface attached.", 0)
local chatBox = peripheral.find("chatBox")
-- getArtronBank, setRefuel, getSpeed, setDoors

local function SendMsg(msg) 
	chatBox.sendMessage(msg, "Timeship", "<>", "", 64)
end

local pages = {
    {
		name = "Toggles",
        buttons = {
            {
				name = "Refuel",
				callback = function() -- toggle door open state
					tardis.setRefuel(not tardis.isRefueling())
					
					SendMsg("Fueling set to " .. tostring(tardis.isRefueling()))
				end
			},
            {
				name = "Doors",
				callback = function()
					tardis.setDoors(tardis.getDoors() == "CLOSED" and "BOTH" or "CLOSED")
					
					SendMsg("Doors set to " .. tardis.getDoors())
				end
			},
            {
				name = "Handbrake",
				callback = function()
					tardis.setHandbrake(not tardis.isHandbrakeFree())
					
					SendMsg("Handbrakes set to " .. tostring(tardis.isHandbrakeFree()))
				end
			},
            {
				name = "Alarms",
				callback = function()
					-- magma bugs this so we need to catch it
					pcall(function()
						tardis.setAlarm(not tardis.getAlarm())
					end)
					
					SendMsg("Alarms set to " .. tostring(tardis.getAlarm()))
				end
			}
        }
    },
    {
		name = "Extra",
        buttons = {
            {
				name = "test 1",
				callback = function()
				
				end
			},
            {
				name = "test 2",
				callback = function()
					
				end
			}
		}
    }
}

local currentPage = 1
local selectedButton = 1

function clearScreen()
    term.setBackgroundColor(colors.black)
    term.clear()
end
clearScreen()

function drawButtons(page)
    clearScreen()
    term.setCursorPos(2, 2)
    term.setTextColor(colors.white)
    term.write("\\-- " .. pages[page].name .. " --/")

    for i, button in ipairs(pages[page].buttons) do
        term.setCursorPos(2, i + 3)
        if i == selectedButton then
            term.setTextColor(colors.black)
            term.setBackgroundColor(colors.white)
        else
            term.setTextColor(colors.white)
            term.setBackgroundColor(colors.black)
        end
        term.write(button.name)
    end
end

drawButtons(currentPage)

while true do
    local event, key = os.pullEvent("key")
    
    if event == "key" then
        if key == keys.up then
            selectedButton = math.max(1, selectedButton - 1)
        elseif key == keys.down then
            selectedButton = math.min(#pages[currentPage].buttons, selectedButton + 1)
        elseif key == keys.left then
            currentPage = math.max(1, currentPage - 1)
            selectedButton = math.min(selectedButton, #pages[currentPage].buttons)
        elseif key == keys.right then
            currentPage = math.min(#pages, currentPage + 1)
            selectedButton = math.min(selectedButton, #pages[currentPage].buttons)
        elseif key == keys.enter then
			pages[currentPage].buttons[selectedButton].callback()
        end

        drawButtons(currentPage)
    end
end
