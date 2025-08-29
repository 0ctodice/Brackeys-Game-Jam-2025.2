extends Node2D

enum {FADEIN, FADEOUT, PLAYING, NEXT_SCENE, DEAD, CURRENT_SCENE, WAIT, CREDITS}

@export var scene_number : int
var current_scene_id = 5
var state = FADEOUT
var current_scene : Node2D
var player : Player
var chimney : Area2D
var tween : Tween
var the_end : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	load_first_scene()
func _on_timer_timeout():
	$Content/Timer.stop()
	match(state) :
		FADEIN :
			fade_in()
		FADEOUT :
			fade_out()
		PLAYING :
			if current_scene_id <= 5 and current_scene_id != 2 :
				var tutoSprite = player.get_node("TutoAnimatedSprite2D")
				tutoSprite.visible = true
				tutoSprite.play("Init")
				tutoSprite.connect("animation_finished", tuto_animation)
			else :
				player.can_walk = true
			state = WAIT
		NEXT_SCENE :
			state = FADEOUT
			load_scene(current_scene_id + 1)
		DEAD :
			fade_in_game_over()
		CURRENT_SCENE :
			state = FADEOUT
			load_scene(current_scene_id)
		WAIT :
			state = FADEIN
			$Content/Timer.start(1)
		CREDITS :
			pass
func load_first_scene() -> void :
	current_scene = load("res://Scenes/Level/Level" + str(current_scene_id) + ".tscn").instantiate()
	$CurrentScene.add_child(current_scene)
	player = current_scene.get_node("Player")
	chimney = current_scene.get_node("Chimney")
	player.get_node("ChildCollider").connect("body_entered", child_contact)
	chimney.connect("body_entered", on_chimney_entered)
	_on_timer_timeout()
func on_chimney_entered(body) :
	if body.has_cookie :
		$Content/AudioManager.play_fire_out()
		chimney.get_node("AnimatedSprite2D").visible = false
		body.can_walk = false
		_on_timer_timeout()
func load_scene(index : int) -> void :
	current_scene.queue_free()
	$CurrentScene.get_child(0).queue_free()
	current_scene_id = index
	if index != scene_number + 1:
		current_scene = load("res://Scenes/Level/Level"+ str(index) +".tscn").instantiate()
		player = current_scene.get_node("Player")
		chimney = current_scene.get_node("Chimney")
		player.get_node("ChildCollider").connect("body_entered", child_contact)
		chimney.connect("body_entered", on_chimney_entered)
		$Content/AudioManager.play_fireplace()
	else :
		current_scene = load("res://Scenes/credits.tscn").instantiate()
		the_end = true
	$CurrentScene.add_child(current_scene)
	_on_timer_timeout()
func child_contact(body) -> void :
	if player.get_node("AnimatedSprite2D").animation == "Drop_Gift" or body.is_opening_gift():
		return
	body.can_move = false
	state = DEAD
	player.can_walk = false
	$Content/Timer.start(1)
func fade_in() -> void :
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Content/Control/ColorRect, "color", Color("2a2a2a", 1.0),.75)
	$Content/Timer.start(1)
	state = NEXT_SCENE
func fade_out() -> void :
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Content/Control/ColorRect, "color", Color("2a2a2a", 0.0),.75)
	$Content/Timer.start(1)
	state = PLAYING if !the_end else CREDITS
func fade_in_game_over() -> void :
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Content/Control/ColorRect, "color", Color("424242", 1.0),.75)
	$Content/Timer.start(1)
	state = CURRENT_SCENE
func tuto_animation() -> void :
	player.can_walk = true
	var tutoSprite = player.get_node("TutoAnimatedSprite2D")
	if tutoSprite.visible :
		match(current_scene_id) :
			1 :
				tutoSprite.play("Love_Cookie")
			3 :
				tutoSprite.play("Where_Cookie")
			4 :
				tutoSprite.play("Child_Monster")
			5 :
				tutoSprite.play("Gift")
