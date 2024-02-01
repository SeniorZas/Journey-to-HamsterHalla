extends Node3D

@onready var cam_col = $RayCast3D
@onready var camera = $Camera3D

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cam_col.is_colliding():
		camera.global_transform.origin=lerp(camera.global_transform.origin, cam_col.get_collision_point(),0.1)
	else:
		camera.global_transform.origin = $Node3D.global_transform.origin
