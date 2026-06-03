extends SpellResource
class_name JumpSpell

@export var jump_spell_velocity = -600

func cast(caster: CharacterBody2D, location: Vector2, spell_power: float, duration_boost: float, extra_mod: String):
	if ready_to_cast:
		caster.velocity.y = jump_spell_velocity * spell_power
		
		current_cooldown = max_cooldown
		ready_to_cast = false
