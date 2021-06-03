extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int, "No", "AK-47", "Bomb", "Shootgun", "Sniper", "Debug Weapon", "M4") var weapon_type
signal weaponUsed

#onready var weapon_drop = preload("res://Prefabs/weaponDrop.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	set_weapon(weapon_type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for i in $Area2D.get_overlapping_bodies():
		if i.has_meta("name"):
			match i.get_meta("name"):
				"Player":
					if Input.is_action_just_pressed("use") and weapon_type != 0:
						position = i.position
						var last_weapon = weapon_type
						set_weapon(i.get_node("weapon").curr_weapon_id)
						i.get_node("weapon").set_weapon(last_weapon)
						
						i.key_info_close()
						apply_central_impulse(Vector2(cos(60 * i.get_node("weapon").scale.y) * 1200, sin(60 * i.get_node("weapon").scale.y) * 1200))
						
						emit_signal("weaponUsed")


func _on_Area2D_body_entered(body):
	if body.has_meta("name"):
		match body.get_meta("name"):
			"Player":
				if weapon_type != 0:
					body.key_info_open()
	
func set_weapon(id):
	match id:
		0:
			$Sprite.visible = false
			weapon_type = 0
		1:
			$Sprite.visible = true
			$Sprite.texture = load("res://Sprites/weapon/AK-47.png")
			weapon_type = 1
		2:
			$Sprite.visible = true
			$Sprite.texture = load("res://Sprites/weapon/bomb.png")
			weapon_type = 2
		3:
			$Sprite.visible = true
			$Sprite.texture = load("res://Sprites/weapon/shootgun.png")
			weapon_type = 3
		4:
			$Sprite.visible = true
			$Sprite.texture = load("res://Sprites/weapon/M14-Wood.png")
			weapon_type = 4
		5:
			$Sprite.visible = true
			$Sprite.texture = load("res://Sprites/weapon/AK-47.png")
			weapon_type = 5
		6:
			$Sprite.visible = true
			$Sprite.texture = load("res://Sprites/weapon/M4-Carbine-w-Scope.png")
			weapon_type = 6


func _on_Area2D_body_exited(body):
	if body.has_meta("name"):
		match body.get_meta("name"):
			"Player":
				if weapon_type != 0:
					body.key_info_close()
