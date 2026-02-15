extends Node2D

@export var level_completed: ColorRect

@export var next_level: PackedScene

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.level_completed.connect(show_level_completed)


func show_level_completed():
	level_completed.show()
	get_tree().paused = true
	if not next_level is PackedScene: return
	await LevelTransition.fade_to_black()
	# I thought it would make more sense to wait and unpause after the level transition completed,
	# but that doesn't seem to work... or i just need to mess with it a bit more
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)
	# heartbeast says you don't have to await this one
	await LevelTransition.fade_from_black()
