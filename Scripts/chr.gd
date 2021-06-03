extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int, "No", "Random", "Player", "Other") var character
export(int, "No", "GhostlyGirl", "AHOHuMyC", "5opka", "WheatleyHDD") var chr_name

var acces = [
	"acces/maska_anon",
	"acces/shapka228",
	"acces/usi",
	"acces/ushi",
	"acces/dedinside",
	"acces/troll",
	"no",
	"no",
	"no",
	"no",
	"no",
]


# Called when the node enters the scene tree for the first time.
func _ready():
	match character:
		1:
			# Random
			randomize()
			var head_b = rand_range(75, 200)
			var head_g = head_b * 1.1428
			var head_r = head_g * 1.125
			$head.modulate = Color(head_r/255, head_g/255, head_b/255)
			
			var body_b = rand_range(0, 255)
			var body_g = rand_range(0, 255)
			var body_r = rand_range(0, 255)
			$body.modulate = Color(body_r/255, body_g/255, body_b/255)
			
			var choose_acces = randi() % len(acces)
			if acces[choose_acces] != "no":
				get_node(acces[choose_acces]).visible = true
			
		2:
			# Player
			$head.modulate = Color(225/255.0, 200/255.0, 175/255.0)
			$body.modulate = Color(35/255.0, 35/255.0, 35/255.0)
		3:
			match chr_name:
				1:
					# GhostlyGirl
					$head.modulate = Color("EFCAC1")
					$body.modulate = Color("EFC1B4")
					$ghostlygirl.visible = true
				2:
					# AHOHuMyC
					$head.modulate = Color(225/255.0, 200/255.0, 175/255.0)
					$body.modulate = Color("00071a")
					$acces/maska_anon.visible = true
				3:
					# 5opka
					$head.modulate = Color("ffdbbe")
					$body.modulate = Color("191919")
					$body.scale.x = 1.3
					$glay.visible = true
				4:
					# WheatleyHDD
					$head.modulate = Color("e6cfb9")
					$body.modulate = Color("0c0c20")

func setState(state):
	match state:
		"":
			$AnimationPlayer.play("idle")
		"idle":
			$AnimationPlayer.play("idle")
		"walk":
			$AnimationPlayer.play("walk")

func setAnimationSpeed(speed):
	$AnimationPlayer.playback_speed = speed/420

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
