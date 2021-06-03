extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var blood = preload("res://Prefabs/blood.tscn")
onready var expl = preload("res://Prefabs/Explosion.tscn")

onready var crate_pref = preload("res://Prefabs/crate.tscn")
onready var doshik_pref = preload("res://Prefabs/doshik.tscn")

onready var bullet_pref = preload("res://Prefabs/boss_bullet.tscn")

export var SPEED = 360
var JUMP_HEIGHT = 1000
var GRAVITY = 30
var ACCELERATION = 4500
var DECCELERATION = 4500

var input_f = 0
export var jumps = false
export var shoot1 = false
export var shoot2 = false

var shoot2count = 0

export var shoot3 = false

var enabled = true
var shield = false

var rotat

export(float) var hp = 1500

var velocity = Vector2()
var start_pos


# Called when the node enters the scene tree for the first time.
func _ready():
	$chr.setAnimationSpeed(SPEED)
	start_pos = position
	set_meta("name", "Enemy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shield = $shield.visible
	if jumps and is_on_floor():
		jumps = false
		jump()
	
	if shoot1:
		randomize()
		circle_shoot(Vector2(rand_range(6496, 7584), rand_range(96, 280)), false, 16)
		shoot1 = false
	
	if hp <= 0:
		var bloodinst = blood.instance()
		bloodinst.position = position
		get_node("../").add_child(bloodinst)
		bloodinst.restart()
		if get_node_or_null("../../Player"):
			get_node_or_null("../../Player/CanvasLayer/Control2/BossHP").hide()
			get_tree().get_current_scene().boss_defeat()
		queue_free()

func _physics_process(delta):
	
	if shoot2:
		shoot2count += 1
		if shoot2count % 2 == 0:
			shoot(rotat)
		rotat += delta*30
	else:
		rotat = 0
	
	if shoot3:
		if get_node_or_null("../../Player"):
			shoot(get_angle_to(get_node_or_null("../../Player").position))
	if enabled:
		
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

func circle_shoot(pos: Vector2, toglobal: bool = true, count: int = 12):
	for i in range(count):
		var bullet = bullet_pref.instance()
		bullet.rotation_degrees = i*360/count
		if toglobal:
			bullet.position = to_global(pos)
		else:
			bullet.position = pos
		get_tree().get_current_scene().add_child(bullet)

func shoot(rot: float):
	var bullet = bullet_pref.instance()
	bullet.rotation = rot
	bullet.position = self.position
#	print(self.position.x, self.position.y)
#	print(to_global(self.position).x, to_global(self.position).y)
#	print()
	get_parent().add_child(bullet)

func spawn_doshik(pos: Vector2, toglobal: bool = false):
	var doshik = doshik_pref.instance()
	doshik.rotation_degrees = 0
	if toglobal:
		doshik.position = to_global(pos)
	else:
		doshik.position = pos
	get_tree().get_current_scene().add_child(doshik)

func has_shield():
	return shield

func hurt():
	if visible:
		$chr.modulate = Color.red
		$hurtTimer.start()

func start_fight():
	var stage = 0
	$"../BossMusicPlayer".play()
	yield(get_tree().create_timer(14), "timeout")
	$shield.visible = false
	jump()
	yield(get_tree().create_timer(0.3), "timeout")
	enabled = false
	$AnimationPlayer.play("rotate")
	shoot2 = true
	print(1)
	yield(get_tree().create_timer(28.5), "timeout")
	spawn_doshik(Vector2(rand_range(6496, 7264), rand_range(96, 480)))
	spawn_doshik(Vector2(rand_range(6496, 7264), rand_range(96, 480)))
	spawn_doshik(Vector2(rand_range(6496, 7264), rand_range(96, 480)))
	shoot2 = false
	$shield.visible = true
	$AnimationPlayer.stop()
	rotation_degrees = 0
	enabled = true
	print(2)
	yield(get_tree().create_timer(15.3), "timeout")
	$"../shoot_time".play("1")
	print(3)
	yield($"../shoot_time", "animation_finished")
	spawn_doshik(Vector2(rand_range(6496, 7264), rand_range(96, 480)))
	spawn_doshik(Vector2(rand_range(6496, 7264), rand_range(96, 480)))
	yield(get_tree().create_timer(0.5), "timeout")
	$shield.visible = false
	jump()
	yield(get_tree().create_timer(0.3), "timeout")
	shoot2 = true
	enabled = false
	$AnimationPlayer.play("rotate")
	yield(get_tree().create_timer(28.5), "timeout")
	spawn_doshik(Vector2(rand_range(6496, 7264), rand_range(96, 480)))
	spawn_doshik(Vector2(rand_range(6496, 7264), rand_range(96, 480)))
	spawn_doshik(Vector2(rand_range(6496, 7264), rand_range(96, 480)))
	shoot2 = false
	yield(get_tree().create_timer(2), "timeout")
	$"../shoot_time".play("2")


func _on_BossMusicPlayer_finished():
	
	shoot2 = false
	$shield.visible = true
	$AnimationPlayer.stop()
	rotation_degrees = 0
	enabled = true
	if hp <= 1500/4:
		yield(get_tree().create_timer(1), "timeout")
		$chr.scale.x = -1
		yield(get_tree().create_timer(1), "timeout")
		$chr.scale.x = 1
		yield(get_tree().create_timer(1), "timeout")
		$mat.play()
		yield($mat, "finished")
		var explosion = expl.instance()
		explosion.position = position
		get_node("../").add_child(explosion)
		explosion.play("default")
		if get_node_or_null("../../Player"):
			get_node_or_null("../../Player/CanvasLayer/Control2/BossHP").hide()
			get_tree().get_current_scene().boss_defeat()
		queue_free()
#		var crate = crate_pref.instance()
#		crate.position = Vector2(position.x, position.y - 672)
#		get_parent().add_child(crate)
	else:
		shoot3 = true


func _on_hurtTimer_timeout():
	$chr.modulate = Color.white
