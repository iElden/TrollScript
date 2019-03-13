return {
    begin = {
        name = "Ready ?",
        effect = "",
        description = "Are you ready ?",
        image = "begin.png",
        sound = "begin.mp3",
        delay = 11,
        endFct = function ()
            local pfile = io.popen("ffplay -autoexit -nodisp sounds/music.mp3 -volume 50 &>/dev/null &\necho $!")
            
            musicPID = pfile:read()
            pfile:close()
        end,
    },
    base = {
        loadFct = function ()
            if not os.execute(("sleep %f"):format(math.random(50, 100) / 10)) then
                return true
            end
        end,
        name = "Rolling",
        effect = "",
        description = "Rolling",
        image = "box.png",
        sound = "rolling.mp3",
        delay = 4
    },
    {
        startFct = function ()
            if musicPID then
                os.execute("kill "..musicPID)
                musicPID = nil
            end
        end,
        name = "Star",
        effect = "",
        description = "You are invincible for 30 seconds",
        image = "star.png",
        sound = "star.mp3",
        delay = 30,
        endFct = function ()
            local pfile = io.popen("ffplay -autoexit -nodisp sounds/music.mp3 -volume 50 &>/dev/null &\necho $!")
            
            musicPID = pfile:read()
            pfile:close()
        end,
    },
    {
        name = "Blue shell",
        effect = "sleep 2 && nmcli radio wifi off && nmcli radio wifi on",
        description = "The blue shell directly hits your wifi",
        image = "blue_shell.png",
        sound = "blue_shell.mp3",
        delay = 8
    },
    {
        name = "Bullet bill",
        startFct = function ()
            os.execute("lua bulletbill.lua &")
            os.execute("lua bulletbill.lua &")
            os.execute("lua bulletbill.lua &")
            os.execute("lua bulletbill.lua &")
        end,
        effect = "",
        description = "Hyper speed !",
        image = "billou.png",
        delay = 10,
        notifDelay = 10
    },
    {
        name = "Banana",
        startFct = function ()
            for i = 1, 2 do
                if
                    not os.execute('sleep 0.2') or
                    not os.execute('xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --rotate inverted') or
                    not os.execute('sleep 0.2') or
                    not os.execute('xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --rotate normal')
                then
                    return true
                end
            end
        end,
        effect = "",
        description = "Your screen slips off the banana",
        image = "banana.png",
        sound = "hit.mp3",
        delay = 8,
        notifDelay = 10
    },
    {
        name = "Triple bananas",
        startFct = function ()
            for i = 1, 6 do
                os.execute('xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --rotate inverted')
                os.execute('xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --rotate normal')
            end
        end,
        effect = "",
        description = "Your screen slips off the bananas",
        image = "bananas.png",
        sound = "hit.mp3",
        delay = 6,
        notifDelay = 10
    },
    {
        name = "Thunder",
        startFct = function ()
            local pfile = io.popen("xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' '")

            currentBrightness = tonumber(pfile:read())
            for i = 1, 10 do
                os.execute(('xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --brightness %s'):format(i % 2 == 1 and "0" or "inf"))
                os.execute("sleep 0.025")
            end
            pfile:close()
        end,
        effect = 'xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --brightness 0.2',
        description = "Boom !",
        image = "thunder.png",
        sound = "storm.mp3",
        endFct = function ()
            for i = 1, 10 do
                if
                    not os.execute(('xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --brightness %f'):format(0.2 + 0.8 * currentBrightness * i / 10)) or
                    not os.execute("sleep 0.025")
                then
                    return true
                end
            end
        end,
        delay = 10,
        notifDelay = 14
    }
}