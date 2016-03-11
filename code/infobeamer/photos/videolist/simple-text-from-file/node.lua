gl.setup(1920, 120)

local font = resource.load_font "silkscreen.ttf"

function trim(s)
    return s:match "^%s*(.-)%s*$"
end

util.file_watch("line.txt", function(data)
    -- line = trim(data)
	print(data)
	line = data
end)

function node.render()
    font:write(10, 10, line, 30, 1,1,1,1)
end
