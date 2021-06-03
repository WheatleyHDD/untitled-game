extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shake_amount = 0.0
onready var player = get_node_or_null("../Player")
export var follow = true


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Camera2D.CAMERA2D_PROCESS_IDLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	randomize()
	set_offset(Vector2( \
		rand_range(-1.0, 1.0) * shake_amount, \
		rand_range(-1.0, 1.0) * shake_amount \
	))
	if player != null and follow:
		if player.position.x > position.x + 640:
			position.x = position.x + 1280
		elif player.position.x < position.x - 640:
			position.x = position.x - 1280
		
		if player.position.y > position.y + 360:
			position.y = position.y + 720
		elif player.position.y < position.y - 360:
			position.y = position.y - 720

func shake(amount: float, time: float):
	shake_amount = amount
	yield(get_tree().create_timer(time), "timeout")
	shake_amount = 0
