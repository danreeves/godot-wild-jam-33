extends Node

export (Resource) var next_scene = null

enum Elements {
	None,
	Fire,
	Grass,
	Water,
}

const ElementColor = {
	Elements.None: Color.beige,
	Elements.Fire: Color.firebrick,
	Elements.Grass: Color.forestgreen,
	Elements.Water: Color.dodgerblue,
}

const ElementAnim = {
	Elements.None: "attack",
	Elements.Fire: "fire",
	Elements.Water: "water",
	Elements.Grass: "grass",
}

const attack_anims = ["attack", "fire", "water", "grass"]
