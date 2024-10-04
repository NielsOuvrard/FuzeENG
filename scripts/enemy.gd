extends CharacterBody2D

@onready var animation_player = $AnimationPlayer

var id = -1


func destroy():
	animation_player.play("destroy")
