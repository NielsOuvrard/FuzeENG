extends CharacterBody2D

@export var SPEED = 100
@onready var cool_down = $CoolDown

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	cool_down.start()
	

func _physics_process(_delta):
	velocity = Vector2(0, -SPEED).rotated(dir)
	move_and_slide()


func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	body.queue_free()
	queue_free()
