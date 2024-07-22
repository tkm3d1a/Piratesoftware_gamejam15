extends Node2D

@export var transform_areas: Array[TransformArea]

var player: Player

func _ready() -> void:
    player = get_tree().get_first_node_in_group("player")
    if player == null:
        printerr("bad player connection")

    if transform_areas.size() == 0:
        printerr("No transform areas set for this level")
    else:
        for transform_area: TransformArea in transform_areas:
            transform_area.connect("player_can_transform", _on_transform_area_entered)
            transform_area.connect("player_cannot_transform", _on_transform_area_exited)

    $DeathZone.connect("body_entered", _on_deathzone_entered)

func _on_transform_area_entered(element: String) -> void:
    player.entered_transform_area(element)

func _on_transform_area_exited() -> void:
    player.exited_transform_area()

func _on_deathzone_entered(_body: Node2D) -> void:
    get_tree().call_deferred("reload_current_scene")