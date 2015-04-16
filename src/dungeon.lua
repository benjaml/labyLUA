local dungeon_mt = {} -- meta de la classe dungeon

-- classe dungeon
local dungeon = {}

	dungeon.tiles = {
		wall = 0,
		floor = 1
	}

	-- fonction "statique" de la classe 
	function dungeon.new(options)
		options = options or {}
		local self = setmetatable ({},{__index = dungeon_mt})

		self.data = {}
		self.xsize = options.xsize or 50
		self.ysize = options.ysize or 50
		self.width = self.xsize*2 +1
		self.height = self.ysize*2 +1

		return self
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
		self:placeRooms(1500)
		self:generateMaze(math.random(1,self.xsize)*2, math.random(1,self.ysize)*2)

	end

	function dungeon_mt:placeRoom(x,y,w,h)
		for i = x,x+w do
			for j=y,y+h do
				self:setTile(i,j,dungeon.tiles.floor)
			end
		end

	end

	function dungeon_mt:placeRooms(max_failed)
		local failed = 0
		while failed < max_failed do
			local w = math.random(1,3)
			local h = math.random(1,3)
			local x = math.random(1,self.xsize-w)
			local y = math.random(1,self.ysize-h)
			local nope = false
			for i = x*2,x*2+w*2 do
				for j=y*2,y*2+h*2 do
					if self:getTile(i,j) ~= dungeon.tiles.wall then
						nope = true
						break
					end
					if nope then
						break
					end
				end
				if nope then
					failed = failed +1
				else
					self:placeRoom(x*2,y*2,w*2,h*2)
				end
			end
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
		self:setTile(x,y,dungeon.tiles.floor)
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
			if(nx > 0) and nx<self.width and ny >0 and ny < self.height and self:getTile(nx,ny) == dungeon.tiles.wall then
				self:setTile(x+v.x,y+v.y,dungeon.tiles.floor)
				self:generateMaze(nx,ny)
			end
		end
	end

	function dungeon_mt:getTile(x,y)
		local X = ((x-1)%self.width)+1
		local Y = ((y-1)%self.height)+1
		return self.data[((X-1)+((Y-1)*self.width))+1] or dungeon.tiles.wall
	end

	function dungeon_mt:setTile(x,y,tile)
		local X = ((x-1)%self.width)+1
		local Y = ((y-1)%self.height)+1
		self.data[((X-1)+((Y-1)*self.width))+1] = tile
	end

return dungeon


