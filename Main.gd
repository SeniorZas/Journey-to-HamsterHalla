extends Node3D

@onready var personaje = $CharacterBody3D/MeshInstance3D
@onready var personaje2 = CharacterBody3D
@onready var explosion_personaje = $CharacterBody3D/EXPLOSION
@onready var TV = $TV
@onready var tv_explosion = $"TV/Tv/explosión"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tv_explosion.visible == true:
		$CharacterBody3D.is_dead()
		
	pass
