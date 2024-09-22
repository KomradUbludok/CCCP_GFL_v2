function Create(self)
	self.SkillSound = CreateSoundContainer("AKM Skill", "GFLRu.rte")
	self.SkillActivateSound = CreateSoundContainer("Explosive Device Activate", "Base.rte")
	self.SkillCooldownTime = 8000
	self.SkillDurationTime = 5000
	self.SkillCooldown = Timer(self.SkillCooldownTime)
	self.SkillDuration = Timer(self.SkillDurationTime)
	self.DMG_Increase = 35
	self.ACC_Increase = 100
	self.RTF_Increase = 0
	self.flag = false
end
--DMG 35% ACC 100% duration 5s cooldown 8s

function Update(self)
	local dmg_mod = self.DMG_Increase / 100
	local acc_mod = self.ACC_Increase / 100
	local rtf_mod = self.RTF_Increase / 100
	--print(self.SkillDuration.ElapsedSimTimeMS)
	if self.EquippedItem and self.EquippedItem.PresetName == "AKM" then
		local weapon = ToHDFirearm(self.EquippedItem)
		if weapon.Magazine and weapon.Magazine.RoundCount >= 1 then
			if self.flag == false then
			self.org_mass = weapon.Magazine.NextRound.NextParticle.Mass
			self.org_sharp = weapon.Magazine.NextRound.NextParticle.Sharpness
			self.org_shake = weapon.ShakeRange
			self.org_sharpshake = weapon.SharpShakeRange
			self.org_rtf = weapon.RateOfFire
			self.flag = true
			end
			if self.SkillDuration:IsPastSimMS(self.SkillDurationTime) then
				weapon.Magazine.NextRound.NextParticle.Mass = self.org_mass
				weapon.Magazine.NextRound.NextParticle.Sharpness = self.org_sharp
				weapon.ShakeRange = self.org_shake
				weapon.SharpShakeRange = self.org_sharpshake
				weapon.RateOfFire = self.org_rtf
			end
			self.controller = self:GetController();
			if self:IsPlayerControlled() and UInputMan:KeyPressed(Key.Z) and self.SkillCooldown:IsPastSimMS(self.SkillCooldownTime) then
				self.SkillSound:Play(self.Pos)
				self.SkillCooldown:Reset()
				self.SkillDuration:Reset()
				self.SkillActivateSound:Play(self.Pos)
				self:FlashWhite(200)
				weapon.Magazine.NextRound.NextParticle.Mass = weapon.Magazine.NextRound.NextParticle.Mass + dmg_mod * weapon.Magazine.NextRound.NextParticle.Mass
				weapon.Magazine.NextRound.NextParticle.Sharpness = weapon.Magazine.NextRound.NextParticle.Sharpness + dmg_mod * weapon.Magazine.NextRound.NextParticle.Sharpness
				weapon.ShakeRange = weapon.ShakeRange - acc_mod * weapon.ShakeRange
				weapon.SharpShakeRange = weapon.SharpShakeRange - acc_mod * weapon.SharpShakeRange
				weapon.RateOfFire = weapon.RateOfFire + rtf_mod * weapon.RateOfFire
				print(weapon.Magazine.NextRound.NextParticle.Mass)
			end
		end
	end
end