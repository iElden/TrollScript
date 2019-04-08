#!/bin/lua

pcall(require, "signal")
local database = dofile("./database.lua")

function inWindowBlackList(name)
    return
    name == "" or
    name == "wrapper-1.0" or
    name == "wrapper-2.0" or
    name:gmatch("xf.*")() or
    name == "Bureau" or
    name == "Desktop"
end

function execute(command)
    if debugMode then
        print("[execute]:        executing command \""..command.."\"")
    end
    return os.execute(command)
end

function popen(command)
    if debugMode then
        print("[popen]:          popening command \""..command.."\"")
    end
    return io.popen(command)
end

function executePayload(element, display)
    if not element then
        io.stderr:write("Invalid element\n")
        return
    end
    if display then
        print("[executePayload]: Executing payload '"..element.name.."'")
    end
    if element.loadFct then
        if element.loadFct() then
            error("interrupted!")
        end
    end
    
    if debugMode then
        print(("[executePayload]: Notification for %f ms"):format((element.notifDelay or element.delay) * 1000))
    end
    
    execute(("notify-send --icon=`pwd`/pictures/%s -t %i '%s' '%s'"):format(element.image, (element.notifDelay or element.delay) * 1000, element.name, element.description))
    if element.sound then
        execute(("ffplay -autoexit -nodisp sounds/%s &>/dev/null &"):format(element.sound))
    end
    if element.startFct then
        element.startFct()
    end
    execute(element.effect)
    
    if debugMode then
        print(("[executePayload]: sleeping for %f seconds"):format(element.delay))
    end

    if not execute(("sleep %f"):format(element.delay)) then
        error("interrupted!")
    end
    if element.endFct then
        element.endFct()
    end
end

function getValue(tab, key, fct)
    for i, k in pairs(tab) do
        if fct and fct(k) == key or i == key then
            return k
        end
    end
    return nil
end

function main(...)
    local args = {...}
    local totalDistance = 0
    local showDistance = false
    local showItems = false
    local seedSet = false
    local quit = false
    local single = false
    local buff = 0

    turnDistance = 0
    for i = 1, #args, 1 do
        if buff > 0 then
            buff = buff - 1
        elseif args[i] == '--seed' then
            buff = 1
            math.randomseed(tonumber(args[i + 1]))
            seedSet = true
        elseif args[i] == "--distance" then
            showDistance = true
        elseif args[i] == "--item" then
            showItems = true
        elseif args[i] == "--debug" then
            showItems = true
            showDistance = true
            debugMode = true
        elseif args[i] == "--single" then
            single = true
        elseif args[i]:sub(1, 2) == "--" then
            error("Unknown flag "..args[i])
        else
            executePayload(getValue(database, args[i], function (elem) return elem.name end))
            quit = true
        end
    end
    if quit then return end
    if not seedSet then
       math.randomseed(os.time())
    end

    if signal then
        signal.signal("SIGTERM", function ()
            if musicPID then
                execute("kill "..musicPID)
            end
            os.exit(0)
        end)
    end

    if not database then
        error("Cannot load database")
    end
    
    executePayload(database.begin)
    while true do
        executePayload(database.base, debugMode)
        executePayload(database[math.random(1, #database)], showItems)
        totalDistance = totalDistance + turnDistance
        if showDistance then
            print("[main]:           Turn distance "..tostring(turnDistance))
            print("[main]:           Total distance "..tostring(totalDistance))
        end
        turnDistance = 0
        if turn == 1 and totalDistance >= 150 then
            executePayload(database.newTurn, debugMode)
        elseif turn == 2 and totalDistance >= 300 then
            executePayload(database.lastTurn, debugMode)
        elseif turn == 3 and totalDistance >= 425 then
            executePayload(database.endCourse, debugMode)
            totalDistance = 0
            if single then
                break
            end
            executePayload(database.begin)
        end
    end
end

if not execute("ffplay -version > /dev/null") then
    error("ffplay version check failed")
end

local success, err = pcall(main, ...)

if not success then
    if err:sub(#err - #"interrupted!" + 1, #err) ~= "interrupted!" then
        execute(string.format('notify-send "Error" "%s" && ffplay -autoexit -nodisp sounds/boule_noire.mp3 &>/dev/null &', err))
        print(err)
    end
    if musicPID then
        execute("kill "..musicPID)
    end
end
