extends SpellResource
class_name ShrinkSpell

var shrink_node = preload("res://spell_nodes/shrink_node.tscn")

func cast(caster: CharacterBody2D, location: Vector2, spell_power: float, duration_boost: float, extra_mod: String):
	#Special spell, handled in spell manager
	caster.add_child(shrink_node.instantiate())
