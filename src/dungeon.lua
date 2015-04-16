local dungeon_mt = {} -- meta de la classe dungeon

-- classe dungeon
local dungeon = {}
local tile = require("tile")
local flan = require("flan")
	

-- fonction "statique" de la classe 
function dungeon.new(options)
	options = options or {}
	local self = setmetatable ({},{__index = dungeon_mt})

	self.data = {}
	self.roomColor = {}
	self.xsize = options.xsize or 50
	self.ysize = options.ysize or 50
	self.width = self.xsize*2 +1
	self.height = self.ysize*2 +1
	for i=1,self.width do
		for j=1,self.height do
			self:setTile(i,j,tile.new(tile.id.wall,-1))
		end
	end
	self.nbRoom = 0
	return self
end

function dungeon_mt:findCandidates(  )
	local candidate = {}
	local n_list = {
		{x= 1,y = 0},
		{x= -1,y = 0},
		{x= 0,y = 1},
		{x= 0,y = -1}
	}
	for i=2,self.width-1 do
		for j=2,self.height-1 do
			if self:getTile(i,j).id == tile.id.room then
				for _,v in ipairs(n_list) do
					if self:getTile(i+v.x,j+v.y).id == tile.id.wall and
					self:getTile(i+v.x*2,j+v.y*2).id ~= tile.id.wall then
						table.insert(candidate,{
							x = i+v.x,
							y = j+v.y,
							connects = {
								self:getTile(i,j).group,
								self:getTile(i+v.x*2,j+v.y*2).group,
							}
						})
					end
				end
			end
		end
	end
	return candidate


end


-- fonction de la classe
function dungeon_mt:generateAlea( )
	for i=1,self.width do
		for j=1,self.height do
			self:setTile(i,j,math.random(0,1))
		end
	end

end




function dungeon_mt:generate( )
	self:placeRooms(150)
	--self:generateMaze(math.random(1,self.xsize)*2, math.random(1,self.ysize)*2)
	for i=1,self.xsize do
		for j=1,self.ysize do
			self:generateMaze(i*2,j*2)
		end
	end

end

function dungeon_mt:placeRoom(x,y,w,h,group)
	
	for i = x,x+w do
		for j=y,y+h do
			self:setTile(i,j,tile.new(tile.id.room,group))
		end
	end

end

function dungeon_mt:placeRooms(max_failed)
	local failed = 0
	local group = 1
	while failed < max_failed do
		local w = math.random(1,3)
		local h = math.random(1,3)
		local x = math.random(1,self.xsize-w)
		local y = math.random(1,self.ysize-h)
		local nope = false
		for i = x*2,x*2+w*2 do
			for j=y*2,y*2+h*2 do
				if self:getTile(i,j).id ~= tile.id.wall then
					nope = true
					break
				end
				if nope then
					break
				end
			end
		end
		if nope then
			failed = failed +1
		else
			self:placeRoom(x*2,y*2,w*2,h*2,group)
			group = group +1
		end
	end
	self.nbRoom = group
	while #self.roomColor < self.nbRoom do
		table.insert(self.roomColor, {r=math.random()*255,g=math.random()*255,b=math.random()*255})
	end

end


local shuffle = function (array)
	local s_array = {}
	while #array > 0 do
		local i = math.random(1,#array)
		table.insert(s_array, array[i])
		table.remove(array,i)
	end
	return s_array
end
function dungeon_mt:generateMaze(x,y)

	if self:getTile(x,y).id ~= tile.id.wall then
		return
	end
	self:setTile(x,y,tile.new(tile.id.floor,0))
	local n_list = {
		{x= 1,y = 0},
		{x= -1,y = 0},
		{x= 0,y = 1},
		{x= 0,y = -1}
	}
	n_list = shuffle(n_list)
	for i,v in ipairs(n_list) do
		local nx = (x+2*v.x)
		local ny = (y+2*v.y)
		if(nx > 0) and nx<self.width and ny >0 and ny < self.height and self:getTile(nx,ny).id == tile.id.wall then
			self:setTile(x+v.x,y+v.y,tile.new(tile.id.floor,0))
			self:generateMaze(nx,ny)
		end
	end
end

function dungeon_mt:getTile(x,y)
	local X = ((x-1)%self.width)+1
	local Y = ((y-1)%self.height)+1
	return self.data[((X-1)+((Y-1)*self.width))+1]
end

function dungeon_mt:setTile(x,y,tile)
	local X = ((x-1)%self.width)+1
	local Y = ((y-1)%self.height)+1
	self.data[((X-1)+((Y-1)*self.width))+1] = tile
end

function dungeon_mt:makeConnections(  )
	local cands = self:findCandidates()
	local f = flan.new()
	local connections = {}
	cands = shuffle(cands)
	for _,v in ipairs(cands) do
		local c1 = v.connects[1]
		local c2 = v.connects[2]
		if not f:isConnected(c1,c2) then
			self:setTile(v.x,v.y,tile.new(tile.id.floor,0))
			f:connect(c1,c2)
		end
	end	
end


local contains = function(array,elem)
	for i,v in ipairs(array) do
		if v == elem then
			return true
		end
	end
end



return dungeon


