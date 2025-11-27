extends CharacterBody3D

const base_speed = 3.5
var going_left : bool = true
var affected_by_gravity : bool = false
var mode : String = ""
@onready var body: ShapeCast3D = $ShapeCast3D
@onready var target = get_parent().get_node("Ball")

func _physics_process(delta: float) -> void:
	#Define movement type
	mode = "FOLLOW"
	
	if mode == "BOUNCE":
		if body.is_colliding():
			if going_left:
				going_left = false
			else:
				going_left = true
		
		if going_left:
			velocity.x = 1 * base_speed
		else:
			velocity.x = -1 * base_speed
	elif mode == "FOLLOW":
		if target:
			 # Calculate the new position using lerp for x axis only
			var target_position = target.global_position
			var current_position = global_position
			# Interpolate X position
			current_position.x = lerp(current_position.x, target_position.x, base_speed * delta)
			global_position = current_position
	
	move_and_slide()
