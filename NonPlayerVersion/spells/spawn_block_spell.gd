extends SpellResource
class_name SpawnBlockSpell

func cast(main_node: Node2D, location: Vector2, spell_power: float, duration_boost: float, extra_mod: String):
	var new_block = Node2D.new()
	var new_rect = ColorRect.new()
	new_rect.color = Color(0.2, 0.2, 0.2)
	new_rect.set_position(location)
	new_rect.size = Vector2(200, 200)
	new_block.add_child(new_rect)
	
	main_node.add_child(new_block)
