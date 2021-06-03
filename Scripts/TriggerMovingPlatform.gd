extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var start = Vector2()
export var end = Vector2()
export var offs: int = 8
export var time: int = 3
export var saved = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Platform.set_meta("mov_plat", "dat")
	start = $Platform.position
	if !saved:
		end.x = end.x + 96
		end.y = end.y + 16
		saved = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func activated():
	$Platform/Tween.interpolate_property($Platform, "position", $Platform.position, to_local(end), time)
	$Platform/Tween.start()

func deactivated():
	$Platform/Tween.interpolate_property($Platform, "position", $Platform.position, start, time)
	$Platform/Tween.start()
