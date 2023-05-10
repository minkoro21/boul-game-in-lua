camera=require("camera")
conf=require("conf")
cam=camera()
function drawBoid (mode ,x, y ,length, width, angle)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(angle)
    love.graphics.rectangle("fill", x, y, length, width)
    love.graphics.pop()
end
function calculateDistance(x1, y1, x2, y2)
    return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2))
end
function love.load()
    en={}
    scal=0
    enemy=true
    sound = love.audio.newSource("select.wav", "static")
    sound2 = love.audio.newSource("confirm.wav", "static")
    sound3= love.audio.newSource("hurt.wav", "static")
    start=false
    crash2=false 
    crash=true
    cont=2
    color=false
    color2=false
    math.randomseed(os.time())
    raw=2000
    col=2000
    color=math.random(0, 1)
    number_ennemy=math.random(450, 550)
    x=100
    y=100
    x2=0
    e_x={}
    music = love.audio.newSource("music.wav", "stream")
    y2=0
    e_y={}
    math.random(love.graphics.getHeight())
    radius=15
    radius2={}
    angle=math.pi
    speed=0
    play=True
    angle2=0
    nubeber={}
    width=love.graphics.getWidth()
    heidth=love.graphics.getHeight()
    
end

-- Increase the size of the rectangle every frame.
function love.keypressed(key)
    --color o(1)
    if key=="down" then
        cont=cont+1
        sound:play()
    end

    if cont%2==0 then
        color=true
        color2=false
    end

    if cont%2==0 and key=="space" then
        sound2:play()
        if not start then
            love.event.quit()
        end
        
    end

    if cont%2~=0 then
        color2=true
        color=false
    end

    if cont%2~=0 and key=="space" then
        if not start then
            sound2:play()
        end
        start=true
    end

end
function love.update(dt)
    --O(1)
    
    if not  start then
        love.graphics.setBackgroundColor(0, 1, 1)
    end
    
    if x>=love.graphics.getWidth() then
        x=love.graphics.getWidth()
    end
    if x<=love.graphics.getWidth() then
        x=30
    end
    if y>=love.graphics.getHeight() then
        y=love.graphics.getHeight()
    end
    if y<=love.graphics.getHeight() then
        y=20
    end
    if love.keyboard.isDown("space") then
        speed=speed+0.5
        x2=x2+speed*math.cos(angle)/love.timer.getFPS()
        y2=y2+speed*math.sin(angle)/love.timer.getFPS()
    end
    if not  love.keyboard.isDown("space") then
        speed=0
    end
    if love.keyboard.isDown("left") then
        angle=angle+360/180* math.pi/love.timer.getFPS()
    end
    if love.keyboard.isDown("right") then
        angle=angle-360/180*math.pi/love.timer.getFPS()
    end
    x=x+x2
    y=y+y2
    cam:lookAt(x, y)
    local w=love.graphics.getWidth()
    local h=love.graphics.getHeight()
    if cam.x < w/2 then
        cam.x=w/2
    elseif cam.x>w then
        cam.x=w
    end
    if cam.y < h/2 then
        cam.y=h/2
    elseif cam.y>h then
        cam.y=h
    end
    if not start then
        music:play()
    else
        love.audio.stop(music)
    end
end

-- Draw a coloured rectangle.
function love.draw()
    -- In versions prior to 11.0, color component values are (0, 102, 102)
    if start then
        cam:attach()
            list2={200, 300, 400}
            list={love.graphics.rectangle('line', 1, 1, 50, 50)}
            for i=1, raw, 50 do
                for y=1, col, 50 do
                    lore=love.graphics.setColor(1,0,1)
                    table.insert(list,i, love.graphics.rectangle('line', i, y, 50, 50))
                    for z=1, #list2 do
                        if list2[z]==200 then
                            love.graphics.setColor(1,0,1)
                            love.graphics.rectangle('fill', i, y, 50, 50)
                        elseif list2[z]==300 then
                            love.graphics.setColor(0,1,1)
                            love.graphics.rectangle('fill', i, y, 50, 50)
                        end
                    end
                end
            end
            --ennemy o(n)
            for k=1, number_ennemy do
                table.insert(e_x,  math.random(love.graphics.getWidth()+1000))
                table.insert(e_y,  math.random(love.graphics.getHeight()+1000))
                table.insert(radius2, math.random(2, 7))
                if radius2[k]==2 then
                    love.graphics.setColor(1,0,0)
                elseif radius2[k]>=3 and radius2[k] <= 5 then
                    love.graphics.setColor(1, 0.5, 0.5)
                elseif radius2[k]>5 and radius2[k] <=7 then
                    love.graphics.setColor(0,1,0)
                else 
                    love.graphics.setColor(0.5,1,0.5)
                end
                table.insert(en,k, love.graphics.circle("fill", e_x[k], e_y[k], radius2[k]))
                sp=calculateDistance(x, y, e_x[k], e_y[k]) < radius + radius2[k]
                if sp and radius2[k]==2 then --x >= e_x[k] and y >= e_y[k] and x >= e_x[k]+radius2[k] and y >= e_y[k]+radius2[k] then
                    scal=scal+1
                    crash=false
                    sound3:play()
                    radius=radius+0.04
                elseif sp and radius2[k]>=3 and radius2[k] <= 5 then
                    scal=scal+2
                    crash=false
                    sound3:play()
                    radius=radius+0.07
                    table.remove(en,k)
                elseif sp and radius2[k]>5 and radius2[k] <=7 then
                    scal=scal+4
                    crash=false
                    sound3:play()
                    radius=radius+0.09
                elseif sp then
                    scal=scal+0.5
                    crash=false
                    sound3:play()
                    radius=radius+0.02
                end
             --x >= e_x[k] and y >= e_y[k] and x >= e_x[k]+radius2[k] and y >= e_y[k]+radius2[k] then
            end
            love.graphics.setColor(1, 1, 0)
            love.window.setTitle("BUBLLE GAME")
            love.graphics.print(speed)
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle("fill",x, y, radius)
            love.graphics.setColor(0, 0, 1)
            love.graphics.print(scal, x, y)
        cam:detach()
    end
    if not start then
        love.graphics.scale(1, 1) 
        font = love.graphics.newImageFont("Resource-Imagefont.png",
        " abcdefghijklmnopqrstuvwxyz" ..
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
        "123456789.,!?-+/():;%&`'*#=[]\"")
        love.graphics.setFont(font)
        love.graphics.setColor(0,0,0)
        if color then
            love.graphics.setColor(0,1,0)
        end
        love.graphics.printf("EXIT", 0, 420, 800, 'center')
        love.graphics.setColor(0,0,0)
        if color2 then
            love.graphics.setColor(0,1,0)
        end
        love.graphics.printf("PLAY GAME", 0, 400, 800, 'center')
    end
end
