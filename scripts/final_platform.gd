extends AnimatableBody2D

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@onready var camera = %Camera2D

var first_time = true

func _ready():
	if first_time:
		animation_player.play("vertical")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.stop_platform and first_time:
		timer.start()
		first_time = false
		adjust_camera()
		
func _on_timer_timeout():
	animation_player.pause()

func adjust_camera():
	var camera_offset = Vector2(0,-51)
	camera.position += camera_offset
	camera.limit_left -= 100
	camera.limit_right += 100
