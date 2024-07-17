class_name EarthPlatform extends StaticBody2D

func _ready() -> void:
	$DetectionArea.connect("body_entered", _on_detection_area_entered)

func _on_detection_area_entered(body: Node2D) -> void:
	if body is Player:
		if body.current_transform_state == body.Transform_State.EARTH:
			$PlatformBody.set_deferred("disabled", false)
		else:
			$PlatformBody.set_deferred("disabled", true)
			print("Player is not earth transformed")