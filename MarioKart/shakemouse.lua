local args = { ... }
local max = tonumber(args[2])
local t = (args[1] == "inf" and 1 or args[1]) + args[2] + args[3]

math.randomseed(tonumber(args[3]))

function pos(max)
    return math.floor(math.random(0, max) - max / 2 - max % 2)
end

for i = 1, args[1] == "inf" and 1/0 or tonumber(args[1]) do
    os.execute(("xdotool mousemove_relative -- %i %i"):format(pos(max), pos(max)))
end