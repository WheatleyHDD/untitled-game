extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var d = Directory.new()
	d.make_dir("user://save_slots")
	$"/root/DiscordManager".connect("initialised", self, "_on_discord_initialised")
	$CanvasLayer/Control/WarningText.text = $"/root/Translate".get_translation("Warn")
	$CanvasLayer/Control/SubmitButton.text = $"/root/Translate".get_translation("WarnSubmitButton")
#	$CanvasLayer/Control/ExitButton.text = $"/root/Translate".get_translation("WarnExitButton")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_discord_initialised():
	$"/root/DiscordManager".send_activity("In Menu", "Idle")

func _on_SubmitButton_pressed():
	get_tree().change_scene("res://Scene/Splash.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()
