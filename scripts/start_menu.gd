extends CenterContainer


@onready var start_button: Button = %StartButton


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	start_button.grab_focus()


func _on_start_button_pressed() -> void:
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
	await LevelTransition.fade_from_black()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
