local Item = {}

Item.new = function(name, loc, value, op)
	local self = {}

	self.name = name
	self.loc = loc
	self.value = value
	self.op = op

	function self.writeByte()
		memory.writebyte(self.loc, self.value)
	end

	function self.orByte()
		memory.writebyte(self.loc, bit.bor(memory.readbyte(self.loc), self.value))
	end

	function self.xorByte()
		memory.writebyte(self.loc, bit.bxor(memory.readbyte(self.loc), self.value))
	end

	function self.incByte(inc=1)
		memory.writebyte(self.loc, memory.readbyte(self.loc) + inc)
	end


	function self.update()
		if self.op == "w" then
			self.writeByte(self.value)
		elseif self.op == "o" then
			self.orByte(self.value)
		elseif self.op == "x" then
			self.xorByte(self.value)
		elseif self.op == "i" then
			self.incByte()
		else
			error("invalid item byte op '" .. self.value .. "'")
		end
	end

	function self.read()
		return memory.readbyte(self.loc)
	end

	return self
end

return Item