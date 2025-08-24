extends RigidBody2D

func _ready():
	var rng = RandomNumberGenerator.new()
	$Sprite2D.modulate = Color(rng.randf_range(0,1),rng.randf_range(0,1),rng.randf_range(0,1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
