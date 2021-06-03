extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var x: float = 0
var y: float
export var offs: float = 8


# Called when the node enters the scene tree for the first time.
func _ready():
	$Platform.set_meta("mov_plat", "dat")
	y = $Platform.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	x += delta
	$Platform.position.y = sin(x) * offs + y
