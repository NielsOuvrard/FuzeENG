extends Node2D
@onready var last_score: Label = $last_score


var play_scene = preload("res://scenes/game.tscn").instantiate()

func _ready():
	if len(Global.last_score) > 0:
		last_score.visible = true
		last_score.text = "Last Score: " + str(Global.last_score[0]) + " - " + str(Global.last_score[1])

func _on_button_pressed():
	Global.id_next_player = 0
	get_tree().root.add_child(play_scene)
	queue_free()
