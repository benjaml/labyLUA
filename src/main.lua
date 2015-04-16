function love.load( args )
	math.randomseed(os.time())
	dungeon = require("dungeon")
	d = dungeon.new()
	d:generate()
end

function love.update(dt)

end

function love.draw()
	for i=1,d.width do
		for j=1,d.height do
			if d:getTile(i,j) == 0 then
				--                       mode   top  left   w  h
				love.graphics.rectangle("fill", i*10 , j*10 , 10, 10)
			end
		end
	end
end

function love.keypressed( key )
	if key == "escape" then
		love.event.push("quit")
	end
	if key == "r" then
		d = dungeon.new()
		d:generate() 
	end
end