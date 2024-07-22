class_name Idle extends State

@export var move_state: State
@export var jump_state: State
@export var fall_state: State

func enter() -> void:
	super()
	parent.velocity.x = 0

func exit() -> void:
	super()

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()

	if not parent.is_on_floor():
		return fall_state

	if parent.jump_buffer_active and parent.is_on_floor():
		return jump()
	
	return null

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("pause"):
		level_manager.on_pause_pressed()

	if parent.can_transform:
		if Input.is_action_just_pressed("transform_element"):
			parent.transform()
	
	if Input.is_action_just_pressed("transform_base"):
		parent.can_transform_to = "BASE"
		parent.transform()

	if Input.is_action_just_pressed("jump") and (parent.is_on_floor() or parent.can_jump):
		return jump_state
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		return move_state
	
	return null

func jump() -> State:
	parent.clear_jump_buffer()
	return jump_state
