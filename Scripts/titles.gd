extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if !$"/root/End/EndMusicPlayer".playing:
		$MusicPlayer.play()
	var f = File.new()
	f.open("res://langs/credits_"+ $"/root/Translate".lang + ".txt", File.READ)
	var err = $RichTextLabel.append_bbcode(f.get_as_text())
	f.close()
	if err == OK:
		print($RichTextLabel.rect_size.y)
		$RichTextLabel/Tween.interpolate_property($RichTextLabel, "rect_position:y", $RichTextLabel.rect_position.y, 0 - $RichTextLabel.rect_size.y, 64)
		$RichTextLabel/Tween.start()
		print($RichTextLabel.rect_size.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Tween_tween_all_completed():
	$"/root/UI".next_layout = "res://Scene/Menu.tscn"
	get_tree().change_scene("res://Scene/logo_screen.tscn")
