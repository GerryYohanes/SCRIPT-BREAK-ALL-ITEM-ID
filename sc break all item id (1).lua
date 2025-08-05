---------- SCRIPT LUCIFER -----------
----- BREAK ITEMID & NEXT WORLD -----
--------- MADE BY JPC STORE ---------

-- SETTINGS
local worldlistPath = "C:\\Users\\Asus\\Documents\\worldlist.txt"
local Break_itemid = {226}

-- Load worldlist from file
function loadWorldListFromFile(path)
    local file = io.open(path, "r")
    if not file then
        print("Failed to open worldlist file: " .. path)
        return {}
    end
    local list = {}
    for line in file:lines() do
        if line:match("%S") then -- skip empty lines
            table.insert(list, line:upper())
        end
    end
    file:close()
    return list
end

local Worldlist = loadWorldListFromFile(worldlistPath)

----- [[ DON'T TOUCH HERE FK U ]] -----
function warpToWorld(world)
    local maxRetries = 5
    local retries = 0
    local bot = getBot()
    while retries < maxRetries do
        print("Attempting to warp to world: " .. world)
        bot:warp(world)
        local warped = false
        for i = 1, 10 do
            if bot:isInWorld(world:upper()) then
                warped = true
                break
            end
            sleep(1000)
        end
        if warped then
            print("Successfully entered world: " .. world)
            return true
        else
            print("Failed to enter world: " .. world .. ". Retrying...")
            retries = retries + 1
        end
    end
    print("Exceeded max retries. Could not warp to world: " .. world)
    return false
end

function breakItems()
    local bot = getBot()
    for _, tile in pairs(bot:getWorld():getTiles()) do
        for _, id in pairs(Break_itemid) do
            if tile.fg == id then
                bot:findPath(tile.x, tile.y - 1)
                sleep(200)
                while bot:getWorld():getTile(tile.x, tile.y).fg == id do
                    bot:hit(tile.x, tile.y)
                    sleep(200)
                end
            end
        end
    end
end

function main()
    if #Worldlist == 0 then
        print("Worldlist kosong. Periksa file: " .. worldlistPath)
        return
    end

    for i, world in ipairs(Worldlist) do
        local success = warpToWorld(world)
        if success then
            sleep(5000)
            breakItems()
            if i < #Worldlist then
                print("Next world will be: " .. Worldlist[i + 1])
                sleep(5000)
            else
                print("Completed all Worldlist. Script stopping.")
            end
        else
            print("Retrying current world: " .. world)
            sleep(5000)
        end
    end
end

main()
