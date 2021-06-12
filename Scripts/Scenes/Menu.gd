extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/DiscordManager".send_activity("In Menu", "Idle")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if !$"/root/End/EndMusicPlayer".playing:
		$MusicPlayer.play()
	if $"/root/Saves".lvl > 1:
		$CanvasLayer/Control/MenuPanel/VBoxContainer/ContinueButton.disabled = false
	$CanvasLayer/Control/SettingsPanel/VBoxContainer/MusicVolume/HSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	$CanvasLayer/Control/SettingsPanel/VBoxContainer/SoundVolume/HSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound"))
	$CanvasLayer/Control/SettingsPanel/VBoxContainer/DialogVolume/HSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Dialogs"))
	$CanvasLayer/Control/SettingsPanel/VBoxContainer/Fullscreen/CheckButton.pressed = OS.window_fullscreen
	$CanvasLayer/Control/SettingsPanel/VBoxContainer/Language/OptionButton.select($"/root/Settings".setting["lang"])
	translateStrings()

func translateStrings():
		# Переводы
		$"CanvasLayer/Control/MenuPanel/VBoxContainer/PlayButton".text = $"/root/Translate".get_translation("PlayButton")
		$CanvasLayer/Control/MenuPanel/VBoxContainer/ContinueButton.text = $"/root/Translate".get_translation("ContinueButton")
		$CanvasLayer/Control/MenuPanel/VBoxContainer/SettingsButton.text = $"/root/Translate".get_translation("SettingsButton")
		$CanvasLayer/Control/MenuPanel/VBoxContainer/ControlInfoButton.text = $"/root/Translate".get_translation("ControlInfoButton")
		$CanvasLayer/Control/MenuPanel/VBoxContainer/TitlesButton.text = $"/root/Translate".get_translation("TitlesButton")
		$CanvasLayer/Control/MenuPanel/VBoxContainer/ExitButton.text = $"/root/Translate".get_translation("ExitButton")
		$CanvasLayer/Control/SettingsPanel/VBoxContainer/MusicVolume/Label.text = $"/root/Translate".get_translation("MusicVolSet")
		$CanvasLayer/Control/SettingsPanel/VBoxContainer/SoundVolume/Label.text = $"/root/Translate".get_translation("SoundVolSet")
		$CanvasLayer/Control/SettingsPanel/VBoxContainer/DialogVolume/Label.text = $"/root/Translate".get_translation("DialogVolSet")
		$CanvasLayer/Control/SettingsPanel/VBoxContainer/Language/Label.text = $"/root/Translate".get_translation("LangSet")
		$CanvasLayer/Control/SettingsPanel/VBoxContainer/Fullscreen/Label.text = $"/root/Translate".get_translation("FullscreenSet")
		$CanvasLayer/Control/ControlInfo/Label.text = $"/root/Translate".get_translation("ControlInfo")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SettingsButton_pressed():
	if !$CanvasLayer/fade/AnimationPlayer.is_playing():
		if $CanvasLayer/Control/ControlInfo.visible:
			$CanvasLayer/Control/ControlInfo.hide()
		$CanvasLayer/Control/SettingsPanel.visible = !$CanvasLayer/Control/SettingsPanel.visible


func _on_ControlInfoButton_pressed():
	if !$CanvasLayer/fade/AnimationPlayer.is_playing():
		if $CanvasLayer/Control/SettingsPanel.visible:
			$CanvasLayer/Control/SettingsPanel.hide()
		$CanvasLayer/Control/ControlInfo.visible = !$CanvasLayer/Control/ControlInfo.visible


func _on_MusicVolume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	$"/root/Settings".setting["music_volume"] = value
	$"/root/Settings".save()


func _on_CheckButton_toggled(button_pressed):
	OS.set_window_fullscreen(button_pressed)
	$"/root/Settings".setting["fullscreen"] = button_pressed
	$"/root/Settings".save()


func _on_ExitButton_pressed():
	if !$CanvasLayer/fade/AnimationPlayer.is_playing():
		get_tree().quit()
		$"/root/Settings".save()



func _on_SoundVolume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), value)
	$"/root/Settings".setting["sound_volume"] = value
	$"/root/Settings".save()


func _on_DialogVolume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dialogs"), value)
	$"/root/Settings".setting["dialog_volume"] = value
	$"/root/Settings".save()


func _on_PlayButton_pressed():
	$CanvasLayer/fade/AnimationPlayer.play("start")
	yield($CanvasLayer/fade/AnimationPlayer, "animation_finished")
	$"/root/UI".next_layout = "res://Scene/Level1.tscn"
	get_tree().change_scene("res://Scene/logo_screen.tscn")


func _on_ContinueButton_pressed():
	$CanvasLayer/fade/AnimationPlayer.play("start")
	yield($CanvasLayer/fade/AnimationPlayer, "animation_finished")
	$"/root/UI".next_layout = "res://Scene/Level"+ str($"/root/Saves".lvl) +".tscn"
	get_tree().change_scene("res://Scene/logo_screen.tscn")


func _on_TitlesButton_pressed():
	$CanvasLayer/fade/AnimationPlayer.play("start")
	yield($CanvasLayer/fade/AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://Scene/titles.tscn")


func _on_OptionButton_item_selected(index):
	match index:
		0:
			$"/root/Translate".lang = "ru"
		1:
			$"/root/Translate".lang = "en"
	$"/root/Settings".setting["lang"] = index
	$"/root/Settings".save()
	translateStrings()
