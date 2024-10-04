extends CanvasLayer

@onready var l_text: Label = $left/text
@onready var r_text: Label = $right/text
@onready var time_label: Label = $center_top/TimeLabel
@onready var progress_bar: ProgressBar = $center_top/ProgressBar

var play_scene = load("res://scenes/menu.tscn")

var l_points := 0
var r_points := 0

func _ready() -> void:
	Global.increment_point_p1.connect(increment_point_p1)
	Global.increment_point_p2.connect(increment_point_p2)

	Global.time_passed.connect(time_passed)


func increment_point_p1():
	l_points += 1
	l_text.text = str(l_points)

func increment_point_p2():
	r_points += 1
	r_text.text = str(r_points)

func time_passed(time: int):
	time_label.text = str(60 - time)
	progress_bar.value = 60 - time
	if time == 60:
		Global.last_score = [l_points, r_points]
		Global.id_next_player = 0
		get_tree().root.add_child(play_scene.instantiate())
		get_parent().queue_free()
