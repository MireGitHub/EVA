gl.setup(1920, 1080)

util.auto_loader(_G)

function feeder()
    return {"Chagall", "Vitebsk 1887 - Saint Paul de Vence 1985"}
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