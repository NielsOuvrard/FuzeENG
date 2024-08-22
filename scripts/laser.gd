extends CharacterBody2D

#@onready var cool_down = $CoolDown
@onready var laser_sprite = $LaserSprite
@onready var cool_down = $CoolDown
@onready var rocket = $".."
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var laser_sound = $LaserSound

func shot():
	laser_sprite.visible = true
	cool_down.start()
	laser_sound.play()
	collision_shape_2d.disabled = false


func _on_cool_down_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.id != rocket.id:
		body.destroy()
