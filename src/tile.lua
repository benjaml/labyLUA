local tile_mt = {}
local tile = {}
tile.id = {
	wall = 0,
	floor = 1,
	room = 2,
	candidat = 3

}
function tile.new(id,group)
	local self = setmetatable({},{__index = tile_mt})	
	self.id = id or tile.id.wall
	self.group = group

	self.connections = {}

	return self
end

return tile