class_name Jump extends State

@export var move_state: State
@export var idle_state: State
@export var fall_state: State

func enter() -> void:
	super()
	parent.velocity.y = -parent.jump_velocity

func exit() -> void:
	super()

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta

	if parent.velocity.y > 0:
		return fall_state

	var movement: float = Input.get_axis("move_left", "move_right") * parent.speed

	if movement != 0:
		parent.sprite_node.flip_h = movement < 0
	
	parent.velocity.x = movement
	parent.move_and_slide()

	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state

	return null

func process_frame(_delta: float) -> State:
	return null

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("transform_earth") and parent.can_transform:
		parent.transform(parent.Transform_State.EARTH)
	
	if Input.is_action_just_pressed("transform_base"):
		parent.transform(parent.Transform_State.BASE)
	
	return null
