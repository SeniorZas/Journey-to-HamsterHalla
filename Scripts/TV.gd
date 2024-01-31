extends StaticBody3D

@onready var explosión = $"explosión"




# Called when the node enters the scene tree for the first time.
func _ready():
	explosión.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if  Global.pressedButton == true:
		explosión.visible = true

		
	pass
