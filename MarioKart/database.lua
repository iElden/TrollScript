return {
    begin = {
        name = "Ready ?",
        effect = "",
        description = "Are you ready ?",
        image = "begin.png",
        sound = "begin.mp3",
        delay = 11,
        endFct = function ()
            local pfile = io.popen(("ffplay -autoexit -nodisp sounds/music%s.mp3 -loop 0 -volume 50 &>/dev/null &\necho $!"):format(turn == 3 and "2" or ""))
            
            musicPID = pfile:read()
            pfile:close()
            turn = 1
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
        delay = 4,
	notifDelay = 3.9
    },
    newTurn = {
        loadFct = function ()
            if not os.execute(("sleep %f"):format(math.random(50, 100) / 10)) then
                return true
            end
            turn = turn + 1
        end,
        name = "Lap 2",
        effect = "",
        description = "Lap 2/3",
        image = "final_lap.png",
        sound = "end_of_turn.mp3",
        delay = 4
    },
    lastTurn = {
        loadFct = function ()
            if not os.execute(("sleep %f"):format(math.random(50, 100) / 10)) then
                return true
            end
            turn = turn + 1
            if musicPID then
                os.execute("kill "..musicPID)
                musicPID = nil
            end
        end,
        name = "Last lap !",
        effect = "",
        description = "Lap 3/3",
        image = "final_lap.png",
        sound = "final_lap.mp3",
        endFct = function ()
            local pfile = io.popen(("ffplay -autoexit -nodisp sounds/music%s.mp3 -loop 0 -volume 50 &>/dev/null &\necho $!"):format(turn == 3 and "2" or ""))
            
            musicPID = pfile:read()
            pfile:close()
        end,
        delay = 3
    },
    endCourse = {
        loadFct = function ()
            if not os.execute(("sleep %f"):format(math.random(50, 100) / 10)) then
                return true
            end
            turn = turn + 1
            if musicPID then
                os.execute("kill "..musicPID)
                musicPID = nil
            end
        end,
        name = "Finish !",
        effect = "",
        description = "Course finished !",
        image = "final_lap.png",
        sound = "end.mp3",
        delay = 12
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
            local pfile = io.popen(("ffplay -autoexit -nodisp sounds/music%s.mp3 -loop 0 -volume 50 &>/dev/null &\necho $!"):format(turn == 3 and "2" or ""))
            
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
    },
    {
        name = "Triple mushroom",
        startFct = function ()
            local pfile = io.popen("xinput --list --short")
            local line

            mouseDevices = {}
            pfile:read()
            pfile:read()
            line = pfile:read()
            while line and line:sub(1, 3) ~= "⎣" do
                table.insert(mouseDevices, line:gmatch("id=[0-9]+")():gmatch("[0-9]+")())
                line = pfile:read()
            end
            pfile:close()
            for i = 1, 3 do
                local sensitivity = math.random(20, 90) / 10

                for i, k in pairs(mouseDevices) do
                    os.execute(string.format('xinput --set-prop %s "Coordinate Transformation Matrix" %f 0 0 0 %f 0 0 0 1', k, sensitivity, sensitivity))
                end
                os.execute("sleep 2")
            end
        end,
        effect = '',
        description = "Faster faster faster !",
        image = "triple_mushroom.png",
        sound = "triple_mushroom.mp3",
        endFct = function ()
            for i, k in pairs(mouseDevices) do
                os.execute(string.format('xinput --set-prop %s "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1', k))
            end
        end,
        delay = 4,
        notifDelay = 10
    },
    {
        name = "Golden mushroom",
        startFct = function ()
            local pfile = io.popen("xinput --list --short")
            local line
            local sensitivity = math.random(20, 50) / 10

            mouseDevices = {}
            pfile:read()
            pfile:read()
            line = pfile:read()
            while line and line:sub(1, 3) ~= "⎣" do
                table.insert(mouseDevices, line:gmatch("id=[0-9]+")():gmatch("[0-9]+")())
                line = pfile:read()
            end
            pfile:close()
            for i = 1, 14 do
                local sensitivity = math.random(20, 200) / 10

                for i, k in pairs(mouseDevices) do
                    os.execute(string.format('xinput --set-prop %s "Coordinate Transformation Matrix" %f 0 0 0 %f 0 0 0 1', k, sensitivity, sensitivity))
                end
                os.execute("sleep 0.5")
            end
        end,
        effect = '',
        description = "Faster than ever !",
        image = "golden_mushroom.png",
        sound = "golden_mushroom.mp3",
        endFct = function ()
            for i, k in pairs(mouseDevices) do
                os.execute(string.format('xinput --set-prop %s "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1', k))
            end
        end,
        delay = 0.5,
        notifDelay = 8
    },
    {
        name = "Mushroom",
        startFct = function ()
            local pfile = io.popen("xinput --list --short")
            local line
            local sensitivity = math.random(20, 50) / 10

            mouseDevices = {}
            pfile:read()
            pfile:read()
            line = pfile:read()
            while line and line:sub(1, 3) ~= "⎣" do
                table.insert(mouseDevices, line:gmatch("id=[0-9]+")():gmatch("[0-9]+")())
                line = pfile:read()
            end
            pfile:close()
            for i, k in pairs(mouseDevices) do
                os.execute(string.format('xinput --set-prop %s "Coordinate Transformation Matrix" %f 0 0 0 %f 0 0 0 1', k, sensitivity, sensitivity))
            end
        end,
        effect = '',
        description = "Faster !",
        image = "mushroom.png",
        sound = "mushroom.mp3",
        endFct = function ()
            for i, k in pairs(mouseDevices) do
                os.execute(string.format('xinput --set-prop %s "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1', k))
            end
        end,
        delay = 5
    },
    {
        name = "Boo",
        startFct = function ()
            local pfile = io.popen("./xdotool get_num_desktops")
            local nbOfWorkSpaces = tonumber(pfile:read())
            pfile:close()

            pfile = io.popen("./xdotool search '.*' 2>/dev/null")
            pfile:read()
            line = pfile:read()
            while line do
                local pFile = io.popen("./xdotool getwindowname "..line.." 2>/dev/null")
                local name = pFile:read()

                if name and name ~= "" and name ~= "wrapper-1.0" and name ~= "wrapper-2.0" and not name:gmatch("xf.*")() then
                    os.execute("./xdotool set_desktop_for_window "..line.." "..tostring(math.random(0, nbOfWorkSpaces - 1)))
                end
                pFile:close()
                line = pfile:read()
            end
            pfile:close()
        end,
        effect = '',
        description = "Shuffle time",
        image = "ghost.png",
        sound = "ghost.mp3",
        delay = 2,
    },
    {
        name = "Boomerang",
        startFct = function ()
            local pfile = io.popen("./xdotool get_num_desktops")
            local nbOfWorkSpaces = tonumber(pfile:read())
            local currentDesktop = 0
            pfile:close()
            
            pfile = io.popen("./xdotool get_desktop")
            currentDesktop = tonumber(pfile:read())
            pfile:close()
            
            for i = 0, nbOfWorkSpaces - 1 do
                os.execute(("./xdotool set_desktop %i"):format((currentDesktop + i) % nbOfWorkSpaces))
                os.execute(("sleep %f"):format((i + 1) ^ 2 / nbOfWorkSpaces ^ 2))
            end
            
            for i = nbOfWorkSpaces - 2, 0, -1 do
                os.execute(("./xdotool set_desktop %i"):format((currentDesktop + i) % nbOfWorkSpaces))
                os.execute(("sleep %f"):format((i + 1) ^ 2 / nbOfWorkSpaces ^ 2))
            end
        end,
        effect = '',
        description = "Attention à la tête !",
        image = "boomerang.png",
        sound = "boomerang.mp3",
        delay = 0,
        notifDelay = 2,
    }
}