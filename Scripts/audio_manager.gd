extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func play_crunch() -> void : $Crunch.play()
func play_naughty() -> void : $Naughty.play()
func play_santa_step_1() -> void : $SantaStep1.play()
func play_santa_step_2() -> void : $SantaStep2.play()
func play_gift() -> void : $Gift.play()
func play_child_step_1() -> void : $ChildStep1.play()
func play_child_step_2() -> void : $ChildStep2.play()
func play_fireplace() -> void : $Fireplace.play()
func play_fire_out() -> void :
	$FireOut.play()
	$Fireplace.stop()
