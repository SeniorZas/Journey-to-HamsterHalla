extends CharacterBody3D

var counter= 0
var isRotated = false
var isdead = false
const sense=.1
var SPEED = 5.0
var JUMP_VELOCITY = 4.5
var twist_input := 0.0
var pitch_input := 0.0
var stamina=300
var lethal_velocity = -10
var death_impact = false
const raylength=10

#@onready const hampter_anim = $"hampter (1)/AnimationPlayer"
@onready var playermodel = $hampter
@onready var hitbox = $CollisionShape3D
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var text = $Head/Camera3D/Label3D 
@onready var raycast1 = $Raycasts/Raycast1
@onready var raycast2 = $Raycasts/Raycast2
@onready var raycast3 = $Raycasts/Raycast3
@onready var explosion = $EXPLOSION
@onready var anim = $hampter/AnimationTree
@onready var staminaBar = $StaminaBar
@onready var staminaBar2 = $StaminaBar2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


#funcion de inicio
func _ready()->void:
	explosion.visible=false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	staminaBar.value = stamina
	#text.text= str(stamina)
	pass
	
# Movimiento de camara
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
		rotate_y(deg_to_rad(-event.relative.x * sense))
		head.rotate_x(deg_to_rad(-event.relative.y * sense))
		
	pass
	
func is_dead():
	playermodel.visible=false
	isdead=true
	SPEED = 0
	explosion.visible = true
	await get_tree().create_timer(2).timeout 
	get_tree().quit()
	pass

func _physics_process(delta):
	if not is_on_floor():
		JUMP_VELOCITY=4.5
		velocity.y -= gravity * delta * 1.1
		if isRotated:
			playermodel.rotate_x(- deg_to_rad(85))
			isRotated=false
		print(velocity.y) 
	# Death falling velocity condition
	if velocity.y <= lethal_velocity:
		death_impact = true

	if death_impact and velocity.y == 0:
		is_dead()

	if Input.is_action_pressed("ui_accept") and raycast2.is_colliding() and raycast1.is_colliding():
		velocity.y = 3
		if !isRotated:
			playermodel.rotate_x(deg_to_rad(85))
			hitbox.rotate_x(deg_to_rad(85))
			SPEED=0
			isRotated=true
	elif raycast2.is_colliding() and !raycast3.is_colliding() and !raycast1.is_colliding():
		if isRotated:
			playermodel.rotate_x(- deg_to_rad(85))
			hitbox.rotate_x(- deg_to_rad(85))
			SPEED=5
			isRotated=false
		JUMP_VELOCITY=1
		velocity.y = 2
		velocity.z = 10
	
	
	# Capacidad de correr y stamina
	if Input.is_action_pressed("Run_up") && Input.is_action_pressed("move_forward") && stamina>-100 && !isdead:
		if isRotated:
			SPEED=0
		else:
			SPEED=12
		stamina-=1
		#text.text = str(stamina)
		if stamina<=-100:
			is_dead()
	else:
	
		if stamina<300 && playermodel.visible == true:
			if isRotated:
				SPEED=0
			else:
				SPEED=5
			SPEED=5
			stamina+=1
			#text.text= str(stamina)
		
	staminaBar.value = stamina
	staminaBar2.value = stamina
	if staminaBar.value <= 0:
		staminaBar.hide()
		staminaBar2.show()
	if staminaBar.value > 0:
		staminaBar2.hide()
		staminaBar.show()
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
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	anim.set("parameters/conditions/idle", input_dir==Vector2.ZERO and is_on_floor())
	anim.set("parameters/conditions/run", (input_dir!=Vector2.ZERO and is_on_floor()) or raycast1.is_colliding())
	anim.set("parameters/conditions/jump", !is_on_floor() && !raycast1.is_colliding())
	
	move_and_slide()
	

		

