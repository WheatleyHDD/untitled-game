extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var on = false
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
						if on:
							$AnimationPlayer.play("off")
						else:
							$AnimationPlayer.play("on")


func _on_Area2D_body_entered(body):
	if body.has_meta("name"):
		match body.get_meta("name"):
			"Player":
				body.key_info_open()


func _on_AnimationPlayer_animation_finished(anim_name):
	if get_node_or_null(object):
		if anim_name == "on":
			on = true
			if get_node(object).has_method("activated"):
				get_node(object).activated()
		elif anim_name == "off":
			on = false
			if get_node(object).has_method("deactivated"):
				get_node(object).deactivated()


func _on_Area2D_body_exited(body):
	if body.has_meta("name"):
		match body.get_meta("name"):
			"Player":
				body.key_info_close()
