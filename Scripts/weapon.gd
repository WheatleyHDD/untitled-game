extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bullet = preload("res://Prefabs/bullet.tscn")
var rifleshoot = preload("res://Prefabs/rifleshoot.tscn")

enum {NO_WEAPON, AK_WEAPON, BOMP, SHOOTGUN_WEAPON, M14_WEAPON, DEBUG_WEAPON, M4_WEAPON}
export var curr_weapon_id = 0
export var of_player = false
var stop_aim = false

var ShootTime = {
	NO_WEAPON: 0,
	AK_WEAPON: 0.1,
	BOMP: 0,
	SHOOTGUN_WEAPON: 1,
	M14_WEAPON: 2,
	DEBUG_WEAPON: 0.1,
	M4_WEAPON: 0.12,
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	print(get_parent().name + ": " + str(-150 * position.distance_to(to_local(get_tree().get_current_scene().get_node_or_null("Player").position)) / 1865))
#	$Change.volume_db = -100
#	set_weapon(NO_WEAPON)
#	$Change.volume_db = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !of_player and get_tree().get_current_scene().get_node_or_null("Player"):
		$Change.volume_db = -150 * position.distance_to(to_local(get_tree().get_current_scene().get_node_or_null("Player").position)) / 1865
		$akshooting.volume_db = -50 * position.distance_to(to_local(get_tree().get_current_scene().get_node_or_null("Player").position)) / 1865
		$shootgun.volume_db = -50 * position.distance_to(to_local(get_tree().get_current_scene().get_node_or_null("Player").position)) / 1865
	if of_player:
		$Change.volume_db = 10
	if of_player and !stop_aim:
		if OS.get_name() != "Android":
			look_at(get_global_mouse_position())
#		print(to_global(position).x)
		if OS.get_name() != "Android":
			if to_global(position).x < get_global_mouse_position().x:
				scale.y = 1
			else:
				scale.y = -1
		
		if Input.is_mouse_button_pressed(BUTTON_LEFT) and curr_weapon_id != NO_WEAPON and curr_weapon_id != BOMP:
			if OS.get_name() != "Android":
				if !$RayCast2D.is_colliding():
					shoot("")
		else:
			if OS.get_name() != "Android":
				$akshooting.stop()
	else:
		if of_player:
			$akshooting.stop()

func shoot(whos: String):
	if $Timer.is_stopped():
		match curr_weapon_id:
			AK_WEAPON:
				var bulletinst = bullet.instance()
				bulletinst.position = to_global($Position2D.position)
				bulletinst.ofPlayer = of_player
				randomize()
				bulletinst.rotation_degrees = rotation_degrees + rand_range(-5, 5)
				bulletinst.weapon_type = curr_weapon_id
				bulletinst.whos_bullet = whos
				get_node("../../").add_child(bulletinst)
				if !$akshooting.playing:
						$akshooting.play()
				$Timer.start(getShootTime(curr_weapon_id))
			SHOOTGUN_WEAPON:
				var bulletinst1 = bullet.instance()
				bulletinst1.position = to_global($Position2D.position)
				bulletinst1.ofPlayer = of_player
				bulletinst1.rotation_degrees = rotation_degrees
				bulletinst1.weapon_type = curr_weapon_id
				bulletinst1.whos_bullet = whos
				
				var bulletinst2 = bullet.instance()
				bulletinst2.position = to_global($Position2D.position)
				bulletinst2.ofPlayer = of_player
				bulletinst2.rotation_degrees = rotation_degrees - 5
				bulletinst2.weapon_type = curr_weapon_id
				bulletinst2.whos_bullet = whos
				
				var bulletinst3 = bullet.instance()
				bulletinst3.position = to_global($Position2D.position)
				bulletinst3.ofPlayer = of_player
				bulletinst3.rotation_degrees = rotation_degrees + 5
				bulletinst3.weapon_type = curr_weapon_id
				bulletinst3.whos_bullet = whos
				
				get_node("../../").add_child(bulletinst1)
				get_node("../../").add_child(bulletinst2)
				get_node("../../").add_child(bulletinst3)
				$shootgun.play()
				$Timer.start(getShootTime(curr_weapon_id))
			M14_WEAPON:
				var bulletinst = bullet.instance()
				bulletinst.position = to_global($Position2D.position)
				bulletinst.ofPlayer = of_player
				bulletinst.rotation_degrees = rotation_degrees
				bulletinst.weapon_type = curr_weapon_id
				bulletinst.whos_bullet = whos
				
				get_node("../../").add_child(bulletinst)
				$snipershoot.play()
				$Timer.start(getShootTime(curr_weapon_id))
			DEBUG_WEAPON:
				var bulletinst = bullet.instance()
				bulletinst.position = to_global($Position2D.position)
				bulletinst.ofPlayer = of_player
				randomize()
				bulletinst.rotation_degrees = rotation_degrees + rand_range(-5, 5)
				bulletinst.weapon_type = curr_weapon_id
				bulletinst.whos_bullet = whos
				get_node("../../").add_child(bulletinst)
				if !$akshooting.playing:
						$akshooting.play()
				$Timer.start(getShootTime(curr_weapon_id))
			M4_WEAPON:
				var bulletinst = bullet.instance()
				bulletinst.position = to_global($Position2D.position)
				bulletinst.ofPlayer = of_player
				randomize()
				bulletinst.rotation_degrees = rotation_degrees + rand_range(-3.8, 3.8)
				bulletinst.weapon_type = curr_weapon_id
				bulletinst.whos_bullet = whos
				get_node("../../").add_child(bulletinst)
				var rsi = rifleshoot.instance()
				add_child(rsi)
				rsi.play()
				$Timer.start(getShootTime(curr_weapon_id))

func getShootTime(id) -> float:
	return float(ShootTime[id])

func set_weapon(id):
	match id:
		NO_WEAPON:
			$Sprite.visible = false
			curr_weapon_id = NO_WEAPON
		AK_WEAPON:
			$Change.play()
			$Sprite.visible = true
			$Sprite.texture = load("res://Sprites/weapon/AK-47.png")
			$Sprite.offset = Vector2(9, 3)
			$Position2D.position = Vector2(47.5, 0.5)
			curr_weapon_id = AK_WEAPON
		SHOOTGUN_WEAPON:
			$Change.play()
			$Sprite.visible = true
			$Sprite.texture = load("res://Sprites/weapon/shootgun.png")
			$Sprite.offset = Vector2(9, 5)
			$Position2D.position = Vector2(47.5, -2.5)
			curr_weapon_id = SHOOTGUN_WEAPON
		BOMP:
			$Sprite.visible = true
			$Sprite.texture = load("res://Sprites/weapon/bomb.png")
			$Sprite.offset = Vector2(0, 0)
			$Position2D.position = Vector2(54.5, -0.5)
			curr_weapon_id = BOMP
		M14_WEAPON:
			$Change.play()
			$Sprite.visible = true
			$Sprite.texture = load("res://Sprites/weapon/M14-Wood.png")
			$Sprite.offset = Vector2(9, 5)
			$Position2D.position = Vector2(47.5, -2.5)
			curr_weapon_id = M14_WEAPON
		DEBUG_WEAPON:
			$Change.play()
			$Sprite.visible = true
			$Sprite.texture = load("res://Sprites/weapon/AK-47.png")
			$Sprite.offset = Vector2(9, 3)
			$Position2D.position = Vector2(47.5, 0.5)
			curr_weapon_id = DEBUG_WEAPON
		M4_WEAPON:
			$Change.play()
			$Sprite.visible = true
			$Sprite.texture = load("res://Sprites/weapon/M4-Carbine-w-Scope.png")
			$Sprite.offset = Vector2(9, 2)
			$Position2D.position = Vector2(47.5, 0.5)
			curr_weapon_id = M4_WEAPON
