speed = 150
bottomY = 420
playerFloorY = 370
jumpAccel = 16
initGravity = 200

counter = 0
obstacles = {}--aray
lastTimeObstacle = 100

gravity = 200
jumpSDN = nil
hitSDN = nil
pointSDN = nil

player = { x = 100, y = playerFloorY, jumping = false, accel = jumpAccel, img = nil}--objeto
font = nil
isGameOver = false

function love.load()
	player.img = love.graphics.newImage("dude.png")
	love.graphics.setBackgroundColor(35,159,225)
	jumpSDN = love.audio.newSource("Jump2.wav")
	hitSDN = love.audio.newSource("hit.wav")
	font = love.graphics.newFont(35)
end

function love.update(dt)
	--exit game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
	--main loop
end

function  love.draw()
end