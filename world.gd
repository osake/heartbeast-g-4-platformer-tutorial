extends Node2D

@export var level_completed: ColorRect
@export var next_level: PackedScene

var level_time = 0.0
var start_level_msec = 0.0

@onready var start_in: ColorRect = %StartIn
@onready var start_in_label: Label = %StartInLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var level_time_label: Label = %LevelTimeLabel


func _ready() -> void:
	if not next_level is PackedScene:
		level_completed.next_level_button.text = "Victory Screen"
		next_level = load("res://scenes/victory_screen.tscn")

	Events.level_completed.connect(show_level_completed)
	get_tree().paused = true
	await LevelTransition.fade_from_black()
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	start_level_msec = Time.get_ticks_msec()


func _process(delat: float) -> void:
	#print(Time.get_ticks_msec() - start_level_msec)
	level_time = Time.get_ticks_msec() - start_level_msec
	level_time_label.text = "Time: " + str(level_time / 1000.0)


func go_to_next_level() -> void:
	if not next_level is PackedScene: return
	await LevelTransition.fade_to_black()
	# I thought it would make more sense to wait and unpause after the level transition completed,
	# but that doesn't seem to work... or i just need to mess with it a bit more
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)

func show_level_completed() -> void:
	level_completed.show()
	level_completed.retry_button.grab_focus()
	get_tree().paused = true
	#await get_tree().create_timer(1.0).timeout
	# heartbeast says you don't have to await this one, but I kinda feel like it might be best practice to await
	#await LevelTransition.fade_from_black()
	#go_to_next_level()


func _on_level_completed_next_level() -> void:
	go_to_next_level()

func retry() -> void:
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_file_path)


func _on_level_completed_retry() -> void:
	retry()
