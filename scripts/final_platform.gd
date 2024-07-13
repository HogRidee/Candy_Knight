extends AnimatableBody2D

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

var first_time = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.stop_platform and first_time:
		timer.start()
		first_time = false
		

func _on_timer_timeout():
	animation_player.pause()
