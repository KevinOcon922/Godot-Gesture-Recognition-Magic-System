extends Node2D

@onready var gesture_recognizer: Node2D = $"../GestureRecognizer"

var spells = {
	"spawn_block": preload("res://spells/spawn_block_spell.tres")
}

@onready var spell_sequence: Array
@onready var spell_power = 1
@onready var duration_boost = 1
@onready var extra_mod = "NULL"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gesture_recognizer.spell_cast.connect(_on_spell_cast)

func _process(delta: float) -> void:
	for spell in spells.values():
		spell.update(delta)

func apply_buffs():
	for i in range(0, spell_sequence.size()):
		if spells[spell_sequence[i]].is_buff:
			if spell_sequence[i] == "boost":
				spell_power += 0.5
			elif spell_sequence[i] == "lengthen":
				duration_boost != 0.5
			else:
				if extra_mod != "NULL":
					extra_mod = spell_sequence[i]
				else:
					return -1
		else:
			return i
	return spell_sequence.size() - 1

func clear_buffs():
	spell_power = 1
	duration_boost = 1
	extra_mod = "NULL"

func multi_cast(index: int, main_node: Node2D, location: Vector2):
	var temp = spells[spell_sequence[index]]
	
	for i in range(index + 1, spell_sequence.size() - 1):
		if spell_sequence[i] in temp:
			temp = temp[spell_sequence[i]]
		else:
			clear_buffs()
			spell_sequence.clear()
			return false
	
	if spell_sequence[spell_sequence.size() - 1] in spells:
		spells[spell_sequence[spell_sequence.size() - 1]].cast(main_node, location, spell_power, duration_boost, extra_mod)
		clear_buffs()
		spell_sequence.clear()
		return true
	
	clear_buffs()
	spell_sequence.clear()
	return false

func _on_spell_cast(spell_name: String, main_node: Node2D, location: Vector2):
	if spell_name in spells:
		if spells[spell_name].is_castable:
			if spell_sequence.size() == 0:
				spells[spell_name].cast(main_node, location, spell_power, duration_boost, extra_mod)
				print("Spell Cast: " + spell_name)
				print(location)
			else:
				spell_sequence.push_back(spell_name)
				var end_of_buffs_index = apply_buffs()
				multi_cast(end_of_buffs_index, main_node, location)
		else:
			print("NOT CASTABLE: " + spell_name)
			if spell_sequence.size() < 4:
				spell_sequence.push_back(spell_name)
			else:
				# error
				spell_sequence.clear()
	else:
		spell_sequence.clear()
