extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SPEED = 900
var ofPlayer = false
var weapon_type = 0
var whos_bullet = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position = position + Vector2(cos(rotation) * SPEED, sin(rotation) * SPEED) * delta


func _on_bullet_body_entered(body):
	if body.visible:
		if body.has_meta("name"):
			match body.get_meta("name"):
				"Player":
					if !ofPlayer:
						body.hurt(false)
						body.hp -= _get_damage(weapon_type) / 2
						if get_tree().get_current_scene().get_node_or_null(whos_bullet):
							if get_tree().get_current_scene().get_node(whos_bullet).has_method("popal"):
								get_tree().get_current_scene().get_node(whos_bullet).popal()
				"Enemy":
					if body.name != whos_bullet:
						if body.has_method("has_shield"):
							if !body.has_shield():
								if body.has_method("hurt"):
									body.hurt()
								body.hp -= _get_damage(weapon_type)
						else:
							if body.has_method("hurt"):
								body.hurt()
							body.hp -= _get_damage(weapon_type)
		if body.name != whos_bullet:
			if !body.has_meta("spike"):
				queue_free()

func _get_damage(type: int) -> float:
	match type:
		0:
			return 0.0
		1: 
			randomize()
			return rand_range(5, 10)
		2:
			return 0.0
		3:
			randomize()
			return rand_range(20, 30)
		4:
			randomize()
			return rand_range(70, 110)
		5:
			return 999.0
		6: 
			randomize()
			return rand_range(8, 13)
	return 0.0
			

func _on_LTTimer_timeout():
	queue_free()
