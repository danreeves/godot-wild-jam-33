extends Node

var spells = [
	Heal,
	ToFire,
	ToWater,
	ToGrass,
	Fear,
	Haste,
	Slow,
	Blind
]

export (Array) var purchased = [
	Heal
] 

func purchase(spell):
	if !purchased.has(spell):
		purchased.append(spell)
