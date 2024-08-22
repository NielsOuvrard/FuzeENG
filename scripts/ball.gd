extends Node2D

@onready var timer = $Timer
@onready var main = $"../.."
@onready var projectile = load("res://scenes/projectil_ball.tscn")
@onready var grip = $Grip
@onready var shot_sound = $ShotSound

const size_grip = Vector2(10, 30) # value approximated
var shot_done := false
var player

func shot():
	if not shot_done:
		shot_done = true
		shot_sound.play()
		## instance stuff
		var instance = projectile.instantiate()
		instance.dir = player.global_rotation
		instance.spawnPos.x = global_position.x + (cos(global_rotation)) # should add size_grip
		instance.spawnPos.y = global_position.y + (sin(global_rotation))
		instance.spawnRot = player.global_rotation
		instance.sender = player

		main.add_child.call_deferred(instance)
		timer.start()
		grip.visible = false
	


func _on_timer_timeout():
	queue_free()

