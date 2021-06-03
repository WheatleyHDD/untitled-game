tool
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hl_pref = preload("res://Prefabs/editor/HorizontalLine.tscn")
var vl_pref = preload("res://Prefabs/editor/VerticalLine.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		for x in range(0, 20):
			var vl = vl_pref.instance()
			vl.position.x = 1280 * x
			vl.width = 2
			add_child(vl)
		for y in range(0, 20):
			var hl = hl_pref.instance()
			hl.position.y = 720 * y
			hl.width = 2
			add_child(hl)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	pass
