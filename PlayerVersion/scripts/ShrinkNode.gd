extends Node2D

@onready var timer: Timer = $Timer
var ORIGINAL_SCALE_X
var ORIGINAL_SCALE_Y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ORIGINAL_SCALE_X = get_parent().scale.x
	ORIGINAL_SCALE_Y = get_parent().scale.y
	get_parent().scale.x = 0.25
	get_parent().scale.y = 0.25
	timer.start()
	
	timer.timeout.connect(revert)

func revert():
	get_parent().scale.x = ORIGINAL_SCALE_X
	get_parent().scale.y = ORIGINAL_SCALE_Y
	queue_free()
