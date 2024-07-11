extends CharacterBody2D

var speed = 70
var initial_position
var target_position
var moving_to_target = false
var first_time = true
var timer_out = false

@onready var timer_disappear = $"Timer Disappear"
@onready var collision_shape = $CollisionShape2D
@onready var timer_appear = $"Timer Appear"

func _ready():
	initial_position = position
	target_position = initial_position + Vector2(10, 0)

func _process(delta):
	if not first_time and not timer_out:
		if moving_to_target:
			position.x += speed * delta
			if position.x >= target_position.x:
				position.x = target_position.x
				moving_to_target = false
		else:
			position.x -= speed * delta
			if position.x <= initial_position.x:
				position.x = initial_position.x
				moving_to_target = true

func _on_area_2d_body_entered(body):
	if body.is_in_group('player'):
		if first_time:
			moving_to_target = true
			first_time = false
			timer_disappear.start()

func _on_timer_disappear_timeout():
	timer_out = true
	visible = false
	disable_collisions()

func _on_timer_appear_timeout():
	timer_out = false
	visible = true
	enable_collisions()
	
func enable_collisions():
	for shape in get_children():
		if shape is CollisionShape2D:
			shape.set_deferred("disabled", false)
			
func disable_collisions():
	for shape in get_children():
		if shape is CollisionShape2D:
			shape.set_deferred("disabled", true)
			first_time = true
			timer_appear.start()
