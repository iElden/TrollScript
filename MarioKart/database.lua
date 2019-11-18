return {
    begin = {
        name = "Ready ?",
        effect = "",
        description = "Are you ready ?",
        image = "begin.png",
        sound = "begin.ogg",
        delay = 11,
        endFct = function ()
            local pfile = popen(("ffplay -autoexit -nodisp sounds/music%s.ogg -loop 0 -volume 50 &>/dev/null &\necho $!"):format(turn == 3 and "2" or ""))
            
            musicPID = pfile:read()
            pfile:close()
            turn = 1
        end,
    },
    base = {
        loadFct = function ()
			local result = math.random(50, 100) / 10

			turnDistance = (turnDistance or 0) + result
            if not execute(("sleep %f"):format(result)) then
                return true
            end
        end,
        name = "Rolling",
        effect = "",
        description = "Rolling",
        image = "box.png",
        sound = "rolling.ogg",
        delay = 4,
		notifDelay = 3.9
    },
    newTurn = {
        loadFct = function ()
            if not execute(("sleep %f"):format(math.random(50, 100) / 10)) then
                return true
            end
            turn = turn + 1
        end,
        name = "Lap 2",
        effect = "",
        description = "Lap 2/3",
        image = "final_lap.png",
        sound = "end_of_turn.ogg",
        delay = 4
    },
    lastTurn = {
        loadFct = function ()
            if not execute(("sleep %f"):format(math.random(50, 100) / 10)) then
                return true
            end
            turn = turn + 1
            if musicPID then
                execute("kill "..musicPID)
                musicPID = nil
            end
        end,
        name = "Last lap !",
        effect = "",
        description = "Lap 3/3",
        image = "final_lap.png",
        sound = "final_lap.ogg",
        endFct = function ()
			if turn then
				local pfile = popen(("ffplay -autoexit -nodisp sounds/music%s.ogg -loop 0 -volume 50 &>/dev/null &\necho $!"):format(turn == 3 and "2" or ""))
				
				musicPID = pfile:read()
				pfile:close()
			end
        end,
        delay = 3
    },
    endCourse = {
        loadFct = function ()
            if not execute(("sleep %f"):format(math.random(50, 100) / 10)) then
                return true
            end
            turn = turn + 1
            if musicPID then
                execute("kill "..musicPID)
                musicPID = nil
            end
        end,
        name = "Finish !",
        effect = "",
        description = "Course finished !",
        image = "final_lap.png",
        sound = "end.ogg",
        delay = 12
    },
    {
        startFct = function ()
            if musicPID then
                execute("kill "..musicPID)
                musicPID = nil
            end
			turnDistance = turnDistance + 20
			--for i = 1, 480 do
			--	execute('xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --gamma 1.0:1.0:1.0')
			--	if not execute("sleep 0.1") then
			--		return
			--	end
			--end
        end,
        name = "Star",
        effect = "",
        description = "You are invincible !",
        image = "star.png",
        sound = "star.ogg",
        delay = 30,
        endFct = function ()
			if turn then
				local pfile = popen(("ffplay -autoexit -nodisp sounds/music%s.ogg -loop 0 -volume 50 &>/dev/null &\necho $!"):format(turn == 3 and "2" or ""))
				
				musicPID = pfile:read()
				pfile:close()
			end
			execute('xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --gamma 1.0:1.0:1.0')
        end,
    },
    {
        startFct = function ()
			turnDistance = 0
        end,
        name = "Blue shell",
        effect = "sleep 2 && nmcli radio wifi off && nmcli radio wifi on",
        description = "The blue shell directly hits your wifi",
        image = "blue_shell.png",
        sound = "blue_shell.ogg",
        delay = 8
    },
    {
        name = "Bullet bill",
        startFct = function ()
            execute("lua bulletbill.lua &")
            execute("lua bulletbill.lua &")
            execute("lua bulletbill.lua &")
            execute("lua bulletbill.lua &")
			turnDistance = turnDistance + 20
        end,
        effect = "",
        description = "Hyper speed !",
        image = "billou.png",
        delay = 15
    },
    {
        name = "Banana",
        startFct = function ()
            for i = 1, 2 do
                if
                    not execute('sleep 0.2') or
                    not execute('xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --rotate inverted') or
                    not execute('sleep 0.2') or
                    not execute('xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --rotate normal')
                then
                    return true
                end
            end
			turnDistance = turnDistance / 2
        end,
        effect = "",
        description = "Your screen slips off the banana",
        image = "banana.png",
        sound = "hit.ogg",
        delay = 8,
        notifDelay = 10
    },
    {
        name = "Triple bananas",
        startFct = function ()
            for i = 1, 6 do
                execute('xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --rotate inverted')
                execute('xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --rotate normal')
            end
			turnDistance = turnDistance / 6
        end,
        effect = "",
        description = "Your screen slips off the bananas",
        image = "bananas.png",
        sound = "hit.ogg",
        delay = 6,
        notifDelay = 10
    },
    {
        name = "Thunder",
        startFct = function ()
            local pfile = popen("xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' '")

            currentBrightness = tonumber(pfile:read())
            for i = 1, 10 do
                execute(('xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --brightness %s'):format(i % 2 == 1 and "0" or "inf"))
                execute("sleep 0.025")
            end
            pfile:close()
			turnDistance = turnDistance / 10
        end,
        effect = 'xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --brightness 0.2',
        description = "Boom !",
        image = "thunder.png",
        sound = "storm.ogg",
        endFct = function ()
            for i = 1, 10 do
                if
                    not execute(('xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --brightness %f'):format(0.2 + 0.8 * currentBrightness * i / 10)) or
                    not execute("sleep 0.025")
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
            local pfile = popen("xinput --list --short")
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
                    execute(string.format('xinput --set-prop %s "Coordinate Transformation Matrix" %f 0 0 0 %f 0 0 0 1', k, sensitivity, sensitivity))
                end
				turnDistance = turnDistance + sensitivity
				if debugMode then
					print("[Triple mushroom]:New turnDistance -> "..tostring(turnDistance))
				end
                execute("sleep 2")
            end
        end,
        effect = '',
        description = "Faster faster faster !",
        image = "triple_mushroom.png",
        sound = "triple_mushroom.ogg",
        endFct = function ()
            for i, k in pairs(mouseDevices) do
                execute(string.format('xinput --set-prop %s "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1', k))
            end
        end,
        delay = 4,
        notifDelay = 10
    },
    {
        name = "Golden mushroom",
        startFct = function ()
            local pfile = popen("xinput --list --short")
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
            for i = 1, 14 do
                local sensitivity = math.random(20, 200) / 10

                for i, k in pairs(mouseDevices) do
                    execute(string.format('xinput --set-prop %s "Coordinate Transformation Matrix" %f 0 0 0 %f 0 0 0 1', k, sensitivity, sensitivity))
                end
				turnDistance = turnDistance + sensitivity / 8
				if debugMode then
					print("[Golden mushroom]:New turnDistance -> "..tostring(turnDistance))
				end
                execute("sleep 0.5")
            end
        end,
        effect = '',
        description = "Faster than ever !",
        image = "golden_mushroom.png",
        sound = "golden_mushroom.ogg",
        endFct = function ()
            for i, k in pairs(mouseDevices) do
                execute(string.format('xinput --set-prop %s "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1', k))
            end
        end,
        delay = 0.5,
        notifDelay = 8
    },
    {
        name = "Mushroom",
        startFct = function ()
            local pfile = popen("xinput --list --short")
            local line
            local sensitivity = math.random(20, 90) / 10

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
                execute(string.format('xinput --set-prop %s "Coordinate Transformation Matrix" %f 0 0 0 %f 0 0 0 1', k, sensitivity, sensitivity))
            end
			turnDistance = turnDistance + sensitivity
        end,
        effect = '',
        description = "Faster !",
        image = "mushroom.png",
        sound = "mushroom.ogg",
        endFct = function ()
            for i, k in pairs(mouseDevices) do
                execute(string.format('xinput --set-prop %s "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1', k))
            end
        end,
        delay = 5
    },
    {
        name = "Boo",
        startFct = function ()
            local pfile = popen("xdotool get_num_desktops")
            local nbOfWorkSpaces = tonumber(pfile:read())
            pfile:close()

            pfile = popen("xdotool search '.*' 2>/dev/null")
            pfile:read()
            line = pfile:read()
            while line do
                local pFile = popen("xdotool getwindowname "..line.." 2>/dev/null")
                local name = pFile:read()

                if name and not inWindowBlackList(name) then
                    execute("xdotool set_desktop_for_window "..line.." "..tostring(math.random(0, nbOfWorkSpaces - 1)))
                end
                pFile:close()
                line = pfile:read()
            end
            pfile:close()
        end,
        effect = '',
        description = "Shuffle time",
        image = "ghost.png",
        sound = "ghost.ogg",
        delay = 2,
    },
    {
        name = "Boomerang",
        startFct = function ()
            local pfile = popen("xdotool get_num_desktops")
            local nbOfWorkSpaces = tonumber(pfile:read())
            local currentDesktop = 0
            pfile:close()
            
            pfile = popen("xdotool get_desktop")
            currentDesktop = tonumber(pfile:read())
            pfile:close()
            
            for i = 0, nbOfWorkSpaces - 1 do
                execute(("xdotool set_desktop %i"):format((currentDesktop + i) % nbOfWorkSpaces))
                execute(("sleep %f"):format((i + 1) ^ 2 / nbOfWorkSpaces ^ 2))
            end
            
            for i = nbOfWorkSpaces - 2, 0, -1 do
                execute(("xdotool set_desktop %i"):format((currentDesktop + i) % nbOfWorkSpaces))
                execute(("sleep %f"):format((i + 1) ^ 2 / nbOfWorkSpaces ^ 2))
            end
        end,
        effect = '',
        description = "Heads up !",
        image = "boomerang.png",
        sound = "boomerang.ogg",
        delay = 0,
        notifDelay = 2,
    },
    {
        name = "Horn",
        startFct = function ()
            local pfile = popen("amixer sget Master")
			
			for i = 1, 4 do
				pfile:read()
			end

			local line = pfile:read()
			local it = line:gmatch("%b[]")
			local infos = {it(), it()}
			local currentVolume = tonumber(infos[1]:sub(2, #infos[1] - 2))
			local isMuted = infos[2] == "[off]"
			local multiplier = 1.5

			pfile:close()
			if currentVolume * multiplier <= 25 then
				execute("amixer sset Master 25% > /dev/null")
			elseif currentVolume * multiplier >= 100 then
				execute("amixer sset Master 100% > /dev/null")
			else
				execute(("amixer sset Master %i%% > /dev/null"):format(math.floor(currentVolume * multiplier)))
			end
			if isMuted then
				execute("amixer sset Master toggle >/dev/null")
			end
			execute("ffplay -autoexit -nodisp sounds/horn.ogg 2>/dev/null >/dev/null")
			execute(("amixer sset Master %i%% > /dev/null"):format(currentVolume))
			if isMuted then
				execute("amixer sset Master toggle >/dev/null")
			end
        end,
        effect = '',
        description = "TUTUUUUUUUUT",
        image = "horn.png",
        delay = 0,
        notifDelay = 4,
    },
    {
        name = "Mega mushroom",
        startFct = function ()
			for i = 1, 3 do
				execute("xdotool keydown Alt; xdotool click 4; xdotool keyup Alt")
				execute("sleep 0.12")
			end
			turnDistance = turnDistance + 10
			execute("xdotool keydown Alt; xdotool click 4; xdotool keyup Alt")
			execute("sleep 0.1")
			execute("xdotool keydown Alt; xdotool click 4; xdotool keyup Alt")
			local pfile = popen("ffplay -autoexit -nodisp sounds/mega_mushroom_music.ogg &>/dev/null &\necho $!")
			if musicPID then
				execute("kill "..musicPID)
			end
			musicPID = pfile:read()
			pfile:close()
			turnDistance = turnDistance + 10
        end,
        effect = '',
        description = "Bigger !",
        image = "mega_mushroom.png",
        sound = "mega_mushroom.ogg",
        delay = 7.5,
        notifDelay = 10,
        endFct = function ()
			if turn then
				local pfile = popen(("ffplay -autoexit -nodisp sounds/music%s.ogg -loop 0 -volume 50 &>/dev/null &\necho $!"):format(turn == 3 and "2" or ""))
				
				if musicPID then
					execute("kill "..musicPID)
				end
				musicPID = pfile:read()
				pfile:close()
			elseif musicPID then
                execute("kill "..musicPID)
                musicPID = nil
            end
			execute("ffplay -autoexit -nodisp sounds/mega_mushroom_down.ogg &>/dev/null &")
			for i = 1, 2 do
				execute("xdotool keydown Alt; xdotool click 5; xdotool click 5; xdotool keyup Alt")
				execute("sleep 0.05")
			end
			execute("xdotool keydown Alt; xdotool click 5; xdotool click 5; xdotool click 5; xdotool click 5; xdotool click 5; xdotool click 5; xdotool click 5; xdotool keyup Alt")
        end,
    },
    {
        name = "POW block",
        startFct = function ()
			execute("ffplay -autoexit -nodisp sounds/pow1.ogg 2>/dev/null >/dev/null &")
			execute(("lua shakemouse.lua 10 100 %i &"):format(math.random(0, 65535)))
			execute("sleep 1")
			execute("ffplay -autoexit -nodisp sounds/pow2.ogg 2>/dev/null >/dev/null &")
			execute(("lua shakemouse.lua 25 200 %i &"):format(math.random(0, 65535)))
			execute("sleep 1")
            local pfile = popen("xdotool get_num_desktops")
            local nbOfWorkSpaces = tonumber(pfile:read())
            pfile:close()

			execute(("lua shakemouse.lua 100 300 %i &"):format(math.random(0, 65535)))
            pfile = popen("xdotool search '.*' 2>/dev/null")
            pfile:read()
            line = pfile:read()
			execute("ffplay -autoexit -nodisp sounds/pow3.ogg 2>/dev/null >/dev/null &")
			if math.random(1, 2) == 1 then
				execute("ffplay -autoexit -nodisp sounds/hit.ogg 2>/dev/null >/dev/null &")
				turnDistance = 0
                execute('sleep 0.2 && xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --rotate inverted && sleep 0.2 && xrandr --output "`xrandr -q | grep " connected" | cut -f 1 -d " "`" --rotate normal &')
			end
            while line do
                local pFile = popen("xdotool getwindowname "..line.." 2>/dev/null")
                local name = pFile:read()

                if name and not inWindowBlackList(name) then
					execute("xdotool windowminimize "..line.. " 2>/dev/null")
                end
                pFile:close()
                line = pfile:read()
            end
            pfile:close()
        end,
        effect = '',
        description = "",
        image = "pow.png",
		delay = 0,
        notifDelay = 6,
    }
}