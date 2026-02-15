extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	print("ready")
	if animation_player:
		print("animation player is ready")

func fade_from_black() -> void:
	animation_player.play("fade_from_black")
	await animation_player.animation_finished


func fade_to_black() -> void:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
