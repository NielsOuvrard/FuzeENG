extends Control


var play_scene = preload("res://scenes/game.tscn").instantiate()

#func _add_a_scene_manually():
	## This is like autoloading the scene, only
	## it happens after already loading the main scene.
	#get_tree().root.add_child(play_scene)


func _on_button_pressed():
	get_tree().root.add_child(play_scene)
	queue_free()
	#pass # Replace with function body.
