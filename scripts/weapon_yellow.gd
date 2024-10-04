extends CharacterBody2D

#@onready var cool_down = $CoolDown
@onready var flame = $Flame
@onready var cool_down = $CoolDown
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var flam_sound = $FlamSound

var player

func shot():
	flame.visible = true
	cool_down.start()
	flam_sound.play()
	collision_shape_2d.disabled = false


func _on_cool_down_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.id != player.id:
		body.destroy()
		player.increment_point()
		player.camera_2d.apply_shake()
