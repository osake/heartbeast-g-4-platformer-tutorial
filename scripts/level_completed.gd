extends ColorRect

signal retry()
signal next_level()

@onready var retry_button: Button = %RetryButton
@onready var next_level_button: Button = %NextLevelButton


func _ready() -> void:
	pass


func _on_retry_button_pressed() -> void:
	print("retry")
	retry.emit()
	


func _on_next_level_button_pressed() -> void:
	print("next")
	next_level.emit()
