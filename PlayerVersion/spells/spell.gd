extends Resource
class_name SpellResource

@export var spell_name: String = "NULL_SPELL"
@export var max_cooldown: float = 5.0
@export var current_cooldown: float = 0
@export var ready_to_cast: bool = true
@export var is_castable: bool = true
@export var is_buff: bool = false

@export var current_power = 1
@export var duration_boost = 1
@export var max_duration = 0
@export var current_mod = "NULL"

func update(delta: float) -> void:
	if !ready_to_cast:
		if current_cooldown > 0:
			current_cooldown -= delta
		else:
			current_cooldown = 0
			ready_to_cast = true
			current_power = 1
			duration_boost = 1
			current_mod = "NULL"

func cast(caster: CharacterBody2D, location: Vector2, spell_power: float, duration_boost: float, extra_mod: String):
	pass
