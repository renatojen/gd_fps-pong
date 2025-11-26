# ProtoController v1.0 by Brackeys
# CC0 License
# Intended for rapid prototyping of first-person games.
# Happy prototyping!

extends CharacterBody3D

## Can we move around?
@export var can_move : bool = true
## Are we affected by gravity?
@export var has_gravity : bool = true

@export_group("Speeds")
## Look around rotation speed.
@export var look_speed : float = 0.002
## Normal speed.
@export var base_speed : float = 5.0

@export_group("Input Actions")
## Name of Input Action to move Left.
@export var input_left : String = "move_left"
## Name of Input Action to move Right.
@export var input_right : String = "move_right"
## Name of Input Action to move Up.
@export var input_forward : String = "move_forward"
## Name of Input Action to move down.
@export var input_back : String = "move_back"

var mouse_captured : bool = false
var look_rotation : Vector2
var move_speed : float = 0.0

## IMPORTANT REFERENCES
@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $Collider
@onready var crouch_shapecast: ShapeCast3D = $ShapeCast3D
@onready var mesh: MeshInstance3D = $Mesh

func _ready() -> void:
	check_input_mappings()
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x

func _unhandled_input(event: InputEvent) -> void:
	# Mouse capturing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()
	
	# Look around
	#if mouse_captured and event is InputEventMouseMotion:
		#rotate_look(event.relative)
	
	# Toggle crouch mode
	#if can_crouch and Input.is_action_just_pressed(input_crouch):
		#if not crouching:
			#crouching = true
		#else:
			#crouching = false

func _physics_process(delta: float) -> void:
	# If freeflying, handle freefly and nothing else
	
	# Apply gravity to velocity
	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	else:
		move_speed = base_speed
		

				
		
	#elif can_sprint and Input.is_action_pressed(input_sprint) and not Input.is_action_just_pressed(input_sprint) and not Input.is_action_pressed(input_crouch):
		#move_speed = sprint_speed
	#elif can_crouch and Input.is_action_pressed(input_crouch) and is_on_floor() and not Input.is_action_pressed(input_sprint):
		#move_speed = crouch_speed
	# Apply desired movement to velocity
	if can_move:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if move_dir:
			velocity.x = move_dir.x * move_speed
			#velocity.z = move_dir.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			#velocity.z = move_toward(velocity.z, 0, move_speed)
	else:
		velocity.x = 0
		velocity.y = 0
	
	# Use velocity to actually move
	move_and_slide()

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true


func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false


## Checks if some Input Actions haven't been created.
## Disables functionality accordingly.
func check_input_mappings():
	if can_move and not InputMap.has_action(input_left):
		push_error("Movement disabled. No InputAction found for input_left: " + input_left)
		can_move = false
	if can_move and not InputMap.has_action(input_right):
		push_error("Movement disabled. No InputAction found for input_right: " + input_right)
		can_move = false
