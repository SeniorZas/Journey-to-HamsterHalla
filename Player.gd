extends RigidBody3D

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0
const JUMP_POWER = 45
var jump_num = 0
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var ray := $RayCast3D
@onready var ray2 := $RayCast3D2
@onready var ray3 := $RayCast3D3
@onready var camera := get_node("TwistPivot/PitchPivot/Camera3D")



# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input := Vector3.ZERO
	var jump_vector:= Vector3.UP
	var diagonal_vector := Vector3.UP + Vector3.LEFT
	var diagonal_vector2 := Vector3.UP + Vector3.RIGHT
	input.x = Input.get_axis("move_left","move_right")
	input.z = Input.get_axis("move_forward", "move_backward")
	apply_central_force(twist_pivot.basis * input * 1200.0 * delta)
	
	if ray.is_colliding():
		jump_num =1
	
	if Input.is_action_just_pressed("jump") and jump_num > 0:
		apply_central_force(jump_vector*JUMP_POWER*10)
		jump_num -=1
	
	if Input.is_action_just_pressed("jump") and ray2.is_colliding() and not ray.is_colliding():
		apply_central_force(diagonal_vector*JUMP_POWER*6)
	if Input.is_action_just_pressed("jump") and ray3.is_colliding() and not ray.is_colliding():
		apply_central_force(diagonal_vector2*JUMP_POWER*6)
		
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	twist_pivot.rotate_y(twist_input)
	pitch_pivot	.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp( pitch_pivot.rotation.x, -0.5, 0.5)
	twist_input = 0.0
	pitch_input = 0.0



	


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
			

	
	
