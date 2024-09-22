function Create(self)
	self.EvasionTimer = Timer()
	self.Evasion = self:NumberValueExists("Evasion") and self:GetNumberValue("Evasion") or 0
	self.AverageAccuracy = 80
	self.TimeInterval = 500
	self.State = 0 --just a flag, it doesnt change the state
end

local function EvasionMath(acc, eva)
	return 100 - (acc / (acc + eva) * 100)
end

function Update(self)
	local duration = math.random(self.TimeInterval) --how long it takes for another check
	local vector = Vector(math.random(-25,25), 5) --vector for miss particles position
	for mo in MovableMan:GetMOsInRadius(self.Pos, 55, self.Team) do
		if
			mo.HitsMOs == true
			and mo.Vel.Magnitude > 15
			and (mo.Sharpness > 1 and (IsMOPixel(mo) or IsMOSParticle(mo)))
			and (mo:GetWhichMOToNotHit() == nil
			or (mo:GetWhichMOToNotHit() ~= nil and mo:GetWhichMOToNotHit().UniqueID ~= self.UniqueID))
			and self.State == 1
		then
			local particle = CreateMOSParticle("Miss", "GFLRu.rte")
			particle.Pos = self.AboveHUDPos + vector
			MovableMan:AddParticle(particle)
			if mo then
				MovableMan:RemoveMO(mo)
			end
		end
	end
	if self.EvasionTimer:IsPastSimMS(duration) and math.random(100) <= EvasionMath(self.AverageAccuracy, self.Evasion)  then
		--self:FlashWhite(duration)
		self.GetsHitByMOs = false
		if self.Head then self.Head.GetsHitByMOs = false end
		if self.FGArm then self.FGArm.GetsHitByMOs = false end
		if self.BGArm then self.BGArm.GetsHitByMOs = false end
		if self.FGLeg then self.FGLeg.GetsHitByMOs = false end
		if self.BGLeg then self.BGLeg.GetsHitByMOs = false end
		self.State = 1
		self.EvasionTimer:Reset()
	elseif self.EvasionTimer:IsPastSimMS(duration) and math.random(100) > EvasionMath(self.AverageAccuracy, self.Evasion) then
		self.GetsHitByMOs = true
		if self.Head then self.Head.GetsHitByMOs = true end
		if self.FGArm then self.FGArm.GetsHitByMOs = true end
		if self.BGArm then self.BGArm.GetsHitByMOs = true end
		if self.FGLeg then self.FGLeg.GetsHitByMOs = true end
		if self.BGLeg then self.BGLeg.GetsHitByMOs = true end
		--I could do a for cycle but it changes all the attachables current actor has, like hats, hair, skirts... and they shouldnt be hitable
		self.State = 0
		self.EvasionTimer:Reset()
	end
end