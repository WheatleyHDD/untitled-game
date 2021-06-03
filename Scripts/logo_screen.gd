extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/UI/fade".visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	$"/root/UI/fade".visible = true
	get_tree().change_scene($"/root/UI".next_layout)
#	get_tree().quit()
