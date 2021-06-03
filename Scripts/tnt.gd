extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var shoot = false
onready var bullet_pref = preload("res://Prefabs/boss_bullet.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shoot:
		shoot = false
		for i in range(14):
			var bullet = bullet_pref.instance()
			bullet.rotation_degrees = i*360/14
			bullet.position = position
			bullet.SPEED = 250
			get_tree().get_current_scene().add_child(bullet)


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
