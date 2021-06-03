extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var blood = preload("res://Prefabs/blood.tscn")
onready var expl = preload("res://Prefabs/Explosion.tscn")
onready var doshik_pref = preload("res://Prefabs/doshik.tscn")

export var SPEED = 600
var JUMP_HEIGHT = 1780
#var MIN_JUMP_HEIGHT = 300
var GRAVITY = 30
var ACCELERATION = 1500
var DECCELERATION = 100

var input_f = 0

export(float) var hp = 1200

export var enabled = true
var velocity = Vector2()

# 0 - просто стойка
# 1 - бегает и прыгает на игрока
# 2 - ???
var state = 0
var die_trigger = false

signal dies

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("name", "Enemy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp <= 0 and !die_trigger:
		die_trigger = true
		if get_node_or_null("../../Player"):
			$"../BossMusicPlayer".stop()
			$"../../Player".stop_control = true
			$"../../Camera2D".follow = false
			$"../AnimationPlayer".play("die")
			yield(get_tree().create_timer(6), "timeout")
			$"../../TileMap".set_cell(375, 67, -1)
			$"../../TileMap".set_cell(376, 67, -1)
			$"../../TileMap".set_cell(377, 67, -1)
			$"../../TileMap".set_cell(378, 67, -1)
			$"../../TileMap".set_cell(379, 67, -1)
			$"../../TileMap".set_cell(380, 67, -1)
			$"../../TileMap".set_cell(381, 67, -1)
			$"../../TileMap".set_cell(382, 67, -1)
			$"../../TileMap".set_cell(383, 67, -1)
			$"../../TileMap".set_cell(384, 67, -1)
			yield($"../AnimationPlayer", "animation_finished")
			$"../../Player".stop_control = false
			queue_free()
		emit_signal("dies")
#		var bloodinst = blood.instance()
#		bloodinst.position = position
#		get_node("../").add_child(bloodinst)
#		bloodinst.restart()
#		queue_free()

func hurt():
	if visible:
		modulate = Color.red
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
	if state == 1 and get_node_or_null("../../Player"):
		if position.x < $"../../Player".position.x:
			input_f = 1
		elif position.x >= $"../../Player".position.x:
			input_f = -1
		
		if is_on_floor():
			jump()
	
	if enabled:
		
		velocity.y += GRAVITY
		
		if input_f != 0:
			velocity = velocity.move_toward(Vector2(input_f*SPEED,velocity.y), ACCELERATION*delta)
		else:
			velocity = velocity.move_toward(Vector2(0, velocity.y), DECCELERATION*delta)
		
		velocity = move_and_slide(velocity, Vector2.UP)

func jump():
	velocity.y = -JUMP_HEIGHT

func start_fight():
	$"../AnimationPlayer".play("up")
	yield($"../AnimationPlayer", "animation_finished")
	$"../BossMusicPlayer".play()
	$"../../Player".show_music_info("Cleaning Service", "GLWZBLL")
	state = 1


func _on_Area2D_body_entered(body):
	if body.has_meta("name"):
		match body.get_meta("name"):
			"Player":
				body.hurt(false)
				randomize()
				body.hp -= rand_range(10, 30)


func _on_hurtTimer_timeout():
	modulate = Color.white
