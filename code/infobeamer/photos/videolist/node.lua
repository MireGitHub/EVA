-- video list

gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)
node.alias("videolist")
local playlist, video, current_video_idx 
_audio=true
START=11
INFO=0

util.file_watch("playlist.txt", function(content) 
    playlist = {}
    for filename in string.gmatch(content, "[^\r\n]+") do
        playlist[#playlist+1] = filename
    end
    current_video_idx = 0
    print("Videolist READ playlist video")
    pp(playlist)
end)

function next_video()
    current_video_idx = current_video_idx + 1
    if current_video_idx > #playlist then
        current_video_idx = 1
    end
    if video then
        video:dispose()
    end 
    video = util.videoplayer(playlist[current_video_idx], {loop=false,paused=false,audio=true})
end

--function prova(vari)
	--print("prova chiamata dal padre")
	--START=1
	--return "retrurn"
--end

util.osc_mapper{
    -- start==0 non ancora avviato pausa
    -- start==1 avviato
    -- start==2 stop	
    ["vds/(.*)"] = function(arg)	
        START=tonumber(arg)
	print("Videolist mapper\tStart value: ", START)
    end;
    ["speed/(.*)"] = function(arg)	
        COUNTDOWN= tonumber(arg)
	print(COUNTDOWN)
    end;
    ["accelerate/(.*)"] = function(arg)	
        COUNTDOWN= COUNTDOWN-tonumber(arg);
	print(COUNTDOWN)
    end;
    ["decrease/(.*)"] = function(arg)	
        COUNTDOWN= COUNTDOWN+tonumber(arg);
	print(COUNTDOWN)
    end;
    ["addvideo/(.*)"] = function(arg)	
        playlist[#playlist+1] = arg
	print(arg)
    end;
    ["info/(.*)"] = function(arg)	
 	INFO=1
    end;
}

function node.render()

	if START==1 then
		--_render()
		 video = util.videoplayer(playlist[1], {loop=false,paused=false,audio=true})
		video:start()
		START=3
		print("Videolist render\tvideo avviato ", START) 
		
	end;
	if START==2 then
		--video:stop()
		print("Videolist render\tSTOP VIDEO/AUDIO\tstart 2")
		video:dispose()
		--video=nil
		START=3
		-- video = util.videoplayer(playlist[current_video_idx], {loop=false,paused=true,audio=false})
	end;
	if START==0 then
		video:dispose()
	    -- video:draw(0, 0, WIDTH, HEIGHT)	
	    -- video:start()
            -- util.draw_correct(video, 0, 0, WIDTH, HEIGHT)
	    -- print("video avviato")  
        end;
            
end
function _render()
    if not video or not video:next() then
    	print("Videolist\tvideo avviato ", START)  
        next_video()
    end;
        util.draw_correct(video, 0, 0, 3, 3)
end
