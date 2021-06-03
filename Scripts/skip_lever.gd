extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(NodePath) var object

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for i in $Area2D.get_overlapping_bodies():
		if i.has_meta("name"):
			match i.get_meta("name"):
				"Player":
					if Input.is_action_just_pressed("use"):
						$AnimationPlayer.play("off")
						yield($AnimationPlayer, "animation_finished")
						get_node(object).skipped()


func _on_Area2D_body_entered(body):
	if body.has_meta("name"):
		match body.get_meta("name"):
			"Player":
				body.key_info_open()
