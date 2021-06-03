extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var next_layout = "res://Scene/Level1.tscn"
signal fade_finished


# Called when the node enters the scene tree for the first time.
func _ready():
	$pause/PanelContainer/VBoxContainer/Label.text = $"/root/Translate".get_translation("PauseLabel")
	$pause/PanelContainer/VBoxContainer/continue.text = $"/root/Translate".get_translation("PauseContinue")
	$pause/PanelContainer/VBoxContainer/restart.text = $"/root/Translate".get_translation("PauseRestart")
	$pause/PanelContainer/VBoxContainer/toMenu.text = $"/root/Translate".get_translation("PauseToMenu")

func fade_in():
	$fade.visible = true
	$fade/AnimationPlayer.play("play")
	yield($fade/AnimationPlayer, "animation_finished")
	emit_signal("fade_finished")

func fade_out():
	$fade.visible = true
	$fade/AnimationPlayer.play_backwards("play")
	yield($fade/AnimationPlayer, "animation_finished")
	emit_signal("fade_finished")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") and get_tree().get_current_scene().name == "Level":
		$"/root/UI/pause".visible = !$"/root/UI/pause".visible
		if $"/root/UI/pause".visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	if Input.is_action_just_pressed("music_mute"):
		$sound.visible = !$sound.visible
	
	if $pause.visible:
		get_tree().set_pause(true)
		Engine.set_time_scale(0)
	else:
		get_tree().set_pause(false)
		Engine.set_time_scale(1)
	
	if !$sound.visible:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), $"/root/Settings".setting["music_volume"])
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)


func _on_continue_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$pause.visible = false


func _on_restart_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$pause.visible = false
	$"/root/GameOver/Control".visible = false
	var ok = SimpleSave.load_scene(get_tree(), "res://save_slots/snapshot0.tscn")
	if ok != OK:
		print(ok)
		get_tree().reload_current_scene()


func _on_toMenu_pressed():
	$pause.visible = false
	$"/root/GameOver/Control".visible = false
	var d = Directory.new()
	if d.file_exists("res://save_slots/snapshot0.tscn"):
		d.remove("res://save_slots/snapshot0.tscn")
	$"/root/UI".next_layout = "res://Scene/Menu.tscn"
	get_tree().change_scene("res://Scene/logo_screen.tscn")
