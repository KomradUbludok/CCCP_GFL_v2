function Create(self)
	for att in self.Head.Attachables do
		--print(att)
		if att.PresetName == "Brain Module" then
			self.Brain = att
		end
	end
	self.AliveTimeLimit = 30000
	self.DieTimer = Timer(self.AliveTimeLimit)
	self.IsAboutToDie = false
	self.CoreIsDamaged = false
	self.CoreDamageChanges = false
end

function Update(self)
	if self:IsPlayerControlled() and UInputMan:KeyPressed(Key.Z) then
		self.Brain:GibThis()
		print("check1")
	end
	for mo in MovableMan:GetMOsInRadius(self.Brain.Pos, 6.5, self.Team) do
		if
			mo.HitsMOs == true
			and mo.Vel.Magnitude > 15
			and (mo.Sharpness > 1 and (IsMOPixel(mo) or IsMOSParticle(mo)))
			and (mo:GetWhichMOToNotHit() == nil
			or (mo:GetWhichMOToNotHit() ~= nil and mo:GetWhichMOToNotHit().UniqueID ~= self.UniqueID))
		then
			self.Brain:GibThis()
		end
	end
	for mo in MovableMan:GetMOsInRadius(self.Pos + Vector(2, -2), 8.5, self.Team) do
		if
			mo.HitsMOs == true
			and mo.Vel.Magnitude > 15
			and (mo.Sharpness > 1 and (IsMOPixel(mo) or IsMOSParticle(mo)))
			and (mo:GetWhichMOToNotHit() == nil
			or (mo:GetWhichMOToNotHit() ~= nil and mo:GetWhichMOToNotHit().UniqueID ~= self.UniqueID))
		then
			self.CoreIsDamaged = true
		end
	end
	if self.CoreIsDamaged == true and self.EquippedItem:IsWeapon() then
		PrimitiveMan:DrawTextPrimitive(self.Pos + Vector(0, 20), "Core damaged!", true, 1)
		if self.CoreDamageChanges == false then
			local weapon = ToHDFirearm(self.EquippedItem)
			weapon.BaseReloadTime = weapon.BaseReloadTime * 2
			weapon.SharpLength = math.sqrt(weapon.SharpLength, 2)
			print(weapon.BaseReloadTime)
			self.CoreDamageChanges = true
		end
	end
	if not self.Brain:IsAttached() and self then
		if self.IsAboutToDie == false then
			self.DieTimer:Reset()
			self.IsAboutToDie = true
		end
		--self.Status = Actor.DEAD
		PrimitiveMan:DrawTextPrimitive(self.AboveHUDPos + Vector(0, -15), "Brain damaged!", true, 1)
		PrimitiveMan:DrawTextPrimitive(self.AboveHUDPos + Vector(0, -5), string.format("Shutdown in %s", math.floor(self.DieTimer:LeftTillSimTimeLimitS())), true, 1)
		self.Perceptiveness = 0
		self.PlayerControllable = false
		if self.DieTimer:IsPastSimMS(self.AliveTimeLimit) then
			self.Health = 0
		end
	end
end