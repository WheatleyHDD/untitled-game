extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SPEED = 300
var start_pos: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position = position + Vector2(cos(rotation) * SPEED, sin(rotation) * SPEED) * delta


func _on_bullet_body_entered(body):
	if body.has_meta("name"):
		match body.get_meta("name"):
			"Player":
				randomize()
				if body.has_method("hurt"):
					body.hurt(false)
				body.hp -= rand_range(25, 40)
			"Enemy":
				return
	queue_free()


func _on_LTTimer_timeout():
	queue_free()
