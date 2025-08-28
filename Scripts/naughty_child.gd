extends RigidBody2D

enum {SEARCHING, CHASING, ROAMING, OPENING_GIFT, FINISHED_OPENING_GIFT}

const TILE_SIZE : Vector2 = Vector2(16,16)
var sprite_tween : Tween
var state = ROAMING
var can_move : bool = true
var rng = RandomNumberGenerator.new()
var possible_move = Array()
var santa_last_position = null
var santa_detected = false
var is_it_gift = false
var kid_type : String
var last_direction : Vector2 = Vector2.ZERO

func _ready():
	kid_type = "A" if rng.randi_range(0,1) == 0 else "B"
	_load_anim("Walk")
	$Sprite/AnimatedOutfit.modulate = Color(rng.randf_range(0,1),rng.randf_range(0,1),rng.randf_range(0,1))
func _physics_process(delta:float) -> void:
	if (!sprite_tween or !sprite_tween.is_running()) and can_move :
		match (state) :
			SEARCHING :
				_load_anim("Walk")
				$Timer.start(rng.randf_range(0.185, 3.0))
				_get_allowed_directions()
				var target = last_direction if last_direction in possible_move else possible_move[rng.randi_range(0, possible_move.size() - 1)]
				last_direction = target
				_look_towards_position(target)
				_move(target)
			CHASING :
				$Sprite/CircularLight.color = Color.RED
				$Sprite/TorchAnchor/TorchLight.color = Color.RED
				_load_anim("Chase")
				$Timer.start(.5)
				var target = _get_santa_direction()
				_look_towards_position(target)
				_move(target)
			ROAMING :
				$Sprite/CircularLight.color = Color.WHITE
				$Sprite/TorchAnchor/TorchLight.color = Color.WHITE
				_load_anim("Walk")
				$Timer.start(.25)
				state = SEARCHING
				if possible_move.size() != 0 :
					_move(Vector2.ZERO)
					_look_towards_position(possible_move.pop_at(rng.randi_range(0, possible_move.size() - 1)))
				else :
					state = SEARCHING
			OPENING_GIFT :
				$Sprite/TorchAnchor/TorchLight.color = Color("ffffff",0.0)
				_load_anim("Opening_Gift")
				$Timer.start(3)
				_look_towards_position(Vector2.ZERO)
				_move(Vector2.ZERO)
				state = FINISHED_OPENING_GIFT
			FINISHED_OPENING_GIFT :
				state = ROAMING
	if !santa_detected and $SantaCollider.is_colliding() and state != OPENING_GIFT:
		santa_detected = true
		santa_last_position = $SantaCollider.get_collider().global_position
		state = CHASING
		is_it_gift = $SantaCollider.get_collider().name.begins_with("Gift") and $SantaCollider.get_collider().name != "GiftCollider"
func _load_anim(anim:String) -> void :
	$Sprite/AnimatedBody.play(anim + "_" + kid_type if anim != "Opening_Gift" else "Opening_Gift")
	$Sprite/AnimatedOutfit.play(anim + "_" + kid_type if anim != "Opening_Gift" else "Opening_Gift")
func _look_towards_position(dir: Vector2) -> void :
	$SantaCollider.target_position = dir * 80
	$Sprite/AnimatedOutfit.flip_h = $Sprite/AnimatedOutfit.flip_h if dir.x == 0 else dir.x < 0
	$Sprite/AnimatedBody.flip_h = $Sprite/AnimatedBody.flip_h if dir.x == 0 else dir.x < 0
	$Sprite/TorchAnchor.rotation = (PI/2) + dir.angle()
func _get_santa_direction() -> Vector2 :
	santa_detected = false
	var dir = Vector2.ZERO
	if global_position.distance_to(santa_last_position) != 0 :
		var brut_direction = global_position.direction_to(santa_last_position)
		if brut_direction.y < 0 :
			dir = Vector2(0,-1)
		elif brut_direction.y > 0 :
			dir = Vector2(0,1)
		elif brut_direction.x < 0 :
			dir = Vector2(-1,0)
		elif brut_direction.x > 0 :
			dir = Vector2(1,0)
	else :
		state = OPENING_GIFT if is_it_gift else ROAMING
		possible_move.clear()
		possible_move.append_array([Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT])
	
	return dir
func _get_allowed_directions() -> void :
	possible_move.clear()
	if !$RayUp.is_colliding() :
		possible_move.append(Vector2.UP)
	if !$RayDown.is_colliding() :
		possible_move.append(Vector2.DOWN)
	if !$RayLeft.is_colliding() :
		possible_move.append(Vector2.LEFT)
	if !$RayRight.is_colliding() :
		possible_move.append(Vector2.RIGHT)
	print(possible_move)
func _move(dir: Vector2) -> void:
	can_move = false
	global_position += dir * TILE_SIZE
	$Sprite.global_position -= dir * TILE_SIZE
	if sprite_tween : sprite_tween.kill()
	sprite_tween = create_tween()
	sprite_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_tween.tween_property($Sprite, "global_position", global_position, 0.185).set_trans(Tween.TRANS_SINE)
func _on_timer_timeout(): can_move = true
func is_opening_gift() -> bool : return state == OPENING_GIFT or state == FINISHED_OPENING_GIFT
