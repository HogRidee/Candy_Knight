extends Area2D

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var timer = $Timer

func _ready():
	extend_tentacle()
	
func extend_tentacle():
	sprite_2d.visible = true
	collision_shape_2d.disabled = false
	timer.start()

func _on_timer_timeout():
	retract_tentacle()
	
func retract_tentacle():
	sprite_2d.visible = false
	collision_shape_2d.disabled = true
	queue_free()
