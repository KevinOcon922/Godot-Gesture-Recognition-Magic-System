extends SpellResource
class_name ShrinkToggleSpell

var shrink_node = preload("res://spell_nodes/shrink_toggle_node.tscn")

func cast(caster: CharacterBody2D, location: Vector2, spell_power: float, duration_boost: float, extra_mod: String):
	#Special spell, handled in spell manager
	var was_shrunk = false
	
	for child in caster.get_children():
		if child is ShrinkToggleNode:
			was_shrunk = true
			child.revert()
			break
	
	if not was_shrunk:
		caster.add_child(shrink_node.instantiate())
