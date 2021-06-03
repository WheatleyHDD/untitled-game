extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var blood = preload("res://Prefabs/blood.tscn")
onready var expl = preload("res://Prefabs/Explosion.tscn")
onready var doshik_pref = preload("res://Prefabs/doshik.tscn")
onready var bullet_pref = preload("res://Prefabs/boss_bullet.tscn")

export(float) var hp = 700

signal dies

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("name", "Enemy")

func shoot():
	for i in range(14):
		var bullet = bullet_pref.instance()
		bullet.rotation_degrees = i*360/14
		bullet.position = get_node("../").position
		bullet.SPEED = 350
		get_tree().get_current_scene().add_child(bullet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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


func _on_shootTimer_timeout():
	pass
#	shoot()


func _on_hurtTimer_timeout():
	$Sprite.modulate = Color.white
