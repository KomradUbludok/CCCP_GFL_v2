function Create(self)
	self.SkillSound = CreateSoundContainer("AKM Skill", "GFLRu.rte")
	self.SkillActivateSound = CreateSoundContainer("Explosive Device Activate", "Base.rte")
	self.SkillCooldown = 50000
	self.SkillInitialCooldown = 50000
	self.SkillDuration = 10000
	self.SkillCooldown = Timer(self.SkillCooldown)
	self.SkillPercent = 60 / 100
end

function Update(self)
	if self.EquippedItem and self.EquippedItem.PresetName == "AKM" then
		local weapon = ToHDFirearm(self.EquippedItem)
		self.controller = self:GetController();
		if self:IsPlayerControlled() and UInputMan:KeyPressed(Key.Z) and self.SkillCooldown:IsPastSimMS(self.SkillCooldownDuration) then
			self.SkillSound:Play(self.Pos)
			self.SkillCooldown:Reset()
			self.SkillActivateSound:Play(self.Pos)
			self:FlashWhite(200)
			weapon.RateOfFire = weapon.RateOfFire + (weapon.RateOfFire * self.SkillPercent)
		end
	end
end

--Skill: Rate of fire increase