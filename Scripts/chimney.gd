extends Area2D

var time_passed :float = 0.0
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("Close")
	
func _process(delta):
	#if get_node("../Player").has_cookie :
		#$AnimatedSprite2D.visible = false
	if $AnimatedSprite2D.frame_progress > 0.9 :
		$AnimatedSprite2D/PointLight2D.energy = 0.5 + 0.15 * ($AnimatedSprite2D.frame + 1)
