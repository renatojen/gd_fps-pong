extends CharacterBody3D

const base_speed : float = 2.0
var rng = RandomNumberGenerator.new()
var affected_by_gravity : bool = false
var prev_speed : float = 0.0
var z : int = 0
var cur_obj : String = ""
var player_score : int = 0
var opponent_score : int = 0
@onready var body: ShapeCast3D = $ShapeCast3D

func _ready() -> void:
	if rng.randi_range(0,1):
		z = 1.0
	else:
		z = -1.0
	velocity.z = z * base_speed

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if affected_by_gravity and not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if body.is_colliding():
		cur_obj = body.get_collider(0).get("name")
		if cur_obj == "OpponentGoal":
			player_score += 1
			
		elif cur_obj == "PlayerGoal":
			opponent_score += 1
			pass
		elif cur_obj == "Player" or cur_obj == "Opponent":
			prev_speed = velocity.z
			velocity.z = 0
			velocity.z = -1 * prev_speed 
		
		#velocity.z = -1 * base_speed
		#velocity.x = move_toward(velocity.x, 0, base_speed)
		#velocity.z = move_toward(velocity.z, 0, base_speed)

	move_and_slide()
