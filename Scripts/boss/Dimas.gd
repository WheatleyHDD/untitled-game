extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tnt_pref = preload("res://Prefabs/tnt.tscn")
onready var blood = preload("res://Prefabs/blood.tscn")
onready var expl = preload("res://Prefabs/Explosion.tscn")
onready var doshik_pref = preload("res://Prefabs/doshik.tscn")

onready var voices = [
	load("res://Sounds/boss/Dimas/voice02.wav"),
	load("res://Sounds/boss/Dimas/voice03.wav"),
	load("res://Sounds/boss/Dimas/voice05.wav"),
	load("res://Sounds/boss/Dimas/voice06.wav"),
	load("res://Sounds/boss/Dimas/voice07.wav"),
	load("res://Sounds/boss/Dimas/voice08.wav"),
	load("res://Sounds/boss/Dimas/voice09.wav"),
	load("res://Sounds/boss/Dimas/voice10.wav"),
	load("res://Sounds/boss/Dimas/voice11.wav"),
	load("res://Sounds/boss/Dimas/voice12.wav"),
	load("res://Sounds/boss/Dimas/voice13.wav"),
	load("res://Sounds/boss/Dimas/voice14.wav"),
]

export(int, "No Weapon", "AK-47", "Bomp", "Shootgun", "Sniper", "Debug", "M4") var weapon_start

export var SPEED = 490
var JUMP_HEIGHT = 650
#var MIN_JUMP_HEIGHT = 300
var GRAVITY = 30
var ACCELERATION = 4500
var DECCELERATION = 4500

var input_f = 0

export(float) var hp = 2500

var velocity = Vector2()

# 0 - Стояние
# 1 - Хождение
# 2 - Стрельба
var state = 0 

# четн - вправо
# нечетн - влево
var kuda = 1

var shoot1 = false
var shoot2 = false
var shoot3 = false

signal dies

# Called when the node enters the scene tree for the first time.
func _ready():
	$weapon.rotation_degrees = 180
	$weapon.scale.y = -1
	$chr.setAnimationSpeed(SPEED)
	set_meta("name", "Enemy")
	$weapon.set_weapon(weapon_start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if shoot1:
		if get_node_or_null("../../Player"):
			$weapon.look_at($"../../Player".position)
			$weapon.scale.x = 1
			if position < $"../../Player".position:
				$weapon.scale.y = 1
				$chr.scale.x = 1
			else:
				$weapon.scale.y = -1
				$chr.scale.x = -1
			$weapon.shoot(name)
	
	if shoot3:
		$weapon.shoot(name)
	
	if shoot2:
		shoot2 = false
		shoot3 = true
		for i in range(7):
			yield(get_tree().create_timer(0.1), "timeout")
			$weapon.rotation_degrees = 0 
			$weapon.scale.y = 1
			yield(get_tree().create_timer(0.1), "timeout")
			$weapon.rotation_degrees = 180 
			$weapon.scale.y = -1
		shoot3 = false
		yield(get_tree().create_timer(0.4), "timeout")
		kuda += 1
		state = 1
		
	
	if state == 1:
		if kuda % 6 != 0:
			if kuda % 2 == 0:
				if position.x < $"../right".position.x:
					if is_on_floor():
						$"../../Camera2D".shake(6, 0.2)
						jump()
					input_f = 1
				else:
					input_f = 0
					kuda += 1
					state = 2
			elif kuda % 2 != 0:
				if position.x > $"../left".position.x:
					if is_on_floor():
						$"../../Camera2D".shake(6, 0.2)
						jump()
					input_f = -1
				else:
					input_f = 0
					kuda += 1
					state = 2
		else:
			if abs(position.x - $"../middle".position.x) > 32:
				if position.x > $"../middle".position.x:
					input_f = -1
				elif  position.x < $"../middle".position.x:
					input_f = 1
			else:
				input_f = 0
				jump()
				shoot2 = true
				state = 0
	elif state == 2:
		if $shoot_time.is_stopped():
			$shoot_time.start()
		shoot1 = true
	
	
	if hp <= 0:
		emit_signal("dies")
		var bloodinst = blood.instance()
		bloodinst.position = position
		get_node("../").add_child(bloodinst)
		bloodinst.restart()
		queue_free()

func hurt():
	if visible:
		$chr.modulate = Color.red
		$hurtTimer.start()

func spawn_doshik(pos: Vector2, toglobal: bool = false):
	var doshik = doshik_pref.instance()
	doshik.rotation_degrees = 0
	if toglobal:
		doshik.position = to_global(pos)
	else:
		doshik.position = pos
	get_tree().get_current_scene().add_child(doshik)

func _physics_process(delta):
	
	velocity.y += GRAVITY
	
	if input_f != 0:
		$chr.setState("walk")
		velocity = velocity.move_toward(Vector2(input_f*SPEED,velocity.y), ACCELERATION*delta)
	else:
		$chr.setState("idle")
		velocity = velocity.move_toward(Vector2(0, velocity.y), DECCELERATION*delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func jump():
	velocity.y = -JUMP_HEIGHT

func start_fight():
	$hello.play()
	yield($hello, "finished")
	$tnt_spawn.start()
	state = 1


func _on_idle_finished():
	yield(get_tree().create_timer(3), "timeout")
	_random_voice()


func _on_hello_finished():
	yield(get_tree().create_timer(3), "timeout")
	_random_voice()

func _random_voice():
	randomize()
	$idle.stream = voices[rand_range(0, len(voices))]
	$idle.play()


func _on_shoot_time_timeout():
	shoot1 = false
	state = 1


func _on_tnt_spawn_timeout():
	var tnt = tnt_pref.instance()
	tnt.rotation_degrees = 0
	get_tree().get_current_scene().add_child(tnt)
	randomize()
	tnt.position = Vector2(rand_range($"../left".position.x, $"../right".position.x), 1568)


func _on_hurtTimer_timeout():
	$chr.modulate = Color.white
