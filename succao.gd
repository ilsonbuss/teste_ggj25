extends Area3D

@export var suction_force: float = 10.0  # Intensidade da sucção
@export var suction_point: Node3D  # Ponto de onde a força de sucção origina

func _process(delta):
	for body in get_overlapping_bodies():
		if body is RigidBody3D and body.get_parent().name == "Bubbles":
			# Calcula a direção da sucção
			var direction = ((suction_point.global_position if suction_point else global_transform.origin) - body.global_transform.origin).normalized()
			# Aplica uma força no objeto em direção ao ponto de sucção
			body.apply_force(direction * suction_force, Vector3.ZERO)
