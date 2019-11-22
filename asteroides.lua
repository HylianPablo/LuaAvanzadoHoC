--Desarrollo de un videojuego en LOVE utilizando Lua.
--Segundo paso: movimiento de los asteroides.
--www.github.com/HylianPablo

function love.load()
    winW=800
    winH=600
    rotation=0
    asteroidsFloating=0
    background=love.graphics.newImage('images/8bitground.jpg')

    --Recordemos que en LOVE el origen de coordenadas se encuentra en la esquina superior izquierda
    player={}
    player.image=love.graphics.newImage('images/8bitcharacter.png')
    player.width, player.height=32
    player.x=winW/2 - player.width
    player.y=winH -175
    player.speed=500

    asteroids={}

end

function love.update(dt)
    rng=math.random(1,15)
    if rng==5 then
    for i=0,1 do
        asteroid={
            x= math.random(20,winW-10),
            y=0,
            speed=110,
            image=love.graphics.newImage('images/asteroid8bit.png')
        }
        table.insert(asteroids,asteroid)
        asteroidsFloating=asteroidsFloating+1
    end
    end

    --Movimiento de asteroides
    for i, asteroid in ipairs(asteroids) do
        asteroid.y=asteroid.y+asteroid.speed*dt
        if asteroid.y>winH then table.remove(asteroids,i) end
    end

    --Movimiento del jugador
    if love.keyboard.isDown("left") and player.x>20 then player.x = player.x -player.speed *dt end
    if love.keyboard.isDown("right") and player.x<=winW-50 then player.x = player.x + player.speed * dt end
end

function love.draw()
    --rng=math.random(20,winW-50)
    love.graphics.draw(background)
    love.graphics.draw(player.image,player.x,player.y)
    love.graphics.setColor(255,255,255)
    for i,asteroid in ipairs(asteroids) do love.graphics.draw(asteroid.image,asteroid.x,asteroid.y,rotation) end
    rotation=rotation+0.1
end