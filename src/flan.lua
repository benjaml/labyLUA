local flan_mt = {}
local flan = {}

function flan.new()
	self = setmetatable({},{__index = flan_mt})
	self.data = {}
	return self
end
function flan_mt:isConnected(a,b)
	if self.data[a] then
		for i,v in ipairs(self.data[a]) do
			if v == b then
				return true
			end
		end
	end
end

function flan_mt:connect(a,b)
	if not self.data[a] then
		self.data[a] = {}	
	end
	if not self.data[b] then
		self.data[b] = {}	
	end
	if not self:isConnected(a,b) then
		table.insert(self.data[a],b)
		table.insert(self.data[b],a)
		for i,v in ipairs(self.data[a]) do
			if not self:isConnected(v,b) then
				self:connect(v,b)
			end
		end
		for i,v in ipairs(self.data[b]) do
			if not self:isConnected(v,a) then
				self:connect(v,a)
			end
		end
	end
end


return flan