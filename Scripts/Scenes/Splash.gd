extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VideoPlayer_finished():
	$ColorRect/AnimationPlayer.play("fade")
	yield($ColorRect/AnimationPlayer, "animation_finished")
	$"/root/UI".next_layout = "res://Scene/Menu.tscn"
	get_tree().change_scene("res://Scene/logo_screen.tscn")
