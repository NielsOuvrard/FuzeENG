extends CharacterBody2D

@export var SPEED = 10000.0
@export var ROTATE_SPEED = 3.0
@export var ACCEL = 1.5

# maybe use later
# const Globals = preload("res://scripts/globals.gd")

# ? onreeady necessary
@onready var shooter_scene = load("res://scenes/shooter.tscn")
@onready var laser_scene = load("res://scenes/laser.tscn")
@onready var weapons_scenes = [shooter_scene, laser_scene]
# TODO here the others weapons

@onready var fire = $BackFire

var is_moving = false
var id = 0

var current_weapon_instance = null

func _ready():
	pass
	#equip_item(null)

func equip_item(local_item): # local_item use later
	# TODO remove the modulo when all weapons add
	var new_weapon_scene = weapons_scenes[local_item % len(weapons_scenes)]
	current_weapon_instance = new_weapon_scene.instantiate()
	current_weapon_instance.position.y -= 14
	add_child(current_weapon_instance)

func reset_weapon():
	print("reset_weapon")
	#grips[current_weapon.kind].visible = false
	#current_weapon = null


func _process(_delta):
	var is_shooting = Input.get_action_strength("shot")
	if is_shooting and current_weapon_instance:
		current_weapon_instance.shot()



func _physics_process(delta):
	var distance_move = (
		Input.get_action_strength("move_up") -
		Input.get_action_strength("move_down")
	)
	var rot = (
		Input.get_action_strength("move_right") -
		Input.get_action_strength("move_left")
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
