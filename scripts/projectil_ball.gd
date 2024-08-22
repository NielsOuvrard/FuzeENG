extends CharacterBody2D

@export var SPEED = 300
@onready var cool_down = $CoolDown

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var dir : float
var spawnPos : Vector2
var spawnRot : float
var sender

var speed = 1
var pure_velocity = 0

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	velocity = Vector2(0, -SPEED).rotated(dir)
	cool_down.start()
	

func _physics_process(delta):
	# Apply gravity to the y-velocity
	velocity.y += gravity * delta
	# Optional: apply a slight drag to the x-velocity (simulating air resistance)
	velocity.x -= velocity.x * 0.01 * delta
	# Move the projectile
	global_position += velocity * delta


func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.id != sender.id:
		sender.camera_2d.apply_shake()
		body.destroy()
		sender.points += 1
