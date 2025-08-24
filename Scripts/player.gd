extends CharacterBody2D

const TILE_SIZE : Vector2 = Vector2(16,16)
var sprite_tween : Tween

func _physics_process(delta:float) -> void:
	if sprite_tween and sprite_tween.is_running() :
		return
	if Input.is_action_pressed("ui_up") and !$RayUp.is_colliding() :
		_move(Vector2(0,-1))
	elif Input.is_action_pressed("ui_down") and !$RayDown.is_colliding() :
		_move(Vector2(0,1))
	elif Input.is_action_pressed("ui_left") and !$RayLeft.is_colliding() :
		_move(Vector2(-1,0))
	elif Input.is_action_pressed("ui_right") and !$RayRight.is_colliding() :
		_move(Vector2(1,0))
	
func _move(dir: Vector2) -> void:
	global_position += dir * TILE_SIZE
	$Sprite2D.global_position -= dir * TILE_SIZE
	
	if sprite_tween :
		sprite_tween.kill()
		
	sprite_tween = create_tween()
	sprite_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_tween.tween_property($Sprite2D, "global_position", global_position, 0.185).set_trans(Tween.TRANS_SINE)
