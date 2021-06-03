extends Node


signal initialised()


var core: Discord.Core
var users: Discord.UserManager
var images: Discord.ImageManager
var activities: Discord.ActivityManager
var relationships: Discord.RelationshipManager

var is_initialised: bool = false


func _ready() -> void:
#	pass
	call_deferred("create_core")


func _process(_delta: float) -> void:
	if core:
		var result: int = core.run_callbacks()
		if result != Discord.Result.OK:
			is_initialised = false
			print(
				"Failed to run callbacks: ",
				enum_to_string(Discord.Result, result)
			)
			destroy_core()


func _log_hook(level: int, message: String) -> void:
	print(
		"[DISCORD] ", enum_to_string(Discord.LogLevel, level),
		": ", message
	)


func create_core() -> void:
	destroy_core()
	core = Discord.Core.new()
	is_initialised = true
	var result: int = core.create(
		829655704108531733,
		Discord.CreateFlags.NO_REQUIRE_DISCORD
	)

	if result != Discord.Result.OK:
		is_initialised = false
		print(
			"Failed to initialise Discord Core: ",
			enum_to_string(Discord.Result, result)
		)
		destroy_core()
		return

	core.set_log_hook(Discord.LogLevel.DEBUG, self, "_log_hook")

	users = core.get_user_manager()
	images = core.get_image_manager()
	activities = core.get_activity_manager()
	relationships = core.get_relationship_manager()

	emit_signal("initialised")


func destroy_core() -> void:
	is_initialised = false
	core = null
	users = null
	images = null
	activities = null
	relationships = null

func send_activity(state, details: String) -> void:
	if OS.get_name() != "Android" and is_initialised:
		var activity: = Discord.Activity.new()
		activity.state = state
		activity.details = details
		var assets: = Discord.ActivityAssets.new()
		assets.large_image = "main"
		assets.large_text = state
		activity.assets = assets
		activities.update_activity(activity)

func enum_to_string(the_enum: Dictionary, value: int) -> String:
	var index: = the_enum.values().find(value)
	var string: String = the_enum.keys()[index]
	return string
