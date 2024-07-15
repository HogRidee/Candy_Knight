extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -310.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_dead = false
var is_attacking = false

# Get the reference from the animated sprite node
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var camera = %Camera2D
@onready var attack_area = $AttackArea

func _ready():
	pass
	#attack_area.position.x = 25

func _physics_process(delta): 
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle attack
	if Input.is_action_just_pressed("attack") and not is_dead:
		attack()

	# Get the input direction: -1 0 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the sprite.
	if direction > 0:
		animated_sprite.flip_h = false
		attack_area.position.x = abs(attack_area.position.x)
	elif direction < 0:
		animated_sprite.flip_h = true
		attack_area.position.x = -abs(attack_area.position.x)
	
	# Play animations.
	if not is_dead and not is_attacking:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")
	
	# Handle the movement/deceleration.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Handle player death
func die():
	is_dead = true
	animated_sprite.play("damage")

func attack():
	var overlapping_objects = attack_area.get_overlapping_areas()
	for area in overlapping_objects:
		var parent = area.get_parent()
		if parent.is_in_group('hit'):
			parent.die()
	is_attacking = true
	animated_sprite.play("attack")

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attack":
		is_attacking = false
