extends Node3D
@onready var Player3D := $Player3D
@onready var Player2D := $Player2D
var visible_player2d := false
var visible_player3d := true
# Called when the node enters the scene tree for the first time.
func _ready():
	remove_child(Player2D)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Changing2D"):
		remove_child(Player3D)
		visible_player3d=false
		add_child(Player2D)
		visible_player2d = true
	if Input.is_action_just_pressed("Changing3D"):
		remove_child(Player2D)
		add_child(Player3D)

