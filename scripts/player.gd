extends CharacterBody2D

@export var SPEED = 10000.0
@export var ROTATE_SPEED = 3.0
@export var ACCEL = 1.5


const Globals = preload("res://scripts/globals.gd")

# here put different types of weapons
@onready var projectile = load("res://scenes/projectil.tscn")
@onready var laser = load("res://scenes/laser.tscn")
@onready var ball = load("res://scenes/ball.tscn")
@onready var list_of_weapons = [projectile, laser, ball, projectile] # todo remplace proj by torch

@onready var anim_purple = $rocket/purple
@onready var anim_torch = $rocket/torch
@onready var anim_laser = $rocket/laser
@onready var anim_ball = $rocket/ball
@onready var animations = [anim_purple, anim_laser, anim_ball, anim_torch]

@onready var main = $".."
@onready var cool_down = $CoolDown
@onready var fire = $fire

var is_fire = false
const size_rocket = Vector2(10, 10) # value approximated

var current_weapon: Weapon = null



func equip_item(local_item):
	if current_weapon:
		animations[current_weapon.kind].visible = false
	animations[local_item].visible = true

	print("equip_item")
	current_weapon = Weapon.new(local_item) # cast int to KindWeapon


func reset_weapon():
	print("reset_weapon")
	animations[current_weapon.kind].visible = false
	current_weapon = null

func shoot():
	if current_weapon and current_weapon.is_able_to_shot:
		
		# instance stuff
		var instance = list_of_weapons[current_weapon.kind].instantiate()
		#instance.spawnPos = global_position
		instance.dir = rotation
		instance.spawnPos.x = global_position.x + (cos(global_rotation) * size_rocket.x) # noy good
		instance.spawnPos.y = global_position.y + (sin(global_rotation) * size_rocket.y)
		instance.spawnRot = rotation
		main.add_child.call_deferred(instance)
		
		# reset animation
		current_weapon.attack()





func _process(delta):
	var is_shooting = Input.get_action_strength("shot")
	if is_shooting:
		shoot()



func _physics_process(delta):
	var distance_move = (
		Input.get_action_strength("move_up") -
		Input.get_action_strength("move_down")
	)
	var rot = (
		Input.get_action_strength("move_right") -
		Input.get_action_strength("move_left")
	)
	if distance_move != 0 and not is_fire:
		fire.play("big_fire")
		is_fire = true
	elif distance_move == 0 and is_fire:
		fire.play("small_fire")
		is_fire = false
		
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

