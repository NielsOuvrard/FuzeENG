extends CharacterBody2D

@export var SPEED = 10000.0
@export var ROTATE_SPEED = 3.0
@export var ACCEL = 1.5

# ? onreeady necessary
@onready var shooter_scene = load("res://scenes/shooter.tscn")
@onready var laser_scene = load("res://scenes/laser.tscn")
@onready var ball_scene = load("res://scenes/ball.tscn")
@onready var flame_thrower_scene = load("res://scenes/flame_thrower.tscn")
@onready var weapons_scenes = [shooter_scene, laser_scene, ball_scene, flame_thrower_scene]
@onready var camera_2d = $"../Camera2D"

@onready var rocket = $Rocket
@onready var fire = $BackFire
@onready var main = $".."

var id : int
var input_move_up = "move_up"
var input_move_down = "move_down"
var input_move_right = "move_right"
var input_move_left = "move_left"
var input_shot = "shot"

var is_moving := false
var points := 0
var current_weapon_instance = null

func _ready():
	id = main.id_next_player
	rocket.frame = id
	#equip_item(0)
	pass

func equip_item(local_item): # local_item use later
	if is_instance_valid(current_weapon_instance):
		current_weapon_instance.queue_free()
	# TODO remove the modulo when all weapons add
	var new_weapon_scene = weapons_scenes[local_item % len(weapons_scenes)]
	current_weapon_instance = new_weapon_scene.instantiate()
	current_weapon_instance.position.y -= 14
	current_weapon_instance.player = self
	add_child(current_weapon_instance)



func _process(_delta):
	var is_shooting = Input.get_action_strength(input_shot)
	if is_shooting and is_instance_valid(current_weapon_instance):
		current_weapon_instance.shot()



func _physics_process(delta):
	var distance_move = (
		Input.get_action_strength(input_move_up) -
		Input.get_action_strength(input_move_down)
	)
	var rot = (
		Input.get_action_strength(input_move_right) -
		Input.get_action_strength(input_move_left)
	)
	if distance_move != 0 and not is_moving:
		fire.play("big_fire")
		is_moving = true
	elif distance_move == 0 and is_moving:
		fire.play("small_fire")
		is_moving = false

	# Rotate the player
	rotation += rot * ROTATE_SPEED * delta

	# Move the player

	var direction = Vector2(
		cos(rotation - (PI / 2)) * distance_move * SPEED * delta,
		sin(rotation - (PI / 2)) * distance_move * SPEED * delta
	)
	#position.x += cos(rotation) * velocidad * SPEED * delta
	#position.y += sin(rotation) * velocidad * SPEED * delta + (PI / 2)


	velocity.x = move_toward(velocity.x, direction.x, ACCEL)
	velocity.y = move_toward(velocity.y, direction.y, ACCEL)

	move_and_slide()
