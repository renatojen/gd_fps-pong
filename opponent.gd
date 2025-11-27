extends CharacterBody3D

const base_speed = 3.0
var going_left : bool = true
var affected_by_gravity : bool = false
@onready var body: ShapeCast3D = $ShapeCast3D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if affected_by_gravity and not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if body.is_colliding():
		if going_left:
			going_left = false
		else:
			going_left = true
	
	if going_left:
		velocity.x = 1 * base_speed
	else:
		velocity.x = -1 * base_speed
		#velocity.x = move_toward(velocity.x, 0, base_speed)
		#velocity.z = move_toward(velocity.z, 0, base_speed)

	move_and_slide()
