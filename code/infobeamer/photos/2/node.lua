local COUNTDOWN = 3
local __start=0
local playlistInfo = 1
local font = resource.load_font "silkscreen.ttf"

gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

pictures = util.generator(function()
    local out = {}
    for name, _ in pairs(CONTENTS) do
        if name:match(".*jpg") then
            out[#out + 1] = name
        end
    end
    return out
end)
node.event("content_remove", function(filename)
    pictures:remove(filename)
end)

local out_effect = math.random() * 3
local in_effect = math.random() * 3

local current_image = resource.load_image(pictures.next())
local next_image
local next_image_time = sys.now() + COUNTDOWN



function node.render()
    gl.clear(0,0,0,1)
    gl.perspective(60,
       WIDTH/2, HEIGHT/2, -WIDTH/1.6,
       -- WIDTH/2, HEIGHT/2, -WIDTH/1.4,
       WIDTH/2, HEIGHT/2, 0
    )
    -- gl.perspective(60,
    --    WIDTH/2+math.cos(sys.now()) * 100, HEIGHT/2+math.sin(sys.now()) * 100, -WIDTH/1.9,
    --    -- WIDTH/2, HEIGHT/2, -WIDTH/1.4,
    --    WIDTH/2, HEIGHT/2, 0
    -- )
    if playlistInfo == 1 then
	font:write(10, 10, "Chagall", 30, 1,1,1,1)
	end
    local time_to_next = next_image_time - sys.now()
    if time_to_next < 0 then
        if next_image then
	    playlistInfo = 0
	    current_image:dispose()
            current_image = next_image
            next_image = nil
            next_image_time = sys.now() + COUNTDOWN
            util.draw_correct(current_image, 0,0,WIDTH,HEIGHT)
            in_effect = math.random() * 3
            out_effect = math.random() * 3
        else
            next_image_time = sys.now() + COUNTDOWN
        end
        util.draw_correct(current_image, 0,0,WIDTH,HEIGHT)
    elseif time_to_next < 1 then
        if not next_image then
            next_image = resource.load_image(pictures.next())
        end
        local xoff = (1 - time_to_next) * WIDTH

     
    else
        util.draw_correct(current_image, 0,0,WIDTH,HEIGHT)
    end


 
end