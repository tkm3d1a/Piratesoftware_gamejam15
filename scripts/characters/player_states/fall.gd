class_name Fall extends State

@export var move_state: State
@export var idle_state: State

func enter() -> void:
	super()
	parent.can_jump = false

func exit() -> void:
	super()
	parent.can_jump = true

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
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
	if parent.can_transform:
		if Input.is_action_just_pressed("transform_element"):
			parent.transform()
	
	if Input.is_action_just_pressed("transform_base"):
		parent.can_transform_to = "BASE"
		parent.transform()

	if Input.is_action_just_pressed("jump"):
		if not parent.jump_buffer_active:
			parent.start_jump_buffer()

	return null
