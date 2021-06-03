extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var blood = preload("res://Prefabs/blood.tscn")
onready var expl = preload("res://Prefabs/Explosion.tscn")
onready var bullet_pref = preload("res://Prefabs/boss_bullet.tscn")

export var SPEED = 520
var JUMP_HEIGHT = 650
#var MIN_JUMP_HEIGHT = 300
var GRAVITY = 0 # Он равен 30
var ACCELERATION = 4500
var DECCELERATION = 4500

var input_f = 0

export(float) var hp = 1500

var velocity = Vector2()

# 0 - Стояние
# 1 - Хождение
var state = 0 

# четн - вправо
# нечетн - влево
var kuda = 1

var shoot = false
var fallen = false

signal dies

# Called when the node enters the scene tree for the first time.
func _ready():
	scale.x = 1
	set_meta("name", "Enemy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == 0 and is_on_floor():
		if !fallen:
			fallen = true
			$land.play()
			$"../../Camera2D".shake(50, 0.2)
	
	if state == 1:
		if kuda % 2 == 0:
			if position.x < $"../right".position.x:
				if is_on_floor():
					$land.play()
					$"../../Camera2D".shake(2, 0.2)
					jump()
				input_f = 1
			else:
				scale.x = scale.x * -1
				input_f = 0
				kuda += 1
		elif kuda % 2 != 0:
			if position.x > $"../left".position.x:
				if is_on_floor():
					$land.play()
					$"../../Camera2D".shake(2, 0.2)
					jump()
				input_f = -1
			else:
				scale.x = scale.x * -1
				input_f = 0
				kuda += 1
	
	if hp <= 0:
		emit_signal("dies")
		var bloodinst = blood.instance()
		bloodinst.position = position
		get_node("../").add_child(bloodinst)
		bloodinst.restart()
		queue_free()

func hurt():
	if visible:
		$Sprite.modulate = Color.red
		$hurtTimer.start()

func explos():
	var explosion = expl.instance()
	explosion.position = position
	get_node("../").add_child(explosion)
	explosion.play("default")
	if get_node_or_null("../../Player"):
		emit_signal("dies")
	queue_free()

func _physics_process(delta):
	
	velocity.y += GRAVITY
	
	if input_f != 0:
		velocity = velocity.move_toward(Vector2(input_f*SPEED,velocity.y), ACCELERATION*delta)
	else:
		velocity = velocity.move_toward(Vector2(0, velocity.y), DECCELERATION*delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func jump():
	velocity.y = -JUMP_HEIGHT


func start_fight():
	visible = true
	GRAVITY = 30
	yield(get_tree().create_timer(1.3), "timeout")
	state = 1
	$shootTimer.start()

func shoot():
	var bullet = bullet_pref.instance()
	randomize()
	bullet.rotation_degrees = rand_range(0, 360)
	bullet.position = position
	bullet.SPEED = 350
	get_tree().get_current_scene().add_child(bullet)

func _on_shootTimer_timeout():
	shoot()


func _on_hurtTimer_timeout():
	$Sprite.modulate = Color.white
