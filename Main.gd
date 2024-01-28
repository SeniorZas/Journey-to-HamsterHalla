extends Node3D

@onready var personaje = $CharacterBody3D/MeshInstance3D
@onready var personaje2 = $CharacterBody3D
@onready var explosion_personaje = $CharacterBody3D/EXPLOSION
@onready var TV = $TV
@onready var tv_explosion = $"TV and rack/TV/Tv/explosión"
@onready var pause_menu = $PauseMenu
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tv_explosion.visible == true:
		$CharacterBody3D.is_dead()
	if Input.is_action_just_pressed("pause") :
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pauseMenu()

func pauseMenu():
	if paused:
		get_tree().paused = false
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		get_tree().paused = true
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused
