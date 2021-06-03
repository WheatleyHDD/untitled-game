extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("spike", "da")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for i in get_overlapping_bodies():
		if i.has_meta("name"):
			match i.get_meta("name"):
				"Player":
					if !i.stop_control and !i.invisible:
						i.stop_control = true
						i.set_invisible()
						i.hurt()
						i.hp -= 50
						i.velocity = Vector2(-i.last_input_f * 800, -600)
						$pl_sc.start()
						yield($pl_sc, "timeout")
						if i.visible:
							i.stop_control = false
						
				"Enemy":
					i.hp = -1
			


