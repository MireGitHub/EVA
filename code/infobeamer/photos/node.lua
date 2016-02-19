-- photo

local COUNTDOWN = 3
node.alias("photo")
START=0
local font = resource.load_font "silkscreen.ttf"
TEXT_ON_OFF = 0

gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

pictures = util.generator(function()
    local out = {}
    for name, _ in pairs(CONTENTS) do
        if name:match(".*jpg") or name:match(".*png") or name:match(".*jpeg") or name:match(".*mp4") then
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


util.osc_mapper{
    ["start/(.*)"] = function(arg)	
        START= tonumber(arg)
    end;
    ["speed/(.*)"] = function(arg)	
        COUNTDOWN= 1 + tonumber(arg)
	print(COUNTDOWN)
	print('Ciao')
    end;
    ["accelerate/(.*)"] = function(arg)	
        COUNTDOWN= COUNTDOWN-tonumber(arg);
	print(COUNTDOWN)
    end;
    ["decrease/(.*)"] = function(arg)	
        COUNTDOWN= COUNTDOWN+tonumber(arg);
	print(COUNTDOWN)
    end;
    ["next/(.*)"] = function(arg)
	local tmp=	pictures.next()
        current_image = resource.load_image(tmp)
	print(current_image)
        print(pictures(tmp))
	
    end;
    ["text/(.*)"] = function(arg)
	TEXT = arg;
	TEXT_ON_OFF = 1;
	print("text no render "+TEXT)
    end
}

function node.render()
	if START==1 then
		_render()
	end;
	if START==2 then
		util.draw_correct(current_image, 0,0,WIDTH,HEIGHT)
	end;
	if TEXT_ON_OFF == 1 then
		font:write(10, 10, TEXT, 30, 1,1,1,1)
		print("text "+TEXT)	
	end
            
end
function _render()
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
    local time_to_next = next_image_time - sys.now()
    if time_to_next < 0 then
        if next_image then
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

        gl.pushMatrix()
            if out_effect < 1 then
                gl.rotate(200 * (1-time_to_next), 0,1,0)
                util.draw_correct(current_image, 0 + xoff, 0, WIDTH + xoff, HEIGHT, time_to_next)
            elseif out_effect < 2 then
                gl.rotate(60 * (1-time_to_next), 0,0,1)
                util.draw_correct(current_image, 0 + xoff, 0, WIDTH + xoff, HEIGHT, time_to_next)
            else
                gl.rotate(300 * (1-time_to_next), -1,0.2,0.4)
                util.draw_correct(current_image, 0 + xoff, 0, WIDTH + xoff, HEIGHT, time_to_next)
            end
        gl.popMatrix()

        gl.pushMatrix()
            xoff = time_to_next * -WIDTH
            if in_effect < 1 then
                gl.rotate(100 * (time_to_next), 1,-1,0)
                util.draw_correct(next_image, 0 + xoff, 0,WIDTH + xoff, HEIGHT, 1-time_to_next)
            elseif in_effect < 2 then 
                gl.rotate(100 * (time_to_next), 0,0,-1)
                util.draw_correct(next_image, 0 + xoff, 0,WIDTH + xoff, HEIGHT, 1-time_to_next)
            else
                local half_width = WIDTH/2
                local half_height = HEIGHT/2
                local percent = 1 - time_to_next
                gl.translate(half_width, half_height)
                gl.rotate(100 * time_to_next, 0,0,-1)
                gl.translate(-half_width, -half_height)
                util.draw_correct(next_image,
                    half_width - half_width*percent, half_height - half_height*percent, 
                    half_width + half_width*percent, half_height + half_height*percent, 
                    1-time_to_next
                )
            end
        gl.popMatrix()
    else
        util.draw_correct(current_image, 0,0,WIDTH,HEIGHT)
    end
end
