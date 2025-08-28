extends CharacterBody2D
class_name Player
const TILE_SIZE : Vector2 = Vector2(16,16)
var sprite_tween : Tween
var gift_scene = load("res://Scenes/gift.tscn")
var can_drop_gift : bool = true
var has_cookie : bool = false
var can_walk : bool = true
var step_sound_1 : bool = true

func _ready():
	$AnimatedSprite2D.play("Walk")
func _physics_process(delta:float) -> void:
	if can_walk and (!sprite_tween or !sprite_tween.is_running()) :
		if Input.is_action_pressed("ui_up") and !$RayUp.is_colliding() :
			_move(Vector2(0,-1))
		elif Input.is_action_pressed("ui_down") and !$RayDown.is_colliding() :
			_move(Vector2(0,1))
		elif Input.is_action_pressed("ui_left") :
			if !$RayLeft.is_colliding() :
				_move(Vector2(-1,0))
			$AnimatedSprite2D.flip_h = true
		elif Input.is_action_pressed("ui_right") :
			if !$RayRight.is_colliding() :
				_move(Vector2(1,0))
			$AnimatedSprite2D.flip_h = false
		if Input.is_action_just_pressed("ui_accept") and can_drop_gift :
			drop_gift()
func _move(dir: Vector2) -> void:
	global_position += dir * TILE_SIZE
	$AnimatedSprite2D.global_position -= dir * TILE_SIZE
	if sprite_tween : sprite_tween.kill()
	sprite_tween = create_tween()
	sprite_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_tween.tween_property($AnimatedSprite2D, "global_position", $AnimatedSprite2D.global_position + dir * TILE_SIZE, 0.3).set_trans(Tween.TRANS_SINE)
	if step_sound_1 :
		get_node("/root/SceneManager/Content/AudioManager").play_santa_step_1()
	else :
		get_node("/root/SceneManager/Content/AudioManager").play_santa_step_2()
	step_sound_1 = !step_sound_1
func drop_gift() -> void:
	can_walk = false
	get_node("/root/SceneManager/Content/AudioManager").play_gift()
	$AnimatedSprite2D.play("Drop_Gift")
	var gift = gift_scene.instantiate()
	gift.global_position = global_position
	get_parent().get_node("GiftsNode").add_child(gift)
func cookie_setter(state: bool) -> void: has_cookie = state
func cookie_getter() -> bool: return has_cookie
func _on_gift_collider_area_entered(area) -> void: can_drop_gift = false
func _on_gift_collider_area_exited(area) -> void: can_drop_gift = true
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "Drop_Gift" :
		can_walk = true
		$AnimatedSprite2D.play("Walk")
func tp(pos: Vector2) -> void :
	if sprite_tween : sprite_tween.kill()
	global_position = pos
	$AnimatedSprite2D.global_position = pos + (Vector2.UP * 8)
