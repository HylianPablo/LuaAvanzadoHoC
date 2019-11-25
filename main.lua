-- Desarrollo de un videojuego en LOVE utilizando Lua.
-- Tercer y último paso: añadidos y comentarios.
-- www.github.com/HylianPablo
-- Función para detectar colisiones. Toma las coordenadas x e y; y el ancho y alto de dos componentes y las compara.
-- Se puede entender como que se comparan las coordenadas incluyendo el ancho/alto para cuadrar el origen de coordenadas.
--  La intención es comprobar si se rozan.
function collision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function love.load()
    winW = 800
    winH = 600
    rotation = 0 -- Variable que regula el ángulo de la rotación de los asteroides.
    score = 0 -- Variable que regula la puntucación. Sumará 1 por cada asteroide que salga del mapa.
    life = 3 -- Variable que regula la vida del jugador. Disminuirá en 1 por cada impacto con un asteroide.
    playerDirection = true -- Variable que indica la dirección del jugador. True indicará izquierda y false derecha.

    state = "init" -- Variable que indica en que parte del programa nos encontramos. En este pequeño juego sólo diferenciaremos pantalla de inicio y juego

    font = love.graphics.newFont("fonts/ARCADECLASSIC.TTF", 45) -- Archivo y tamaño
    titleFont = love.graphics.newFont("fonts/ARCADECLASSIC.TTF", 65) -- Archivo y tamaño
    finalFont = love.graphics.newFont("fonts/ARCADECLASSIC.TTF", 85) -- Archivo y tamaño
    background = love.graphics.newImage('images/8bitground.jpg')
    initBackground = love.graphics.newImage('images/initbackground.jpg')

    music = love.audio.newSource("sounds/gourmet-race-8-bit-kirby.mp3", "static") -- Música de fondo.
    initmusic = love.audio.newSource("sounds/initmusic.mp3", "static")

    -- Recordemos que en LOVE el origen de coordenadas se encuentra en la esquina superior izquierda
    player = {}
    player.image = love.graphics.newImage('images/8bitcharacter.png')
    player.imageR = love.graphics.newImage('images/8bitcharacterRight.png')
    player.width = 32
    player.height = 32
    player.x = winW / 2 - player.width
    player.y = winH - 175
    player.speed = 500

    asteroids = {} -- Iremos creando y destruyendo asteroides dinámicamente

end

-- dt significa ''delta-time'' y es un parámetro que mide el tiempo entre cada invocación de sí misma
-- El valor de 'dt' depende del procesador y es menor que 1, llegando a valores como 0.01.
-- Consultar https://love2d.org/wiki/dt para más detalles.
function love.update(dt)
    if state == "init" then
        love.audio.play(initmusic) -- Musica de inicio
        if love.keyboard.isDown("return") then state = "game" end
    else
        love.audio.stop(initmusic)
        love.audio.play(music) -- Música de juego.

        rng = math.random(1, 25)
        if rng == 5 then
            for i = 0, 1 do -- Se aplica el bucle en cada tick.
                asteroid = {
                    x = math.random(20, winW - 10),
                    y = 0,
                    width = 32,
                    height = 32,
                    speed = 110,
                    image = love.graphics.newImage('images/asteroid8bit.png')
                }
                table.insert(asteroids, asteroid)
            end
        end

        -- Movimiento de asteroides
        for i, asteroid in ipairs(asteroids) do
            asteroid.y = asteroid.y + asteroid.speed * dt
            if asteroid.y > winH then
                table.remove(asteroids, i)
                score = score + 1
            end
        end

        -- Colisiones de asteroides
        for i, asteroid in ipairs(asteroids) do
            if collision(player.x, player.y, player.width, player.height,
                         asteroid.x, asteroid.y, asteroid.width, asteroid.height) then
                life = life - 1
                table.remove(asteroids, i)
            end
        end

        -- Movimiento del jugador y cambio de sprite
        if love.keyboard.isDown("left") and player.x > 20 then
            player.x = player.x - player.speed * dt
            playerDirection = true
        end
        if love.keyboard.isDown("right") and player.x <= winW - 50 then
            player.x = player.x + player.speed * dt
            playerDirection = false
        end

        if life <= 0 then
            for i, asteroid in ipairs(asteroids) do
                table.remove(asteroids, i)
            end
        end
    end
end

function love.draw()
    if state == "init" then
        love.graphics.draw(initBackground)
        love.graphics.setFont(titleFont)
        love.graphics.setColor(0,0,0)
        love.graphics.print("Press  enter  to  play", winW / 2 - 285, winH / 2-50)
        love.graphics.setColor(255,255,255)
    else
        love.graphics.draw(background) -- Por defecto toma 255,255,255; es decir, blanco.
        love.graphics.setFont(font)

        if life > 0 then
            if playerDirection then
                love.graphics.draw(player.image, player.x, player.y)
            else
                love.graphics.draw(player.imageR, player.x, player.y)
            end
            love.graphics.setColor(0, 0, 0)
            love.graphics.print("Score " .. score, 10, 5)
            love.graphics.print("Life " .. life, 10, 45)
            love.graphics.setColor(255, 255, 255)

            for i, asteroid in ipairs(asteroids) do
                love.graphics.draw(asteroid.image, asteroid.x, asteroid.y,
                                   rotation)
            end
            rotation = rotation + 0.1
        else
            love.audio.stop(music)
            love.graphics.setColor(255, 0, 0)
            love.graphics.setFont(finalFont)
            love.graphics.print("THE END", winW / 2 - 150, winH / 2 - 50) -- Lo centramos manualmente debido a la posición del eje.
            love.graphics.print("SCORE   "..score, winW / 2 - 150, winH / 2 + 70) -- Lo centramos manualmente debido a la posición del eje.
        end
    end
end