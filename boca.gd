extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D and body.get_parent().name == "Bubbles":
		body.queue_free()
