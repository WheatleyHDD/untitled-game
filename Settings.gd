extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var setting: Dictionary = {
	"music_volume": -6.6,
	"sound_volume": -13.5,
	"dialog_volume": -5.0,
	"fullscreen": true,
	"lang": -1,
	"frun": true,
}
signal settingLoaded


# Called when the node enters the scene tree for the first time.
func _ready():
	loadAll()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), setting["music_volume"])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), setting["sound_volume"])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dialogs"), setting["dialog_volume"])
	OS.set_window_fullscreen(setting["fullscreen"])
	if setting.has("lang"):
		if setting["lang"] != -1:
			match setting["lang"]:
				0:
					$"/root/Translate".lang = "ru"
				1:
					$"/root/Translate".lang = "en"
	if !setting.has("frun"):
		setting["frun"] = false
	emit_signal("settingLoaded")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func save():
	var f = File.new()
	f.open("user://settings.save", File.WRITE)
	f.store_var(setting, true)
	f.close()

func loadAll():
	var f = File.new()
	var err = f.open("user://settings.save", File.READ)
	if err == OK:
		setting = f.get_var(true)
		f.close()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save()
		get_tree().quit() # default behavior
