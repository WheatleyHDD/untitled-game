extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var blood = preload("res://Prefabs/blood.tscn")
onready var expl = preload("res://Prefabs/Explosion.tscn")
onready var doshik_pref = preload("res://Prefabs/doshik.tscn")

export(int, "No Weapon", "AK-47", "Bomp", "Shootgun") var weapon_start

export var SPEED = 360
var JUMP_HEIGHT = 500
#var MIN_JUMP_HEIGHT = 300
var GRAVITY = 30
var ACCELERATION = 4500
var DECCELERATION = 4500

var input_f = 0

export(float) var hp = 1200

var velocity = Vector2()

# 0 - Стояние
# 1 - Хождение
# 2 - Стрельба
var state = 0 

# четн - вправо
# нечетн - влево
var kuda = 1

var shield = false
var shoot = false
var started = false

var half_hp = false

signal dies

# Called when the node enters the scene tree for the first time.
func _ready():
	$chr.scale.x = -1
	$weapon.scale.x = -1
	$chr.setAnimationSpeed(SPEED)
	set_meta("name", "Enemy")
	$weapon.set_weapon(weapon_start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if hp <= 750 and !half_hp:
#		half_hp = true
#		spawn_doshik(Vector2(rand_range(8064, 8544), rand_range(2368, 2560)))
#		spawn_doshik(Vector2(rand_range(8064, 8544), rand_range(2368, 2560)))
#		spawn_doshik(Vector2(rand_range(8064, 8544), rand_range(2368, 2560)))
		
	
	if shield:
		get_node_or_null("shield").visible = true
	else:
		get_node_or_null("shield").visible = false
	
	if state == 1:
		if kuda % 2 == 0:
			if position.x < 8736:
				if is_on_floor():
					jump()
				input_f = 1
			else:
				input_f = 0
				kuda += 1
				state = 2
				shield = false
		elif kuda % 2 != 0:
			if position.x > 7904:
				if is_on_floor():
					jump()
				input_f = -1
			else:
				input_f = 0
				kuda += 1
				state = 2
				shield = false
	elif state == 2:
		if $to_shoot.is_stopped():
			$to_shoot.start()
		shoot = true
		
	if shoot:
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
	
	if state == 1:
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

func has_shield():
	return shield

func start_fight():
	randomize()
	$random_voice.start(rand_range(5, 10))
	$voice1.play()
	$"../BossMusicPlayer".play()
	started = true
	yield(get_tree().create_timer(1), "timeout")
	state = 1


func _on_to_shoot_timeout():
	shoot = false
	state = 1
	shield = true


func _on_random_voice_timeout():
	randomize()
	var c = (randi() % 8) + 1
	get_node("voice" + str(c)).play()
	$random_voice.start(rand_range(5, 10))


func _on_hurtTimer_timeout():
	$chr.modulate = Color.white
