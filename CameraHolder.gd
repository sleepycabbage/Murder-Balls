extends Node3D

const SENSITIVITY = 0.01

const DEFAULTDISTANCE=3

var distance=DEFAULTDISTANCE

@onready var camera=$Camera

@onready var raycast=$Camera/cast

func _ready(): 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _unhandled_input(event):
	if(event is InputEventMouseMotion):
		rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40),deg_to_rad(60))

func _physics_process(delta):
	distance=DEFAULTDISTANCE
	raycast.target_position.z=-distance
	raycast.position.z=1
	if(raycast.is_colliding()):
		var point=raycast.get_collision_point()
		var distanceToCamera=position.distance_to(point)
		distance-=distanceToCamera
		print(raycast.position)
	camera.position.z=distance
	camera.position.y=-camera.rotation.x*distance
