extends CharacterBody2D

const Globals = preload("res://scripts/globals.gd")

#@onready var cool_down = $CoolDown

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	#cool_down.start()
	
	var obj = Weapon.new(Globals.KindWeapon.LASER)
	obj.display_info()
	


#func _on_timer_timeout():
	#queue_free()
