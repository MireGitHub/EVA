-- photo
node.alias("photo")
local COUNTDOWN = 3
START = 0
local font = resource.load_font "silkscreen.ttf"
TEXT_ON_OFF = 0
TEXT_FILE = 0
TEXTINFO_ON_OFF = 0
VIDEO_ON_OFF = 0
OPACITY = 1
playlist_id=0
tmp_pictures={}
child = 0

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
	print('Photos mapper start \tARG value' , arg)	
        START= tonumber(arg)
	if START==0 then
	  TEXT_FILE = 0
	  playlist_id =0
	end;
        print("Start value: ", START)
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
	current_image:dispose()
	local tmp=	pictures.next()
        current_image = resource.load_image(tmp)
	print("CURRENT IMAGE: ",current_image)
        print("TMP IMAGE: ",pictures(tmp))
    end;
    ["text/(.*)"] = function(arg)
	TEXT = arg;
	TEXT_ON_OFF = 1;
	-- print("text no render "+TEXT)
    end;
   ["text_file/(.*)"] = function(arg)
       print("Read from file P0")
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
	print("Photos video mapper\tARG value: " +arg+" VIDEO_ON_OFF ",VIDEO_ON_OFF)
    end;
    ["playlist/(.*)"] = function(arg)

	child=playlist_id
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


function node.render()
	
	if START==0 then
		gl.clear(250,0,0,1)
		current_image:dispose()	
	end;	
	if START==1 then
		_render2()
	end;
	if START==2 then
		util.draw_correct(current_image, 0,0,WIDTH,HEIGHT)
		
		--if playlist_id==0 then
			--util.draw_correct(current_image, 0,0,WIDTH,HEIGHT)
			--print("START 2- IMG: "+current_image)
		--else
			--child = resource.render_child(playlist_id)
			--child:draw(0, 0, WIDTH,HEIGHT) 
			--print("PAUSE ON ID: ", playlist_id)
			--resource.render_child(playlist_id):draw(0, 0, WIDTH,HEIGHT) 
		--end;
	end;
	if TEXT_ON_OFF == 1 then
		font:write(10, 10, TEXT, 30, 1,1,1,1)	
	end;
	if TEXTINFO_ON_OFF == 1 then
		text_info:draw(HEIGHT-260)
	end;
	if VIDEO_ON_OFF == 1 then
		resource.render_child("videolist"):draw(0, 0, WIDTH,HEIGHT, OPACITY) 
	end;	
	if TEXT_FILE == 1 then		
            resource.render_child("text-file-"..tostring(playlist_id)):draw(0, 0, WIDTH,HEIGHT, OPACITY) 
	end;		
end



function _render()
   gl.clear(0,0,0,1)   
    

   if playlist_id == 0 then
	  
	    local time_to_next = next_image_time - sys.now()
	    if time_to_next < 0 then
		if next_image then
		    current_image:dispose()
		    current_image = next_image
		    next_image = nil
		    next_image_time = sys.now() + COUNTDOWN
		    util.draw_correct(current_image, 0,0,WIDTH,HEIGHT)
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
   else
       --if child ~=playlist_id then 
	  
	  --if child >0 then
	   -- resource.render_child(child):dispose()
	   
	   --end  
	   
	  -- child =playlist_id
	--end
	--child = resource.render_child(playlist_id)
	--print("Child START 1: " , child)
	--child:draw(0, 0, WIDTH,HEIGHT) 
	resource.render_child(playlist_id):draw(0, 0, WIDTH,HEIGHT) 
     end
end




function _render2()
gl.clear(0,0,0,1)  
  
	--if playlist_id == 0 then
	  
	    local time_to_next = next_image_time - sys.now()
	    
	    if time_to_next < 0 then
	    
		if next_image then
			current_image:dispose()
			current_image = next_image
			next_image = nil
			next_image_time = sys.now() + COUNTDOWN
			util.draw_correct(current_image, 0,0,WIDTH,HEIGHT)
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
	--else
	--resource.render_child(playlist_id):draw(0, 0, WIDTH,HEIGHT) 
    --end
end

