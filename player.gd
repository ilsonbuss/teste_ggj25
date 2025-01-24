extends RigidBody3D

# Movement variables
@export var move_speed: float = 10.0
@export var jump_force: float = 15.0
@export var air_control: float = 0.3
@export var max_slope_angle: float = 45.0
@export var force_position: Node3D

# Internal state
var velocity: Vector3
var is_on_floor: bool = false

# Inputs
var input_direction: Vector3
var camera: Camera3D

func _ready():
	camera = %Camera3D
	#apply_impulse(Vector3.ZERO, Vector3(0, 0, -10))
	pass

func _physics_process(delta: float) -> void:
	# Update floor detection
	is_on_floor = on_floor
	
	# Handle movement and input
	handle_input(delta)

	# Apply forces
	if input_direction != Vector3.ZERO:
		apply_movement_force(delta)

	# Apply gravity (handled automatically by RigidBody3D)

func handle_input(delta: float) -> void:
	input_direction = Vector3.ZERO

	# Collect input for movement
	if Input.is_action_pressed("move_forward"):
		input_direction.z -= 1
	if Input.is_action_pressed("move_backward"):
		input_direction.z += 1
	if Input.is_action_pressed("move_left"):
		input_direction.x -= 1
	if Input.is_action_pressed("move_right"):
		input_direction.x += 1

	# Normalize the input direction to avoid diagonal speed boost
	input_direction = input_direction.normalized()

	# Jump
	if is_on_floor and Input.is_action_just_pressed("jump"):
		apply_central_force(Vector3.UP * jump_force)

func apply_movement_force(delta: float) -> void:
	# Get the desired movement direction in global space
	var direction: Vector3 = Vector3.ZERO
	if camera:
		var camera_basis: Basis = camera.global_transform.basis
		direction = (camera_basis.x * input_direction.x + camera_basis.z * input_direction.z).normalized()
	
	# Determine the movement factor (less control in the air)
	var control_factor: float = air_control if not is_on_floor else 1.0

	# Apply force for movement
	var movement_force: Vector3 = direction * move_speed * control_factor
	if force_position:
		apply_force(movement_force, force_position.position)
	else:
		apply_central_force(movement_force)

var on_floor = true
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	on_floor = false # reset on_floor for this physics frame

	var i := 0
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		var this_contact_on_floor = normal.dot(Vector3.UP) > 0.99
		#print(normal.dot(Vector3.UP))

		# boolean math, will stay true if any one contact is on floor
		on_floor = on_floor or this_contact_on_floor
		i += 1
	#print(on_floor)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == self:
		%Bolhas.show()
