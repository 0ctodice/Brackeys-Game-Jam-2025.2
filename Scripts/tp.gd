extends Area2D
class_name TP

@export var destination : TP
@export var active : bool
var just_tp : bool = false
@onready var size : Vector2 = get_viewport_rect().size
@onready var camera :Camera2D = get_parent().get_node("Camera2D")

func _ready():
	toggle_tp(active)

func toggle_tp(state: bool) -> void :
	active = state
	destination.active = !state
func _on_body_entered(body):
	if !active : return
	if body.has_method("tp") : body.tp(destination.global_position)
	var current_cell : Vector2 = (destination.global_position / size).floor()
	camera.global_position = Vector2i(current_cell * size)
	just_tp = true
func _on_body_exited(body):
	if !just_tp :
		toggle_tp(true)
	just_tp = !just_tp
