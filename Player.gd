extends CharacterBody3D

const sense=.1
var SPEED = 5.0
var JUMP_VELOCITY = 4.5
var twist_input := 0.0
var pitch_input := 0.0
var stamina=300
const raylength=10

@onready var body = $Hampter
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var text = $Head/Camera3D/Label3D 
@onready var raycast1 = $Head/Raycasts/Raycast1
@onready var raycast2 = $Head/Raycasts/Raycast2
@onready var raycast3 = $Head/Raycasts/Raycast3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#funcion de inicio
func _ready()->void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	text.text= str(stamina)
	pass
	
# Movimiento de camara
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
		rotate_y(deg_to_rad(-event.relative.x * sense))
		head.rotate_x(deg_to_rad(-event.relative.y * sense))
		
	pass


func _physics_process(delta):
	if not is_on_floor():
		JUMP_VELOCITY=4.5
		velocity.y -= gravity * delta

	if Input.is_action_pressed("ui_accept") and raycast2.is_colliding() and raycast1.is_colliding():
		velocity.y = 3
		body.rotate_object_local(Vector3(1,0,0), 0)
	elif raycast2.is_colliding() and !raycast3.is_colliding() and !raycast1.is_colliding():
		JUMP_VELOCITY=1
		velocity.y = 2
	
	# Capacidad de correr y stamina
	if Input.is_action_pressed("Run_up") && stamina>0:
		SPEED=15
		stamina-=1
		text.text = str(stamina)
		if stamina<=0:
			get_tree().quit()
	else:
		SPEED=5
		if stamina<300:
			stamina+=1
			text.text= str(stamina)
			
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	head.rotate_y(twist_input)
	head.rotate_x(pitch_input)
	head.rotation.x = clamp(head.rotation.x, -0.5, 0.5)
	twist_input = 0.0
	pitch_input = 0.0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
