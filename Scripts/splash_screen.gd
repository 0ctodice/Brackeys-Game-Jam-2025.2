extends Node2D

enum {FADEIN, FADEOUT, NEXT_SCENE}
var state = FADEOUT
var tween : Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	load_scene()

func load_scene() :
	match(state) :
		FADEOUT :
			fade_out()
		FADEIN :
			fade_in()
		NEXT_SCENE :
			get_tree().change_scene_to_file("res://Scenes/scene_manager.tscn")
			
func fade_out() -> void :
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Control/ColorRect, "color", Color("2a2a2a", 0.0),1)
	tween.parallel().tween_property($LOGO, "scale", $LOGO.scale * 1.3, 5)
	$Timer.start(2)
	state = FADEIN
	
func fade_in() -> void :
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Control/ColorRect, "color", Color("2a2a2a", 1.0),1)
	$Timer.start(1)
	state = NEXT_SCENE
