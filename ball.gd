extends CharacterBody3D

const base_speed : float = 2.0
var rng = RandomNumberGenerator.new()
var affected_by_gravity : bool = false
var prev_speed : float = 0.0
var z : int = 0
var cur_obj : String = ""
var player_score : int = 0
var opponent_score : int = 0
var start_position : Vector3 = Vector3(0,0,0)
var first = false
@onready var bodym: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	start_position = position
	if rng.randi_range(0,1):
		z = 1
	else:
		z = -1
	velocity.z = z * base_speed
	first = true

func _physics_process(delta: float) -> void:
	if first:
		await get_tree().create_timer(1.0).timeout
		first = false
	var collision = move_and_collide(velocity * delta)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if collision:
		cur_obj = collision.get_collider().get("name")
		#cur_obj = bodyc.get_collider(0).get("name")
		if cur_obj == "OpponentGoal":
			velocity = Vector3.ZERO
			player_score += 1
			restart(-1)
		elif cur_obj == "PlayerGoal":
			velocity = Vector3.ZERO
			velocity.z = 0
			opponent_score += 1
			restart(1)
		elif cur_obj == "Player" or cur_obj == "Opponent":
			velocity = velocity.bounce(collision.get_normal())
			#velocity.z = -1.0 * velocity.z
			move_and_collide(Vector3(velocity.x, velocity.y, velocity.z))
		else:
			move_and_collide(velocity * delta)
	#else:
		#move_and_slide()
		#velocity.z = -1 * base_speed
		#velocity.x = move_toward(velocity.x, 0, base_speed)
		#velocity.z = move_toward(velocity.z, 0, base_speed)

	#move_and_collide(Vector3(velocity.x, velocity.y, velocity.z))
	
func restart(direction : int) -> void:
	#bodym.visible = false
	#if player_score > 2 or opponent_score > 2:
		#pass
	global_position = start_position
	await get_tree().create_timer(1.0).timeout
	#bodym.visible = true
	velocity.z = direction * base_speed
