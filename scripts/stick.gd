extends Node2D

const SPEED = 60

var direction = 1
var is_dead = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var timer = $Timer
@onready var killzone = $Killzone

func _ready():
	animated_sprite.play("idle")

func _process(delta):
	# Detect lateral collisions
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	
	if not is_dead:
		position.x += direction * SPEED * delta

func die():
	if not is_dead:
		killzone.queue_free()
		animated_sprite.play("die")
		timer.start()
	is_dead = true

func _on_timer_timeout():
	queue_free()
