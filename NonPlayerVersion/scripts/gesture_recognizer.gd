@tool
extends Node2D

@onready var gestures_path: String = "res://addons/Gesture_recognizer/resources/gestures/"
@onready var test_path: String = "res://addons/Gesture_recognizer/resources/testers/"

var drawing_points = []
var is_drawing = false
var recognizer = GestureRecognizer.new()
var min_score_limitation = 0.72
var current_gesture_id = 0 
var stroke_timer = Timer.new()
var recognize_timer = Timer.new()

var max_points = 500
var min_points = 10
var invalid_characters = ["/", "\\", ":", "*", "?", "\"", "<", ">", "|"]

var _recognition_thread: Thread = null
var _recognition_result: Dictionary = {}
var _is_recognizing: bool = false

var timer_skipped = false

@onready var main_node: Node2D = $"."

signal spell_cast(spell_name: String, main_node: Node2D, position: Vector2)

func _ready():
	add_child(stroke_timer)
	stroke_timer.wait_time = 5.0  # seconds for multi-stroke
	stroke_timer.one_shot = true
	stroke_timer.connect("timeout", Callable(self, "_on_stroke_timeout"))
	
	#drawing_area.connect("gui_input", Callable(self, "_on_drawing_area_input"))

	recognizer.LoadGesturesFromResources(gestures_path)
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if stroke_timer.is_stopped() and drawing_points.size() > 0:
				drawing_points.clear()
				current_gesture_id = 0
				queue_redraw()
			is_drawing = true
			timer_skipped = false
			stroke_timer.stop()
			drawing_points.append([])
			queue_redraw()
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if not timer_skipped:
				is_drawing = false
				current_gesture_id += 1
				stroke_timer.start()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			timer_skipped = true
			_recognize_gesture()
			is_drawing = false
			#_is_recognizing = false
			stroke_timer.stop()
			#result_label.text = ""
			#current_gesture_id = 0
			#if _recognition_thread and _recognition_thread.is_active():
			#	_recognition_thread.wait_to_finish() 
			#	_recognition_thread = null
			#queue_redraw()
	elif event is InputEventMouseMotion and is_drawing:
		#if drawing_area.get_rect().has_point(drawing_area.get_local_mouse_position()):
			if _get_flattened_points().size() >= max_points:
				#result_label.text = "Error: Maximum number of points reached."
				is_drawing = false
				return
			
			#var local_position = drawing_area.get_local_mouse_position()
			var local_position = get_local_mouse_position()
			var new_point = recognizer.Point.new(local_position.x, local_position.y, current_gesture_id)
			drawing_points[-1].append(new_point)
			queue_redraw()
	
func _draw():
	for stroke in drawing_points:
		var line := Line2D.new()
		line.width = 10
		line.default_color = Color(1.5, 3.0, 6.0)
		line.joint_mode = Line2D.LINE_JOINT_ROUND
		line.begin_cap_mode = Line2D.LINE_CAP_ROUND
		line.end_cap_mode = Line2D.LINE_CAP_ROUND
		
		var outline := Line2D.new()
		outline.width = 22
		outline.default_color = Color.BLACK
		outline.joint_mode = Line2D.LINE_JOINT_ROUND
		outline.begin_cap_mode = Line2D.LINE_CAP_ROUND
		outline.end_cap_mode = Line2D.LINE_CAP_ROUND
		add_child(outline)
		add_child(line)
		for i in range(stroke.size() - 1):
			var start_point = Vector2(stroke[i].x, stroke[i].y)
			var end_point = Vector2(stroke[i + 1].x, stroke[i + 1].y)
			line.add_point(start_point)
			outline.add_point(start_point)

func _on_stroke_timeout():
	_recognize_gesture()
	if _is_recognizing == false:
		drawing_points.clear()
		queue_redraw()
		current_gesture_id = 0

func _recognize_gesture():
	if _is_recognizing:
		return
		
	var total_points = 0
	for stroke in drawing_points:
		total_points += stroke.size()
		
	if total_points < min_points:
		#result_label.text = "Error: Not enough points, draw a longer line."
		remove_lines()
		drawing_points.clear()
		is_drawing = false
		pass
	else:
		#result_label.text = "Recognizing..."
		_is_recognizing = true
		_recognition_result = {}
		await get_tree().process_frame
		_recognition_thread = Thread.new()
		_recognition_thread.start(Callable(self, "_run_recognition"))

func _run_recognition():
	var flattened_points = _get_flattened_points()
	recognize_timer = Time.get_ticks_msec()
	_recognition_result = recognizer.Recognize(flattened_points, min_score_limitation)
	call_deferred("_on_recognition_complete")

func _get_flattened_points() -> Array:
	var flattened_points = []
	for stroke in drawing_points:
		flattened_points += stroke 
	return flattened_points

func _on_recognition_complete():
	if _recognition_result.size() > 0:
		var rounded_score = String("%.3f" % _recognition_result["score"])
		
		var end_time = Time.get_ticks_msec()
		var recognized_time = end_time - recognize_timer
		var string_time = String("%.0f" % recognized_time)
		print("Recognized as: " + _recognition_result["name"] + " (Score: " + rounded_score + ", Time: " + string_time + " ms)")
		spell_cast.emit(_recognition_result["name"], main_node, get_global_mouse_position())
		remove_lines()
	
	_recognition_thread.wait_to_finish()
	_recognition_thread = null
	_is_recognizing = false
	current_gesture_id = 0

func _score():
	recognizer.RunRecognitionBatch("res://addons/Gesture_recognizer/resources/test_NP32_LS32/", "res://addons/Gesture_recognizer/resources/testers_NP32_LS32/", "res://addons/Gesture_recognizer/resources/recognition_results3232.csv")

func remove_lines():
	for child in get_children():
		if child is Line2D:
			child.queue_free()
