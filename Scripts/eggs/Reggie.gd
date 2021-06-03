extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var blood = preload("res://Prefabs/blood.tscn")
onready var expl = preload("res://Prefabs/Explosion.tscn")

onready var weapon_drop = preload("res://Prefabs/weaponDrop.tscn")


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
	start_pos = position
	set_meta("name", "Enemy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if hp <= 0:
		var bloodinst = blood.instance()
		bloodinst.position = position
		get_node("../").add_child(bloodinst)
		bloodinst.restart()
		queue_free()

func explode():
	var explosion = expl.instance()
	explosion.position = position
	get_node("../").add_child(explosion)
	explosion.play("default")
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

func hurt():
	if visible:
		$Sprite.modulate = Color.red
		$hurtTimer.start()


func _on_AudioStreamPlayer_finished():
	explode()


func _on_hurtTimer_timeout():
	$Sprite.modulate = Color.white
