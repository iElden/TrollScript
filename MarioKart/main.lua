#!/bin/lua

database = dofile("./database.lua")

function executePayload(element)
    if element.loadFct then
        element.loadFct()
    end
    os.execute(("notify-send --icon=`pwd`/pictures/%s -t %i '%s' '%s'"):format(element.image, (element.notifDelay or element.delay) * 1000, element.name, element.description))
    if element.sound then
        os.execute(("ffplay -autoexit -nodisp sounds/%s &>/dev/null &"):format(element.sound))
    end
    if element.startFct then
        element.startFct()
    end
    os.execute(element.effect)
    if not os.execute(("sleep %i"):format(element.delay)) then
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
    if #{...} ~= 0 then
        for i, k in pairs({...}) do
            executePayload(getValue(database, k, function (elem) return elem.name end))
        end
        return
    end
    math.randomseed(os.time())
    if not database then
        error("Cannot load database")
    end
    executePayload(database.begin)
    while executePayload(database.base) and executePayload(database[math.random(1, #database)]) do end
end

local success, err = pcall(main, ...)

if not success then
    os.execute(string.format('notify-send "Error" "%s" && ffplay -autoexit -nodisp sounds/boule_noire.mp3 &>/dev/null &', err))
    print(err)
end