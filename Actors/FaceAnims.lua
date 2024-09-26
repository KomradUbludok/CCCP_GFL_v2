function Create(self)
	self.TimeLimit = 500000
	self.RandomTimer = Timer(self.TimeLimit)
	self.AnimationTimer = Timer(300)
	self.Injured = false
	self.HeavilyInjured = false
	self.Blinking = false
	self.Frame = 0
	self.HeavyInjuryHealthLimit = 60
	self.InjuryHealthLimit = 75
	self.Human = ToAHuman(self:GetRootParent())
end

function Update(self)
	local time = math.random(self.TimeLimit)
	if self then
		if self.AnimationTimer:IsPastSimMS(25) and self.Blinking == true then
			self.Frame = 1
			if self.AnimationTimer:IsPastSimMS(100) then
				self.Frame = 2
				if self.AnimationTimer:IsPastSimMS(200) then
					self.Frame = 0
					self.Blinking = false
				end
			end
		end
		if self.RandomTimer:IsPastSimMS(time) and self.Injured == false and self.HeavilyInjured == false and self.Blinking == false then
			self.AnimationTimer:Reset()
			self.RandomTimer:Reset()
			self.Blinking = true
		end
		if self.Human.Health < self.InjuryHealthLimit and self.Human.Health >= self.HeavyInjuryHealthLimit and self.Injured == false then
			self.Frame = 3
			self.Injured = true
		end
		if self.Human.Health < self.HeavyInjuryHealthLimit and self.HeavilyInjured == false then
			self.Frame = 4
			self.HeavilyInjured = true
		end
	end
end