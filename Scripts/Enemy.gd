extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var blood = preload("res://Prefabs/blood.tscn")
onready var expl = preload("res://Prefabs/Explosion.tscn")

onready var weapon_drop = preload("res://Prefabs/weaponDrop.tscn")

export(int, "No Weapon", "AK-47", "Bomp", "Shootgun", "Sniper") var weapon_start
export(float) var find_radius = 20
export(int, "Stand", "Patrol", "Walking") var behavior
export(int) var patrol_range = 5

export var phases: Array = [
	load("res://Sounds/enemy/hurt01.wav"),
	load("res://Sounds/enemy/hurt02.wav"),
	load("res://Sounds/enemy/hurt03.wav"),
	load("res://Sounds/enemy/hurt04.wav"),
	load("res://Sounds/enemy/hurt05.wav"),
	load("res://Sounds/enemy/shoot01.wav"),
	load("res://Sounds/enemy/shoot02.wav"),
	load("res://Sounds/enemy/shoot03.wav"),
	load("res://Sounds/enemy/shoot04.wav"),
	load("res://Sounds/enemy/sound01.wav"),
	load("res://Sounds/enemy/target01.wav"),
	load("res://Sounds/enemy/target02.wav"),
	load("res://Sounds/enemy/target03.wav"),
	load("res://Sounds/enemy/target04.wav"),
]
export var SPEED = 360
var JUMP_HEIGHT = 500
#var MIN_JUMP_HEIGHT = 300
var GRAVITY = 30
var ACCELERATION = 4500
var DECCELERATION = 4500

var input_f = 0
var see = false

export(float) var hp = 100

var velocity = Vector2()
var start_pos


# Called when the node enters the scene tree for the first time.
func _ready():
	$chr.setAnimationSpeed(SPEED)
	start_pos = position
	set_meta("name", "Enemy")
	$weapon.set_weapon(weapon_start)
	if weapon_start == 2:
		$walking_time.stop()
	if behavior == 1:
		input_f = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().get_current_scene().get_node_or_null("Player"):
		$sound.volume_db = -50 * position.distance_to(get_tree().get_current_scene().get_node_or_null("Player").position) / 5000
	if get_node_or_null("../Player") != null:
		$vision.cast_to = to_local(get_node_or_null("../Player").position)
		if $vision.is_colliding() and $vision.get_collider() != null: 
			if $vision.get_collider().name == "Player":
				if get_distance(position, get_node_or_null("../Player").position) < find_radius and get_node_or_null("../Player").visible:
					if weapon_start != 0 and weapon_start != 2:
						if !$sound.playing and !see:
							randomize()
							$sound.stream = phases[randi()%4 + 10]
							$sound.play()
						see = true
						input_f = 0
						$weapon.look_at(get_node("../Player").position)
						$weapon.shoot(name)
						$weapon.scale.x = 1
						if position.x < get_node("../Player").position.x:
							$chr.scale.x = 1
							$weapon.scale.y = 1
						elif position.x > get_node("../Player").position.x:
							$chr.scale.x = -1
							$weapon.scale.y = -1
					elif weapon_start == 2:
						if !$sound.playing:
							$sound.stream = phases[9]
							$sound.play()
						see = true
						input_f = 0
						if position.x < get_node("../Player").position.x:
							input_f = 1
						elif position.x > get_node("../Player").position.x:
							input_f = -1
				else:
					see = false
					$weapon/akshooting.stop()
	if behavior == 1 and !see:
		if abs(position.x - start_pos.x) > patrol_range:
			if position.x - start_pos.x > 0:
				input_f = -1
			elif position.x - start_pos.x < 0:
				input_f = 1
	
	if !see and input_f == 0:
		if behavior != 0:
			if $walking_time.is_stopped():
				$walking_time.start()
		if behavior == 1:
			if abs(position.x - start_pos.x) < patrol_range:
				input_f = -1
	
	if hp <= 0:
		if weapon_start == 2:
			var explosion = expl.instance()
			explosion.position = position
			get_node("../").add_child(explosion)
			explosion.play("default")
		else:
			var bloodinst = blood.instance()
			bloodinst.position = position
			get_node("../").add_child(bloodinst)
			bloodinst.restart()
			
			var weaponDrop = weapon_drop.instance()
			weaponDrop.position = position
			weaponDrop.weapon_type = weapon_start
			get_node("../").add_child(weaponDrop)
			weaponDrop.apply_central_impulse(Vector2(cos(60) * 400, sin(60) * 400))
		queue_free()

func _physics_process(delta):
	
	if is_on_wall() and is_on_floor():
		randomize()
		var jumping = 1
		if behavior == 2:
			jumping = randi() % 2
		if jumping == 1:
			jump()
		else:
			$walking_time.stop()
			randomize()
			input_f = rand_range(-1, 1)
			$walking_time.start()
	
	velocity.y += GRAVITY
	
	if !see:
		$weapon.scale.y = 1
		$weapon.rotation = 0
		if input_f < 0:
			$chr.scale.x = -1
			$weapon.scale.x = -1
		elif input_f > 0:
			$chr.scale.x = 1
			$weapon.scale.x = 1
	
	if input_f != 0:
		$chr.setState("walk")
		velocity = velocity.move_toward(Vector2(input_f*SPEED,velocity.y), ACCELERATION*delta)
	else:
		$chr.setState("idle")
		velocity = velocity.move_toward(Vector2(0, velocity.y), DECCELERATION*delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func jump():
	velocity.y = -JUMP_HEIGHT

func popal():
	if !$sound.playing:
		randomize()
		$sound.stream = phases[randi()%4+4]
		$sound.play()

func hurt():
	if visible:
		if !$sound.playing:
			randomize()
			$sound.stream = phases[randi()%5]
			$sound.play()
		$chr.modulate = Color.red
		$hurtTimer.start()

func get_distance(one: Vector2, two: Vector2) -> float:
	var h = abs(two.y - one.y)
	var w = abs(two.x - one.x)
	
	return abs(sqrt(h+w))


func _on_walking_time_timeout():
	if behavior > 1:
		randomize()
		input_f = rand_range(-1, 1)
		$walking_time.start()


func _on_Area2D_body_entered(body):
	if body.has_meta("name"):
		if body.get_meta("name") == "Player":
			if weapon_start == 2:
				hp = -1


func _on_hurtTimer_timeout():
	$chr.modulate = Color.white
