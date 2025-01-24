extends Node3D

func _ready() -> void:
	pass
	#Engine.time_scale = 1.0


@export var scale_speed: float = 0.05  # Velocidade de redução de escala
@export var min_scale: float = 0.0   # Escala mínima permitida

func _process(delta):
	var mesh_instance = %Cha
	# Verifica se ainda pode reduzir a escala
	if mesh_instance.scale.y > min_scale:
		# Reduz gradativamente a escala
		var scale_decrease = scale_speed * delta
		mesh_instance.scale -= Vector3(0.0, scale_decrease, 0.0)

		# Mantém o pivô na base corrigindo a posição
		#var height_offset = scale_decrease * mesh_instance.get_mesh().get_aabb().size.y / 2
		#mesh_instance.translate(Vector3(0, height_offset, 0))
