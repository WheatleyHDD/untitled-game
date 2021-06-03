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
						i.velocity = Vector2(-i.last_input_f * 800, -600)
						if OS.get_name() == "Android":
							i.hp -= 25
						else:
							i.hp -= 50
						$pl_sc.start()
						yield($pl_sc, "timeout")
						if i.visible:
							i.stop_control = false
				"Enemy":
					if i.name != "Byte" and i.name != "anonimus" and i.name != "Dimas":
						i.hp = -1


