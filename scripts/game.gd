extends Node2D

@onready var item = load("res://scenes/item.tscn")
@onready var enemy = load("res://scenes/enemy.tscn")
@onready var player_scene = load("res://scenes/player.tscn")

@onready var items_cooldown = $ItemsCooldown
@onready var enemies_cooldown = $EnemiesCooldown
@onready var progress_bar = $ProgressBar
@onready var player = $Player
@onready var time_label = $TimeLabel
@onready var points_label = $PointsLabel
@onready var points_label_2 = $PointsLabel2

@export var INIT_NBR_ITEMS := 3
@export var INIT_NBR_ENEMIES := 3

const TIME_MAX_BETWEEN_ENEMIES = 2
const TIME_MAX_BETWEEN_ITEMS = 2
const DISTANCE_MINIMUM_SPAWN = 10
const SIZE_WINDOW = Vector2(1920 / 5, 1080 / 5)
const SPAWN_ZONE = SIZE_WINDOW * 0.8

var time_elapsed := 0.0
var items_at_screen := []
var enemies_at_screen := []
var id_next_player := 0:
	get:
		id_next_player += 1
		return id_next_player - 1

var nmb_players := 1
var player_2 = null

# Called when the node enters the scene tree for the first time.
func _ready():
	for _i in range(INIT_NBR_ITEMS):
		add_item()
	for _i in range(INIT_NBR_ENEMIES):
		add_enemy()

	items_cooldown.start()
	enemies_cooldown.start()
	
func wait_for_next_item():
	items_cooldown.wait_time = randi() % TIME_MAX_BETWEEN_ITEMS
	items_cooldown.start()
	
func wait_for_next_enemy():
	enemies_cooldown.wait_time = randi() % TIME_MAX_BETWEEN_ENEMIES
	enemies_cooldown.start()

func is_an_element_here(pos):
	var too_close := false
	for local_item in items_at_screen:
		if is_instance_valid(local_item):
			if abs(sqrt((pos.x - local_item.position.x) ** 2 + (pos.y - local_item.position.y) ** 2)) < DISTANCE_MINIMUM_SPAWN:
				too_close = true
			
	for local_enemy in enemies_at_screen:
		if is_instance_valid(local_enemy):
			if abs(sqrt((pos.x - local_enemy.position.x) ** 2 + (pos.y - local_enemy.position.y) ** 2)) < DISTANCE_MINIMUM_SPAWN:
				too_close = true
	
	if abs(sqrt((pos.x - player.position.x) ** 2 + (pos.y - player.position.y) ** 2)) < DISTANCE_MINIMUM_SPAWN:
		too_close = true
	
	return too_close

func add_item():
	var new_item = item.instantiate()
	new_item.position.x = (randi() % int(SPAWN_ZONE.x)) - (SPAWN_ZONE.x / 2)
	new_item.position.y = (randi() % int(SPAWN_ZONE.y)) - (SPAWN_ZONE.y / 2)
	while is_an_element_here(new_item.position):
		new_item.position.x = (randi() % int(SPAWN_ZONE.x)) - (SPAWN_ZONE.x / 2)
		new_item.position.y = (randi() % int(SPAWN_ZONE.y)) - (SPAWN_ZONE.y / 2)
	items_at_screen.append(new_item)
	add_child(new_item)

func add_enemy():
	var new_enemy = enemy.instantiate()
	new_enemy.position.x = (randi() % int(SPAWN_ZONE.x)) - (SPAWN_ZONE.x / 2)
	new_enemy.position.y = (randi() % int(SPAWN_ZONE.y)) - (SPAWN_ZONE.y / 2)
	while is_an_element_here(new_enemy.position):
		new_enemy.position.x = (randi() % int(SPAWN_ZONE.x)) - (SPAWN_ZONE.x / 2)
		new_enemy.position.y = (randi() % int(SPAWN_ZONE.y)) - (SPAWN_ZONE.y / 2)
	enemies_at_screen.append(new_enemy)
	add_child(new_enemy)

func _on_items_cooldown_timeout():
	var i := 0
	while i < len(items_at_screen):
		if not is_instance_valid(items_at_screen[i]):
			items_at_screen.pop_at(i)
			i = -1
		i += 1
	if len(items_at_screen) < 5:
		add_item()
	wait_for_next_item()

func _on_enemies_cooldown_timeout():
	var i := 0
	while i < len(enemies_at_screen):
		if not is_instance_valid(enemies_at_screen[i]):
			enemies_at_screen.pop_at(i)
			i = -1
		i += 1
	if len(enemies_at_screen) < 5:
		add_enemy()
	wait_for_next_enemy()


func _process(delta):
	if time_elapsed < 60.0:
		time_elapsed += delta
		progress_bar.value = 60 - time_elapsed  # Update the progress bar value
		time_label.text = str(int(progress_bar.value))
		
		points_label.text = "Points: " + str(player.points)
		if is_instance_valid(player_2):
			points_label_2.text = "Points: " + str(player_2.points)
	else:
		print("Time's up!")
		
	if nmb_players == 1:
		if Input.get_action_strength("up_2") or Input.get_action_strength("down_2") or Input.get_action_strength("right_2") or Input.get_action_strength("left_2"):
			player_2 = player_scene.instantiate()
			player_2.input_move_up = "up_2"
			player_2.input_move_down = "down_2"
			player_2.input_move_right = "right_2"
			player_2.input_move_left = "left_2"
			player_2.input_shot = "shot_2"
d
			add_child(player_2)
			nmb_players += 1
