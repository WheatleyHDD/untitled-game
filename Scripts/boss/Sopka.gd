extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var blood = preload("res://Prefabs/blood.tscn")
onready var expl = preload("res://Prefabs/Explosion.tscn")
onready var doshik_pref = preload("res://Prefabs/doshik.tscn")
onready var tnt_pref = preload("res://Prefabs/tnt.tscn")
onready var bullet_pref = preload("res://Prefabs/boss_bullet.tscn")

export var SPEED = 360
var JUMP_HEIGHT = 650
#var MIN_JUMP_HEIGHT = 300
var GRAVITY = 30
var ACCELERATION = 4500
var DECCELERATION = 4500

var input_f = 0

export(float) var hp = 2500
var velocity = Vector2()

export var shield = true

# 0 - стояние (0 - 15)
# 1 - динамит (15 - 30)
# 2 - движение (30 - 60)
# 3 - движение и динамит (60 - 105)
# 4 - остановка перевод духа (105 - 120)
# 5 - движение (120 - 151)
export var state = 0
export var state4 = false

# четн - вправо
# нечетн - влево
var kuda = 1

var halfHp = false

export var tnt_shoot = false


signal dies

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node_or_null("../../Player"):
		$"../../Player".connect("player_hurt", self, "_on_player_hurt")
	$chr.scale.x = -1
	$chr.setAnimationSpeed(SPEED)
	set_meta("name", "Enemy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tnt_shoot:
		tnt_shoot = false
		var tnt = tnt_pref.instance()
		tnt.rotation_degrees = 0
		get_tree().get_current_scene().add_child(tnt)
		randomize()
		tnt.position = Vector2(rand_range(21984, 22784), 128)
	
	if hp <= 1250 and !halfHp:
		halfHp = true
		randomize()
		get_node("half_hp" + str(randi() % 2 + 1)).play()
	
	if state4:
		state4 = false
		spawn_doshik(Vector2(rand_range(21984, 22784), 128))
	
	if state == 4:
		input_f = 0
	
	if state == 7:
		if get_node_or_null("../../Player"):
			var bullet = bullet_pref.instance()
			bullet.rotation_degrees = get_angle_to(get_node_or_null("../../Player").position)
			bullet.position = position
			bullet.SPEED = 400
			get_tree().get_current_scene().add_child(bullet)
	
	if state == 2 or state == 3 or state == 5:
		if $ShootTimer.is_stopped():
			$ShootTimer.start()
		if $IdleTimer.is_stopped():
			$IdleTimer.start()
		if kuda % 2 == 0:
			if position.x < $"../right".position.x:
				if is_on_floor():
					$land.play()
					$"../../Camera2D".shake(20, 0.2)
					jump()
				input_f = 1
			else:
				input_f = 0
				kuda += 1
				shield = false
		elif kuda % 2 != 0:
			if position.x > $"../left".position.x:
				if is_on_floor():
					$land.play()
					$"../../Camera2D".shake(20, 0.2)
					jump()
				input_f = -1
			else:
				input_f = 0
				kuda += 1
				shield = false
	
	if shield:
		get_node_or_null("shield").visible = true
	else:
		get_node_or_null("shield").visible = false
	
	if hp <= 0:
		emit_signal("dies")
		$"../AnimationPlayer".stop()
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

func shoot():
	var bullet = bullet_pref.instance()
	randomize()
	bullet.rotation_degrees = rand_range(0, 360)
	bullet.position = position
	bullet.SPEED = 250
	get_tree().get_current_scene().add_child(bullet)

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

func has_shield():
	return shield

func start_fight():
	$"../BossMusicPlayer".play()
	$"../AnimationPlayer".play("fight")


func _on_ShootTimer_timeout():
	shoot()

func _on_player_hurt():
	if state >= 1:
		randomize()
		get_node("shoot" + str(randi() % 6 + 1)).play()

func _on_BossMusicPlayer_finished():
	if hp <= 650:
		var explosion = expl.instance()
		explosion.position = position
		get_node("../").add_child(explosion)
		explosion.play("default")
		if get_node_or_null("../../Player"):
			get_node_or_null("../../Player/CanvasLayer/Control2/BossHP").hide()
			emit_signal("dies")
		queue_free()
	else:
		state = 7


func _on_IdleTimer_timeout():
	randomize()
	get_node("idle" + str(randi() % 3 + 1)).play()


func _on_hurtTimer_timeout():
	$chr.modulate = Color.white
