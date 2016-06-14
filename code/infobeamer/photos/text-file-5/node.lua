gl.setup(1920, 1080)

util.auto_loader(_G)

function feeder()
    return {"Dali", "Figueres 1904 - Figueres 1989"}
end

text = util.running_text{
    font = silkscreen;
    size = 260;
    speed = 240;
    color = {1,1,1,1};
    generator = util.generator(feeder)
}

function node.render()
    text:draw(HEIGHT-260)
end