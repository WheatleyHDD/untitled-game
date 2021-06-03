extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current = false


# Called when the node enters the scene tree for the first time.
func _ready():
	set_visible(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Zone_body_entered(body):
	if body.has_meta("name"):
		if body.get_meta("name") == "Player":
			$Camera2D.current = true

func _on_Zone_body_exited(body):
	if body.has_meta("name"):
		if body.get_meta("name") == "Player":
			$Camera2D.current = false
