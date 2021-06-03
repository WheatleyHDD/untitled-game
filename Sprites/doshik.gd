extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for i in $RigidBody2D/Area2D.get_overlapping_bodies():
		if i.has_meta("name"):
			match i.get_meta("name"):
				"Player":
					if Input.is_action_just_pressed("use") and visible:
						randomize() 
						i.hp += rand_range(25, 50)
						$eat.play()
						i.key_info_close()
						visible = false
						$RigidBody2D/Area2D/CollisionShape2D.disabled = true


func _on_Area2D_body_entered(body):
	if body.has_meta("name"):
		match body.get_meta("name"):
			"Player":
				body.key_info_open()

func _on_player_die():
	pass

func _on_Area2D_body_exited(body):
	if body.has_meta("name"):
		match body.get_meta("name"):
			"Player":
				body.key_info_close()
