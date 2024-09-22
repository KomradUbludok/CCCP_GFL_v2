function Create(self)
	self.WasSoundPlayed = false
	self.SelectSound = CreateSoundContainer(self.PresetName .. " Select", "GFLRu.rte");
end

function Update(self)
	self.controller = self:GetController();
	if self:IsPlayerControlled() and self.WasSoundPlayed == false and self.SelectSound:IsBeingPlayed() == false then
		self.SelectSound:Play(self.Pos)
		self.WasSoundPlayed = true
	elseif self:IsPlayerControlled() == false and self.SelectSound:IsBeingPlayed() == false then
		self.WasSoundPlayed = false
	end
end