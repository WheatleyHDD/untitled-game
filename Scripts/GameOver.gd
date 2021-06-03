extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart") and get_tree().get_current_scene().name == "Level":
		get_tree().set_pause(false)
		Engine.set_time_scale(1)
		$Control.visible = false
		var d = Directory.new()
		if d.file_exists("user://save_slots/snapshot0.tscn"):
			SimpleSave.load_scene(get_tree(), "user://save_slots/snapshot0.tscn")
		else:
			get_tree().reload_current_scene()
