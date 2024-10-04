extends Node2D

@onready var item = load("res://scenes/item.tscn")
@onready var enemy = load("res://scenes/enemy.tscn")
@onready var player_scene = load("res://scenes/rocket.tscn")

@onready var items_cooldown = $ItemsCooldown
@onready var enemies_cooldown = $EnemiesCooldown
@onready var progress_bar = $ProgressBar
@onready var time_label = $TimeLabel

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

# not optimal
var players := []
var player_zqsd := false
var player_arroz := false

# Called when the node enters the scene tree for the first time.
func _ready():
	for _i in range(INIT_NBR_ITEMS):
		add_item()
	#for _i in range(INIT_NBR_ENEMIES):
		#add_enemy()

	items_cooldown.start()
	#enemies_cooldown.start()
	
func wait_for_next_item():
	items_cooldown.wait_time = randi() % TIME_MAX_BETWEEN_ITEMS
	items_cooldown.start()
	
func wait_for_next_enemy():
	enemies_cooldown.wait_time = randi() % TIME_MAX_BETWEEN_ENEMIES
	enemies_cooldown.start()

func absolute_distance(pos_1: Vector2, pos_2: Vector2):
	if abs(sqrt((pos_1.x - pos_2.x) ** 2 + (pos_1.y - pos_2.y) ** 2)) < DISTANCE_MINIMUM_SPAWN:
		return true
	return false

func is_an_element_here(pos: Vector2):
	var too_close := false
	for local_item in items_at_screen:
		if is_instance_valid(local_item):
			if absolute_distance(pos, local_item.position):
				too_close = true
			
	for local_enemy in enemies_at_screen:
		if is_instance_valid(local_enemy):
			if absolute_distance(pos, local_enemy.position):
				too_close = true
	
	for player in players:
		if absolute_distance(pos, player.position):
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
	if round(time_elapsed + delta) != round(time_elapsed):
		Global.time_passed.emit(time_elapsed + delta)
	time_elapsed += delta
	progress_bar.value = 60 - time_elapsed  # Update the progress bar value
	time_label.text = str(int(progress_bar.value))
	
	if not player_arroz:
		if Input.get_action_strength("move_up") or \
		   Input.get_action_strength("move_down") or \
		   Input.get_action_strength("move_right") or \
		   Input.get_action_strength("move_left"):
			var new_player = player_scene.instantiate()
			new_player.input_move_up = "move_up"
			new_player.input_move_down = "move_down"
			new_player.input_move_right = "move_right"
			new_player.input_move_left = "move_left"
			new_player.input_shot = "shot"

			add_child(new_player)
			players.append(new_player)
			player_arroz = true

	if not player_zqsd:
		if Input.get_action_strength("up_2") or \
		   Input.get_action_strength("down_2") or \
		   Input.get_action_strength("right_2") or \
		   Input.get_action_strength("left_2"):
			var new_player = player_scene.instantiate()
			new_player.input_move_up = "up_2"
			new_player.input_move_down = "down_2"
			new_player.input_move_right = "right_2"
			new_player.input_move_left = "left_2"
			new_player.input_shot = "shot_2"

			add_child(new_player)
			players.append(new_player)
			player_zqsd = true
			
	# TODO add here controler player
