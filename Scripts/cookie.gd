extends Area2D

func _ready():
	$AnimationPlayer.play("Floating")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.has_method("cookie_setter") :
		get_node("/root/SceneManager/Content/AudioManager").play_crunch()
		body.cookie_setter(true)
		queue_free()
