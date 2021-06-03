extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_cbullets_body_entered(body):
	if body.has_meta("name"):
		match body.get_meta("name"):
			"Player":
				randomize()
				if body.has_method("hurt"):
					body.hurt(false)
				body.hp -= rand_range(25, 40)
			"Enemy":
				return
