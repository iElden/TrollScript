#!/bin/lua

pcall(require, "signal")
local database = dofile("./database.lua")

function executePayload(element)
    if element.loadFct then
        if element.loadFct() then
            error("interrupted!")
        end
    end
    os.execute(("notify-send --icon=`pwd`/pictures/%s -t %i '%s' '%s'"):format(element.image, (element.notifDelay or element.delay) * 1000, element.name, element.description))
    if element.sound then
        os.execute(("ffplay -autoexit -nodisp sounds/%s &>/dev/null &"):format(element.sound))
    end
    if element.startFct then
        element.startFct()
    end
    os.execute(element.effect)
    if not os.execute(("sleep %f"):format(element.delay)) then
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
    math.randomseed(os.time())
    if #{...} ~= 0 then
        for i, k in pairs({...}) do
            executePayload(getValue(database, k, function (elem) return elem.name end))
        end
        return
    end

    if signal then
    signal.signal("SIGTERM", function ()
        if musicPID then
            os.execute("kill "..musicPID)
        end
        os.exit(0)
    end)
    end

    if not database then
        error("Cannot load database")
    end
    executePayload(database.begin)
    while true do
        executePayload(database.base)
        executePayload(database[math.random(1, #database)])
        if math.random(1, 30) == 1 then
            if turn == 1 then
                executePayload(database.newTurn)
            elseif turn == 2 then
                executePayload(database.lastTurn)
            elseif turn == 3 then
                executePayload(database.endCourse)
                executePayload(database.begin)
            end
        end
    end
end

if not os.execute("ffplay -version > /dev/null") then
    error("ffplay version check failed")
end

local success, err = pcall(main, ...)

if not success then
    if err:sub(#err - #"interrupted!" + 1, #err) ~= "interrupted!" then
        os.execute(string.format('notify-send "Error" "%s" && ffplay -autoexit -nodisp sounds/boule_noire.mp3 &>/dev/null &', err))
        print(err)
    end
    if musicPID then
        os.execute("kill "..musicPID)
    end
end
