extends Node2D

@onready var timer = $Timer
@onready var main = $"../.."
@onready var rocket = $".."
@onready var projectile = load("res://scenes/projectil.tscn")

@onready var shot_sound = $ShotSound


var is_able_to_shot := true

const size_grip = Vector2(10, 30) # value approximated
var shooted = 0

func shot():
	if is_able_to_shot:
		timer.start()
		is_able_to_shot = false
		shooted += 1
		shot_sound.play()
		
		## instance stuff
		var instance = projectile.instantiate()
		instance.dir = rocket.global_rotation
		instance.spawnPos.x = global_position.x + (cos(global_rotation)) # should add size_grip
		instance.spawnPos.y = global_position.y + (sin(global_rotation))
		instance.spawnRot = rocket.global_rotation
		instance.sender = rocket.id

		main.add_child.call_deferred(instance)
		

func _on_timer_timeout():
	is_able_to_shot = true
	if shooted >= 5:
		queue_free()
