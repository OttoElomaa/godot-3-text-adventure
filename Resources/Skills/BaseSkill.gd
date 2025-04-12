extends Resource


export (String) var skill_name = "SkillName"
export (String, MULTILINE) var description = "SkillDescription"

enum Targeting {
	FRIENDLY, HOSTILE, NEUTRAL
}

enum SkillTypes {
	BasicAttack, BasicHeal
}

enum StatusEffects {
	NONE, POISON, STUN
}



#### This value defines the amount of TIME units it takes to cast.
#### Goal is to have speed/turn system where X amount of time units pass each turn

export (Targeting) var targeting = Targeting.HOSTILE
export (SkillTypes) var skill_type = SkillTypes.BasicAttack

export (int) var damage = 0
export (int) var healing = 0
export (int) var cooldown = 0

export (int) var time_cost = 0

export (bool) var has_status_effect = false 
export (StatusEffects) var status_effect = StatusEffects.NONE
export (String) var status_effect_str = "StatusEffect" 
export (int) var status_duration = 0
export (int) var status_amount = 0
