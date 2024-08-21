extends Node2D

@onready var timer = $Timer
@onready var main = $"../.."
@onready var rocket = $".."
@onready var projectile = load("res://scenes/projectil.tscn")
@onready var grip = $Grip

const size_grip = Vector2(10, 30) # value approximated
var shot_done := false


func shot():
	if not shot_done:
		shot_done = true
		## instance stuff
		var instance = projectile.instantiate()
		instance.dir = rocket.global_rotation
		instance.spawnPos.x = global_position.x + (cos(global_rotation)) # should add size_grip
		instance.spawnPos.y = global_position.y + (sin(global_rotation))
		instance.spawnRot = rocket.global_rotation
		instance.sender = rocket.id

		main.add_child.call_deferred(instance)
		timer.start()
		grip.visible = false
	




func _on_timer_timeout():
	queue_free()




#@export var SPEED = 100
#@export var STRENGHT = 100
#
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#var dir : float
#var spawnPos : Vector2
#var spawnRot : float
#var strenght : int
#
#func _ready():
	#global_position = spawnPos
	#global_rotation = spawnRot
	#strenght = STRENGHT
	#
#
#func _physics_process(delta):
	#if strenght < 0:
		#strenght = 0
	#else:
		#strenght -= delta
	#
	##velocity.x = move_toward(velocity.x, cos(dir + (PI / 2)) * -SPEED, ACCEL)
	##velocity.y = move_toward(velocity.y, sin(dir + (PI / 2)) * -SPEED, ACCEL)
	#velocity.x += cos(dir + (PI / 2)) * -strenght
	#velocity.y += sin(dir + (PI / 2)) * (-strenght) + (gravity * 0.1)
	#
	##velocity = Vector2(0, -SPEED).rotated(dir)
	##velocity.y += gravity
	#move_and_slide()
