extends Node2D

@onready var timer = $Timer
@onready var main = $"../.."
@onready var rocket = $".."
@onready var projectile = load("res://scenes/projectil.tscn")

var is_able_to_shot := true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

const size_grip = Vector2(10, 30) # value approximated

func shot():
	if is_able_to_shot:
		print("shot")
		timer.start()
		is_able_to_shot = false
		
		## instance stuff
		var instance = projectile.instantiate()
		instance.dir = rocket.global_rotation
		instance.spawnPos.x = global_position.x + (cos(global_rotation)) # should add size_grip
		instance.spawnPos.y = global_position.y + (sin(global_rotation))
		instance.spawnRot = rocket.global_rotation
		instance.sender = rocket.id

		main.add_child.call_deferred(instance)
		
		# reset animation
		#current_weapon.attack()




func _on_timer_timeout():
	is_able_to_shot = true
