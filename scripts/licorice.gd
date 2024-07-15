extends Node2D

const MOVE_SPEED = 50
const ATTACK_INTERVAL = 5.0

var player
var is_dead = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var killzone = $Killzone
@onready var timer = $Timer
@onready var attack_timer = $AttackTimer
@onready var won = %Won
@onready var win_timer = $WinTimer

@onready var tentacle_scene = "res://scenes/tentacles.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("idle")
	player = get_parent().get_parent().get_node("Player")
	attack_timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player and Global.start_boss:
		move_towards_player(delta)
		
func move_towards_player(delta):
	var player_position = player.global_position
	var boss_position = global_position
	if boss_position.x < player_position.x:
		boss_position.x += MOVE_SPEED * delta
	elif boss_position.x > player_position.x:
		boss_position.x -= MOVE_SPEED * delta
	global_position = boss_position
	
func die():
	Global.boss_health -= 1
	if Global.boss_health == 0 and not is_dead:
		is_dead = true
		killzone.queue_free()
		timer.start()
		animated_sprite_2d.play("idle_red")
		won.visible = true

func _on_timer_timeout():
	queue_free()

func _on_attack_timer_timeout():
	if not is_dead and Global.start_boss:
		#perform_attack()
		attack_timer.start()
		
func perform_attack():
	var tentacle = tentacle_scene.instance()
	tentacle.position = Vector2(global_position.x, global_position.y)
	add_child(tentacle)
