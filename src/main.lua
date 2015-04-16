function love.load( args )
	math.randomseed(os.time())
	dungeon = require("dungeon")
	tile = require("tile")
	flan = require("flan")
	d = dungeon.new()
	d:generate()
	love.graphics.setBackgroundColor(102,51,0)
end

function love.update(dt)

end

function love.draw()
	for i=1,d.width do
		for j=1,d.height do
			if d:getTile(i,j).id == 0 then
				love.graphics.setColor(0,123,0)	
			elseif d:getTile(i,j).id == 1 then
				love.graphics.setColor(102,51,0)
			elseif d:getTile(i,j).id == 2 then
				love.graphics.setColor(d.roomColor[d:getTile(i,j).group].r,d.roomColor[d:getTile(i,j).group].g,d.roomColor[d:getTile(i,j).group].b)
			elseif d:getTile(i,j).id == 3 then
				love.graphics.setColor(255,255,255)
			end
			--                       mode   top  left   w  h
			love.graphics.rectangle("fill", i*10 , j*10 , 10, 10)
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
	if key == " " then
		cands = d:findCandidates()
		for i,v in ipairs(cands) do
			d:setTile(v.x,v.y,tile.new(tile.id.candidat,-10))
		end
	end
	
end