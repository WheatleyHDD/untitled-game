extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var blood = preload("res://Prefabs/blood.tscn")
onready var expl = preload("res://Prefabs/Explosion.tscn")

export var enabled = true
export var stop_control = false

export (NodePath) var joystickLeftPath
onready var joystickLeft : Joystick = get_node(joystickLeftPath)

export (NodePath) var joystickRightPath
onready var joystickRight : Joystick = get_node(joystickRightPath)

var SPEED = 420
var JUMP_HEIGHT = 770
var MIN_JUMP_HEIGHT = 300
var GRAVITY = 30
var ACCELERATION = 4500
var DECCELERATION = 4500

var snap_normal = Vector2.DOWN setget set_snap_normal
var jumping = false

export var hp: float = 200
var invisible = false

var toRight = 0
var toLeft = 0

var boxUsed = false
var box
export var current_weapon = 0

var last_input_f = 0
var velocity = Vector2()

signal player_hurt
signal die

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() == "Android":
		$cursor.visible = false
	else:
		$CanvasLayer/Controls.visible = false
	$weapon.set_weapon(current_weapon)
	set_meta("name", "Player")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$cursor.set_as_toplevel(true)


func explode():
	emit_signal("die")
	var explosion = expl.instance()
	explosion.position = position
	get_node("../").add_child(explosion)
	explosion.play("default")
	stop_control = true
	visible = false
	enabled = false
	$CollisionShape2D.disabled = true
	Engine.set_time_scale(0.3)
	yield(get_tree().create_timer(1.5), "timeout")
	Engine.set_time_scale(1)
	yield(get_tree().create_timer(2), "timeout")
	$"/root/GameOver/Control".set_visible(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if OS.get_name() == "Android":
		if joystickRight and joystickRight.is_working:
				if enabled and !stop_control and visible:
					$weapon.rotation = joystickRight.output.angle()
					if !$weapon/RayCast2D.is_colliding():
						$weapon.shoot("")
					if joystickRight.output.x < 0:
						$weapon.scale.y = -1
					else:
						$weapon.scale.y = 1
		else:
			$weapon/akshooting.stop()
	
	if $head.is_colliding() and $foot.is_colliding():
		if ($head.get_collider().name == "TileMap" or $head.get_collider().has_meta("mov_plat")) and $foot.get_collider().name == "TileMap":
			hp = -1
	
	$cursor.position = get_global_mouse_position()
	
	$weapon.stop_aim = stop_control
	current_weapon = $weapon.curr_weapon_id
	$hand.set_cast_to(Vector2(cos(get_angle_to(get_global_mouse_position())) * 70, sin(get_angle_to(get_global_mouse_position())) * 70))
	$CanvasLayer/Control/ProgressBar.value = hp
	if hp <= 0 and visible:
		emit_signal("die")
		var bloodinst = blood.instance()
		bloodinst.position = position
		get_node("../").add_child(bloodinst)
		bloodinst.restart()
		stop_control = true
		visible = false
		enabled = false
		$CollisionShape2D.disabled = true
		Engine.set_time_scale(0.3)
		yield(get_tree().create_timer(1.5), "timeout")
		Engine.set_time_scale(1)
		yield(get_tree().create_timer(2), "timeout")
		$"/root/GameOver/Control".set_visible(true)
	
	if boxUsed:
		box.sleeping = true
		box.gravity_scale = 0
		box.position = to_global($hand.cast_to)
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			boxUsed = false
			box.sleeping = false
			box.gravity_scale = 10
			box.apply_central_impulse(Vector2(1,1))
			box = null
		if Input.is_action_just_pressed("use"):
			boxUsed = false
			box.sleeping = false
			box.gravity_scale = 10
			box = null
	
#	if $hand.is_colliding() and Input.is_action_just_pressed("use") and $hand.get_collider().has_meta("name"):
#		if $hand.get_collider().get_meta("name") == "Box":
#			box = $hand.get_collider()
#			boxUsed = true
	

func _physics_process(delta):
	if enabled:
		var input_f = 0
		if !stop_control:
			if joystickLeft and joystickLeft.is_working:
				input_f = joystickLeft.output.x
			else:
				input_f = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		
		if is_on_floor():
			if (Input.is_action_just_pressed("jump") and !stop_control) or (joystickLeft and joystickLeft.is_working and joystickLeft.output.y < -0.5):
				$Jump.play()
				jumping = true
				velocity.y = -JUMP_HEIGHT
		
		if Input.is_action_just_released("jump") or (jumping and joystickLeft and joystickLeft.is_working and joystickLeft.output.y > -0.5):
			if velocity.y < -MIN_JUMP_HEIGHT:
				velocity.y = -MIN_JUMP_HEIGHT
		
		velocity.y = clamp(velocity.y + GRAVITY, -99999999999, 1000)
		
		if jumping and velocity.y > 0:
			jumping = false
		
		set_snap_normal(Vector2.DOWN)
		if jumping:
			set_snap_normal(Vector2.ZERO)
		
		if input_f != 0:
			$chr.setState("walk")
			last_input_f = input_f
			velocity = velocity.move_toward(Vector2(input_f*SPEED,velocity.y), ACCELERATION*delta)
		else:
			$chr.setState("idle")
			velocity = velocity.move_toward(Vector2(0, velocity.y), DECCELERATION*delta)
		
		velocity = move_and_slide_with_snap(velocity, snap_normal*20, Vector2.UP)


func set_snap_normal(new_snap_normal):
	snap_normal = new_snap_normal

func hurt(inv: bool = true):
	if visible:
		emit_signal("player_hurt")
		$hit.play()
		$chr.modulate = Color.red
		$hurtTimer.start()
		if inv:
			$AnimationPlayer.play("hurt")

func set_invisible():
	invisible = true
	yield(get_tree().create_timer(1), "timeout")
	invisible = false

func show_music_info(title: String, author:String, warn: bool = false):
	$CanvasLayer/MusicInfo/title.text = title
	$CanvasLayer/MusicInfo/author.text = author
	$CanvasLayer/MusicInfo/warn.visible = warn
	$CanvasLayer/MusicInfo/AnimationPlayer.play("show")

func key_info_open():
	$key/AnimationPlayer.play("open")

func key_info_close():
	$key/AnimationPlayer.play_backwards("open")


func _on_hurtTimer_timeout():
	$chr.modulate = Color.white
