class_name BaseLevel extends Node2D

@export var starting_point: Marker2D
@export var exit_area: Area2D
@export var transform_areas: Array[Node]
@export var death_zone: Area2D

var player: Player

func _ready() -> void:
	if death_zone == null:
		printerr("Deathzone not set up for ", self.name)
	transform_areas = get_tree().get_nodes_in_group("transform_area")
	if transform_areas.size() == 0:
		printerr("No transform areas set for this level")
	else:
		for transform_area: TransformArea in transform_areas:
			transform_area.connect("player_can_transform", _on_transform_area_entered)
			transform_area.connect("player_cannot_transform", _on_transform_area_exited)

	if death_zone:
		death_zone.body_entered.connect(_on_deathzone_entered)

func _on_deathzone_entered(_body: Node2D) -> void:
	print("enter death zone")
	player.global_position = starting_point.global_position

func _on_transform_area_entered(element: String) -> void:
	player.entered_transform_area(element)

func _on_transform_area_exited() -> void:
	player.exited_transform_area()
