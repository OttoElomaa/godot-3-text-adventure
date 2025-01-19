extends Resource


export (String) var skill_name = "SkillName"
export (String, MULTILINE) var description = "SkillDescription"

#### This value defines the amount of TIME units it takes to cast.
#### Goal is to have speed/turn system where X amount of time units pass each turn
export (int) var time_cost = 0

export (int) var damage = 0
export (int) var healing = 0

