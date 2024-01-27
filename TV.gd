extends StaticBody3D
@onready var explosión = $Tv/explosión
@onready var raycast = $RayCast3D


# Called when the node enters the scene tree for the first time.
func _ready():
	explosión.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if raycast.is_colliding()==true:
		explosión.visible = true
		
		
	pass
