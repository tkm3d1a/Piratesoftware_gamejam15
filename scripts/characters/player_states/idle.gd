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
	
	return null
	
func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		return move_state

	if Input.is_action_just_pressed("transform_earth") and parent.can_transform:
		parent.transform(parent.Transform_State.EARTH)
	
	if Input.is_action_just_pressed("transform_base"):
		parent.transform(parent.Transform_State.BASE)
	
	return null
