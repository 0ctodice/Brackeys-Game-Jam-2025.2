extends Area2D

func _ready():
	var rng = RandomNumberGenerator.new()
	$ColorSprite.modulate = Color(rng.randf_range(0,1),rng.randf_range(0,1),rng.randf_range(0,1))

func _on_body_entered(body):
	body.set_state_to_opening_gift()
	body.is_it_gift = true
	queue_free()
