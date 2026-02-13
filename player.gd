extends CharacterBody2D


@export var movement_data: PlayerMovementData

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()

	var input_axis := Input.get_axis("ui_left", "ui_right")
	handle_acceleration(input_axis, delta)
	handle_deceleration(input_axis, delta)
	apply_air_resistance(input_axis, delta)

	update_animations(input_axis)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()
	if Input.is_action_just_pressed("ui_up"):
		movement_data = load("res://faster_movement_data.tres")


func apply_gravity(delta: float) -> void:
	"""Add the gravity."""
	if not is_on_floor():
		velocity += get_gravity() * movement_data.gravity_scale * delta


func handle_jump() -> void:
	"""Handle jump."""
	# classic jump impl, maybe we can have a jump interface with different styles and then just inject/mix in the one we want to use?
   	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = movement_data.jump_velocity

	if not is_on_floor():
		# This is breaking my brain a bit, why is releasing the button impacting the height of the jump like a tap vs hold for height
		# with the right side of the `and` statement, this actually acts as a secondary jump mid-air which was kinda cool IMO, sort of a last gasp anti-physics maneuver
		if Input.is_action_just_released("jump") and velocity.y < movement_data.jump_velocity / 2:
			velocity.y = movement_data.jump_velocity / 2

func handle_acceleration(input_axis: float, delta: float):
	"""Handle directional movement."""
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)

func handle_deceleration(input_axis: float, delta: float):
	"""Apply friction to stop movement."""
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func update_animations(input_axis: float):
	if input_axis != 0:
		animated_sprite_2d.play("run")
		animated_sprite_2d.flip_h = input_axis < 0
	else:
		animated_sprite_2d.play("idle")
		
	if not is_on_floor():
		animated_sprite_2d.play("jump")
		
func apply_air_resistance(input_axis: float, delta: float):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)
