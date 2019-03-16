#!/bin/lua

require("signal")
local database = dofile("./database.lua")

function executePayload(element)
    if element.loadFct then
        if element.loadFct() then
            return false
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
        return false
    end
    if element.endFct then
        element.endFct()
    end
    return true
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
        signal.signal("SIGTERM", function () end)
        for i, k in pairs({...}) do
            executePayload(getValue(database, k, function (elem) return elem.name end))
        end
        return
    end
    if not database then
        error("Cannot load database")
    end
    if executePayload(database.begin) then
        while executePayload(database.base) and executePayload(database[math.random(1, #database)]) do end
        error("interrupted!")
    else
        error("interrupted!")
    end
end

signal.signal("SIGTERM", function ()
    os.execute("ffplay -autoexit -nodisp sounds/quit.mp3 &>/dev/null &") 
    if musicPID then
        os.execute("kill "..musicPID)
        musicPID = nil
    end
    os.exit(0)
end)

local success, err = pcall(main, ...)

if not success then
    if err:sub(#err - #"interrupted!" + 1, #err) == "interrupted!" then
        os.execute("ffplay -autoexit -nodisp sounds/quit.mp3 &>/dev/null &")
    else
        os.execute(string.format('notify-send "Error" "%s" && ffplay -autoexit -nodisp sounds/boule_noire.mp3 &>/dev/null &', err))
        print(err)
    end
    if musicPID then
        os.execute("kill "..musicPID)
        musicPID = nil
    end
end
