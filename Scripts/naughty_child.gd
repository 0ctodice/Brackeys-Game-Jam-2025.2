extends RigidBody2D

const TILE_SIZE : Vector2 = Vector2(16,16)
var sprite_tween : Tween
var can_move : bool = true
var rng = RandomNumberGenerator.new()
var possible_move = Array()
func _physics_process(delta:float) -> void:
	if (!sprite_tween or !sprite_tween.is_running()) and can_move :
		possible_move.clear()
		if !$RayUp.is_colliding() :
			possible_move.append(Vector2(0,-1))
		if !$RayDown.is_colliding() :
			possible_move.append(Vector2(0,1))
		if !$RayLeft.is_colliding() :
			possible_move.append(Vector2(-1,0))
		if !$RayRight.is_colliding() :
			possible_move.append(Vector2(1,0))
			
		_move(possible_move[rng.randi_range(0, possible_move.size() - 1)])
	
func _move(dir: Vector2) -> void:
	can_move = false
	$Timer.start(rng.randf_range(0.185, 3.0))
	global_position += dir * TILE_SIZE
	$Sprite2D.global_position -= dir * TILE_SIZE
	if sprite_tween : sprite_tween.kill()
	sprite_tween = create_tween()
	sprite_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_tween.tween_property($Sprite2D, "global_position", global_position, 0.185).set_trans(Tween.TRANS_SINE)
		
func _on_timer_timeout(): can_move = true
