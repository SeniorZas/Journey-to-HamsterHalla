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
@onready var interactableTV = false
@onready var tv_explosion = $"res://Scenes/TV and rack/TV/Tv/explosión"
@onready var walkingSound = $SexArea/Walk
@onready var jumpSound = $SexArea/Jump
@onready var explosionSound = $SexArea/Explosion

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
	explosionSound.play()
	playermodel.visible=false
	isdead=true
	SPEED = 0
	explosion.visible = true
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/GameOverScreen.tscn")
	#get_tree().quit()
	pass

func _physics_process(delta):
	# Respawn
	#if Input.is_key_pressed(KEY_ENTER):
	#	get_tree().reload_current_scene()	
	
	if not is_on_floor():
		JUMP_VELOCITY=4.5
		velocity.y -= gravity * delta * 1.1
		if isRotated:
			playermodel.rotate_x(- deg_to_rad(85))
			isRotated=false
	# Death falling velocity condition
	if velocity.y <= lethal_velocity:
		death_impact = true

	if death_impact and velocity.y == 0:
		death_impact = false
		is_dead()

	if Input.is_action_pressed("ui_accept") and raycast2.is_colliding() and raycast1.is_colliding():
		velocity.y = 3
		if !isRotated:
			playermodel.rotate_x(deg_to_rad(85))
			hitbox.rotate_x(deg_to_rad(85))
			isRotated=true
	elif raycast2.is_colliding() and !raycast3.is_colliding() and !raycast1.is_colliding():
		if isRotated:
			playermodel.rotate_x(- deg_to_rad(85))
			hitbox.rotate_x(- deg_to_rad(85))
			SPEED=5
			isRotated=false
		JUMP_VELOCITY=4.5
		velocity.y = 2

	if interactableTV == true:
		if Input.is_action_just_pressed("Interact"):
			Global.pressedButton = true
	
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
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and playermodel.visible == true:
		jumpSound.play()
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
	if !input_dir:
		walkingSound.play()
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
	
func _on_sex_area_area_entered(area):
	$Label3D.text = "Press [E] to turn on TV"
	interactableTV = true

func _on_sex_area_area_exited(area):
	$Label3D.text = ""
	interactableTV = false

		

