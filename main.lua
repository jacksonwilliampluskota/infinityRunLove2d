anim = require ("lib/anim8")
local animation
playerChaoY=370
aceleracaoPulo = 16
gravidadeInicial = 200

pontos = 0
obstaculos = {}
lastTimeObstaculo = 1000

gravidade = 200
puloSND = nil
hitSND = nil
pontoSND = nil
trilhaSND = nil
player = { x = 26, y = playerChaoY,jumping = false, accel = aceleracaoPulo, img = nil }
font = nil
isGameOver = false

function love.load()
	--para ver o console no windows
	--love._openConsole()--console para debugar
	love.mouse.setVisible(false)--para nao aparecer o mouse
   player.img = love.graphics.newImage("imagens/stickman.png")
   local g = anim.newGrid(26, 50, player.img:getWidth(), player.img:getHeight())
   love.graphics.setBackgroundColor(122,195,255)
   puloSND = love.audio.newSource("sounds/Jump2.wav")
   hitSND = love.audio.newSource("sounds/hit.wav")
   pontoSND = love.audio.newSource("sounds/point.wav")
   trilhaSND = love.audio.newSource("sounds/trilha.mp3")
   font = love.graphics.newFont(35)
   animation = anim.newAnimation(g('1-9' , 1, '1-9' , 2,'1-9' , 3,'1-9' , 4,'1-9' , 5,'1-9' , 6, '1-9' , 7, '1-7' , 8 ), 0.01)
   trilhaSND:setLooping(true)
   trilhaSND:play()

end

function love.update(dt)

	-- exit game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	-- main loop
	if isGameOver == false then
		-- input
		if love.keyboard.isDown('up','space') and player.jumping == false then
			love.audio.play(puloSND)
			player.jumping = true
		end

		--player is jumping
		if player.jumping and player.accel > 0 then
			player.y = player.y - player.accel
			player.accel = player.accel - 1
		end

		--gravidade
		if player.y < playerChaoY then
			player.y = player.y + gravidade*dt;
			gravidade = gravidade + 10;
		end

		if player.y > playerChaoY then
			player.y = playerChaoY
		end

		if player.y == playerChaoY then
			player.jumping = false
			player.accel = aceleracaoPulo
			gravidade = gravidadeInicial
			animation : update( dt )
		end

		--gera obstaculos
		lastTimeObstaculo = lastTimeObstaculo - 10
		if lastTimeObstaculo <= 0 then
			lastTimeObstaculo = love.math.random(200,700)

			newObstacle= { x = 640, y = 370, width = 25, height = 50, contou = false}
			table.insert(obstaculos, newObstacle)
		end

		--retira obstaculos
		for i, obstaculo in ipairs(obstaculos) do
			obstaculo.x = obstaculo.x - 10
			--remover o obstaculo quando sair da tela
			if obstaculo.x < 0 then
				table.remove(obstaculo, i)
			end

			--obstaculo past player counts 1 point
			if obstaculo.contou == false and obstaculo.x < player.x then
				obstaculo.contou = true
				pontos = pontos + 1
				love.audio.play(pontoSND)
			end
		end

		--checks collisions with player
		for i, obstaculo in ipairs(obstaculos) do
			if CheckCollision(player.x,player.y,player.img:getWidth()/9,player.img:getHeight()/8,obstaculo.x,obstaculo.y,obstaculo.width,obstaculo.height) then
				isGameOver = true
				love.audio.play(hitSND)
			end
		end
	end

	if isGameOver and love.keyboard.isDown('r') then
		obstaculos = {}

		playerChaoY=370
		aceleracaoPulo = 16
		gravidadeInicial = 200

		pontos = 0
		obstaculos = {}
		lastTimeObstaculo = 1000

		gravidade = 200
		player = { x = 26, y = playerChaoY,jumping = false, walking=true, accel = aceleracaoPulo, img = love.graphics.newImage("imagens/stickman.png") }
		isGameOver = false

	end
end

function love.draw()

	--ddesenha player
	animation:draw(player.img, player.x, player.y, 50, 1, 1, 14, 0)

	--desenha chao
	love.graphics.setColor(64,199,84)
	love.graphics.rectangle('fill', 0, 420, 640, 60)

	--desenha sol
	love.graphics.setColor(255,255,51)
	love.graphics.circle("fill", 550, 70, 40, 100)

    --desenha pontos de pulos
    love.graphics.setColor(94,117,113)
    love.graphics.setFont(font)
   	love.graphics.print(pontos, 300, 200)

   	if (isGameOver) then
   		love.graphics.setColor(94,117,113)
   		love.graphics.print("GAME OVER", 220, 100)
   		love.graphics.setColor(0,0,0)
	  	love.graphics.setFont(love.graphics.newFont(25))
   		love.graphics.print("Precione 'R' para reiniciar", love.graphics:getWidth()/2-170, love.graphics:getHeight()/1.5)
   	end

    -- desenha obstaculos
	for i, obstaculo in ipairs(obstaculos) do
	  love.graphics.setColor(255,0,0)
	  love.graphics.rectangle('fill', obstaculo.x, obstaculo.y, obstaculo.width, obstaculo.height);
	end
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end