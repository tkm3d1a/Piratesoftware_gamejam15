class_name TransformArea extends Area2D

# @export var transform_shape: CollisionShape2D

signal player_can_transform
signal player_cannot_transform

func _ready() -> void:
	self.connect("body_entered", _on_area_entered)
	self.connect("body_exited", _on_area_exited)

func _on_area_entered(body: Node2D) -> void:
	if body is Player:
		print("Player entered transform area")
		# $ActivationArea.set_deferred("disabled", true)
		emit_signal("player_can_transform")

func _on_area_exited(body: Node2D) -> void:
	if body is Player:
		print("Player exited transform area")
		# $ActivationArea.set_deferred("disabled", false)
		emit_signal("player_cannot_transform")