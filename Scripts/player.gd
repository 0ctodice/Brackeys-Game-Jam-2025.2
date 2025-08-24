extends CharacterBody2D

const TILE_SIZE : Vector2 = Vector2(16,16)
var sprite_tween : Tween
var gift_scene = load("res://Scenes/gift.tscn")
var can_drop_gift : bool = true
var has_cookie : bool = false

func _physics_process(delta:float) -> void:
	if !sprite_tween or !sprite_tween.is_running() :
		if Input.is_action_pressed("ui_up") and !$RayUp.is_colliding() :
			_move(Vector2(0,-1))
		elif Input.is_action_pressed("ui_down") and !$RayDown.is_colliding() :
			_move(Vector2(0,1))
		elif Input.is_action_pressed("ui_left") and !$RayLeft.is_colliding() :
			_move(Vector2(-1,0))
		elif Input.is_action_pressed("ui_right") and !$RayRight.is_colliding() :
			_move(Vector2(1,0))
		
		if Input.is_action_just_pressed("ui_accept") and can_drop_gift :
			drop_gift()
	
func _move(dir: Vector2) -> void:
	global_position += dir * TILE_SIZE
	$Sprite2D.global_position -= dir * TILE_SIZE
	if sprite_tween : sprite_tween.kill()
	sprite_tween = create_tween()
	sprite_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_tween.tween_property($Sprite2D, "global_position", global_position, 0.185).set_trans(Tween.TRANS_SINE)

func drop_gift() -> void:
	var gift = gift_scene.instantiate()
	gift.global_position = global_position
	get_parent().add_child(gift)

func cookie_setter(state: bool) -> void: has_cookie = state
func cookie_getter() -> bool: return has_cookie
func _on_gift_collider_body_entered(body) -> void: can_drop_gift = false
func _on_gift_collider_body_exited(body) -> void: can_drop_gift = true
