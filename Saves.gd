extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lvl = 1
var passw = "untitled214514032021forsave"


# Called when the node enters the scene tree for the first time.
func _ready():
	loadAll()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func save():
	var f = File.new()
	f.open_encrypted_with_pass("user://save.dat", File.WRITE, passw)
	f.store_64(lvl)
	f.close()

func loadAll():
	var f = File.new()
	var err = f.open_encrypted_with_pass("user://save.dat", File.READ, passw)
	if err == OK:
		lvl = f.get_64()
		f.close()
