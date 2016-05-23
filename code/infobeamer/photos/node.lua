-- photo

local COUNTDOWN = 3
node.alias("photo")
START = 0
local font = resource.load_font "silkscreen.ttf"
TEXT_ON_OFF = 0
TEXT_FILE = 0
TEXTINFO_ON_OFF = 0
VIDEO_ON_OFF = 0
OPACITY = 1
playlist_id=0
tmp_pictures={}
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

-- print("pictures ",pictures)
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
	print('Play' , arg)	
        START= tonumber(arg)
	if START==0 then
	  TEXT_FILE = 0
	  playlist_id =0
	end;
        print(START)
    end;
    ["speed/(.*)"] = function(arg)	
        COUNTDOWN= 1 + tonumber(arg)
	print(COUNTDOWN)
	print('Speed')
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
	print("CURRENT IMAGE: ",current_image)
        --print("TMP IMAGE: ",pictures(tmp))
    end;
    ["text/(.*)"] = function(arg)
	TEXT = arg;
	TEXT_ON_OFF = 1;
	-- print("text no render "+TEXT)
    end;
   ["text_file/(.*)"] = function(arg)
       print("Read from file ")
       TEXT_FILE = tonumber(arg);
	
    end;
   ["text_info/(.*)"] = function(arg)
	-- TEXT = arg;
	TEXTINFO_ON_OFF = tonumber(arg);
	-- print("text no render "+TEXT)
    end;
   ["opacity/(.*)"] = function(arg)
	OPACITY = tonumber(arg);
	print("Opacity "+ OPACITY)
    end;
   ["video/(.*)"] = function(arg)
	VIDEO_ON_OFF = tonumber(arg);
    end;
    ["playlist/(.*)"] = function(arg)
    	START=1
	playlist_id=arg
	tmp_pictures={}

		util.file_watch(arg..".txt", function(content) 

	    	for filename in string.gmatch(content, "[^\r\n]+") do
	        	tmp_pictures[#tmp_pictures+1] = filename
	    	end
		end)

		local new_pictures = util.generator(function()
	    	local out = {}
		
	   	for i,name in pairs(tmp_pictures) do
	        	out[#out + 1] = name
	   	end
	    	return out
  		end)
	local tmp= new_pictures.next()
        current_image = resource.load_image(tmp)
	pictures=new_pictures

    end;

    
}


util.auto_loader(_G)

function feeder()
    return {"A Text", "Another Text"}
end

text_info = util.running_text{
    font = silkscreen;
    size = 260;
    speed = 240;
    color = {1,1,1,1};
    generator = util.generator(feeder)
}


function node.render()
	
	if START==1 then
		_render()
	end;
	if START==2 then
		util.draw_correct(current_image, 0,0,WIDTH,HEIGHT)
		print("START 2- IMG: "+current_image)
	end;
	if TEXT_ON_OFF == 1 then
		font:write(10, 10, TEXT, 30, 1,1,1,1)
		-- print("text "+TEXT)	
	end;
	if TEXTINFO_ON_OFF == 1 then
		text_info:draw(HEIGHT-260)
	end;
	if VIDEO_ON_OFF == 1 then
		resource.render_child("videolist"):draw(0, 0, WIDTH,HEIGHT, OPACITY) 
	
	end;	  
	if TEXT_FILE == 1 then
	    -- folder = tostring(playlist_id)
	    -- folder_id = split(folder, ".")		
            resource.render_child("text-file-"..tostring(playlist_id)):draw(0, 0, WIDTH,HEIGHT, OPACITY) 
	end;	       
end

-- function split(str, sep)
--  local result = {}
-- local regex = ("([.txt]+)"):format(sep)
-- for each in str:gmatch(regex) do
-- table.insert(result, each)
-- end
-- return result
-- end

-- local lines = split(content, ".")
--for _,line in ipairs(lines) do
	-- print(lines)
-- end

function _render()
    gl.clear(0,0,0,1)
    
    -- gl.perspective(60,
    --    WIDTH/2, HEIGHT/2, -WIDTH/1.6,
    --    -- WIDTH/2, HEIGHT/2, -WIDTH/1.4,
    --    WIDTH/2, HEIGHT/2, 0
    -- )
    -- gl.perspective(60,
    --    WIDTH/2+math.cos(sys.now()) * 100, HEIGHT/2+math.sin(sys.now()) * 100, -WIDTH/1.9,
    --    -- WIDTH/2, HEIGHT/2, -WIDTH/1.4,
    --    WIDTH/2, HEIGHT/2, 0
    -- )
    local time_to_next = next_image_time - sys.now()
    if time_to_next < 0 then
        if next_image then
	    current_image:dispose()
            current_image = next_image
            next_image = nil
            next_image_time = sys.now() + COUNTDOWN
            util.draw_correct(current_image, 0,0,WIDTH,HEIGHT)
            -- in_effect = math.random() * 3
            -- out_effect = math.random() * 3
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
