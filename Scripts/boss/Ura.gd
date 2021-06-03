extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var blood = preload("res://Prefabs/blood.tscn")
onready var expl = preload("res://Prefabs/Explosion.tscn")
onready var knife_pref = preload("res://Prefabs/knife.tscn")

export(float) var hp = 1500

signal dies

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("name", "Enemy")
#	for i in range(12):
#		var bullet = knife_pref.instance()
#		bullet.rotation_degrees = i*360/12
#		bullet.position = $knifes.position
#		bullet.SPEED = 2
#		$knifes.add_child(bullet)


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
	if get_node_or_null("../../Player"):
		for i in range(5):
			var bullet = knife_pref.instance()
			bullet.rotation_degrees = 90
			randomize()
			bullet.position = Vector2(get_node_or_null("../../Player").position.x + rand_range(-48, 48), 3488 + rand_range(-48,48))
			bullet.SPEED = 1000
			get_tree().get_current_scene().add_child(bullet)
			$"../../Camera2D".shake(30, 0.4)


func _on_hurtTimer_timeout():
	$Sprite.modulate = Color.white
