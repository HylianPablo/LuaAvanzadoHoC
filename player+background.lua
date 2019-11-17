--Desarrollo de un videojuego en LOVE utilizando Lua.
--Primer paso: jugador y escenario.
--www.github.com/HylianPablo

function love.load()
    winW=800
    winH=600
    background=love.graphics.newImage('images/8bitground.jpg')


    --Recordemos que en LOVE el origen de coordenadas se encuentra en la esquina superior izquierda
    player={}
    player.image=love.graphics.newImage('images/8bitcharacter.png')
    player.width, player.height=32
    player.x=winW/2 - player.width
    player.y=winH -175
    player.speed=500


end

function love.update(dt)
    if love.keyboard.isDown("left") and player.x>20 then player.x = player.x -player.speed *dt end
    if love.keyboard.isDown("right") and player.x<=winW-50 then player.x = player.x + player.speed * dt end


end

function love.draw()
    love.graphics.draw(background)
    love.graphics.draw(player.image,player.x,player.y)
    love.graphics.setColor(255,255,255)


end