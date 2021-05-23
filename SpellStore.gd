extends Node

var spells = [
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
