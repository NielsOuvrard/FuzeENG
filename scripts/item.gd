extends Node2D

# random of a weapon
@export var weapon = -1

@onready var item_torch = $ItemTorch
@onready var item_purple = $ItemPurple
@onready var item_laser = $ItemLaser
@onready var item_ball = $ItemBall
@onready var weapons = [item_purple, item_laser, item_ball, item_torch]

@onready var animation_player = $AnimationPlayer


func _ready():
	if weapon < 0:
		weapon = randi() % len(weapons)
	weapons[weapon].visible = true
	


func _on_area_2d_body_entered(body):
	if body.id == 0:
		body.equip_item(weapon)
		animation_player.play("take_item")
