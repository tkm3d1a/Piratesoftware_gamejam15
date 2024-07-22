class_name TransformArea extends Area2D

# @export var transform_shape: CollisionShape2D
@export var transform_area_type: String

signal player_can_transform(element: String)
signal player_cannot_transform

func _ready() -> void:
	if transform_area_type:
		transform_area_type = transform_area_type.to_upper()
	else:
		var err_msg: String = name + " does not have a transform area type set"
		printerr(err_msg)

	self.connect("body_entered", _on_area_entered)
	self.connect("body_exited", _on_area_exited)

func _on_area_entered(body: Node2D) -> void:
	if body is Player and transform_area_type:
		emit_signal("player_can_transform", transform_area_type)

func _on_area_exited(body: Node2D) -> void:
	if body is Player:
		print("Player exited transform area")
		# $ActivationArea.set_deferred("disabled", false)
		emit_signal("player_cannot_transform")