extends CharacterBody2D

var first_time = true

func _ready():
	visible = false
	disable_collisions()
			
func disable_collisions():
	for shape in get_children():
		if shape is CollisionShape2D:
			shape.set_deferred("disabled", true)

func enable_collisions():
	for shape in get_children():
		if shape is CollisionShape2D:
			shape.set_deferred("disabled", false)

func _on_area_2d_body_entered(body):
	if body.is_in_group('player'):
		if first_time:
			first_time = false
			enable_collisions()
			visible = true
			Global.stop_platform = true
			Global.start_boss = true
