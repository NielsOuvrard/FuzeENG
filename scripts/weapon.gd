extends Node


class_name Weapon
#@onready var timer = $Timer
var timer: Timer


#@onready var life = $Life
#@onready var cool_down = $CoolDown

const Globals = preload("res://scripts/globals.gd")

# Propriétés de la classe Weapon
var kind: Globals.KindWeapon
#var is_animation_over := false
var shot := 0
var is_able_to_shot := true

# Constructeur
func _init(_kind : Globals.KindWeapon):
	kind = _kind
	print("init")
	print(timer)
	#print(cool_down)
	#print(life)

#func _ready():
	#print("_ready")
	#timer = $Timer
	#print(timer)
	##print(cool_down)
	##print(life)
	##cool_down.start()

func attack():
	if is_able_to_shot:
		shot += 1
		is_able_to_shot = false
		print("attack")
		#cool_down.start()

		# only purple has its life according to shots
		if kind == Globals.KindWeapon.PURPLE and shot >= 5:
			#is_animation_over = true
			#reset_weapon.call()
			queue_free()
		else:
			#life.start()
			pass


# Méthode pour afficher les informations de l'arme
func display_info():
	print("kind: " + str(kind))

## ##
## Méthode pour changer les caractéristiques de l'arme
## ##
#func upgrade(new_damage: int, new_range: float, new_weight: float):
	#damage = new_damage
	#print(weapon_name + " has been upgraded!")


#func _on_life_timeout():
	##is_animation_over = true
	#queue_free()
#
#
#func _on_cool_down_timeout():
	#is_able_to_shot = true
