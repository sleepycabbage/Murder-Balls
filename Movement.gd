extends RigidBody3D

@export var cameraHolder : Node3D

@onready var groundDetector = $GroundDetector

const movementSpeed=30

const ACCELERATION=40

const airMovementSpeed=30

const maxCoyoteTime=10

const angularMovementMultiplier=10

const TURNAROUNDMULTIPLIER=10

const jumpForce=10

var coyoteTime=0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	groundDetector.global_rotation=Vector3.ZERO
	var onGround=groundDetector.is_colliding()
	coyoteTime-=delta*60
	if onGround:
		coyoteTime=maxCoyoteTime
	if coyoteTime>0:
		if Input.is_action_just_pressed("Jump"):
			linear_velocity.y=jumpForce
			coyoteTime=0
	cameraHolder.position=position
	
	var inputDirection=Input.get_vector("Left","Right","Forward","Backward")
	var direction = (cameraHolder.transform.basis * Vector3(inputDirection.x,0,inputDirection.y)).normalized()
	
	if direction:
		angular_velocity.z+=-direction.x*delta*ACCELERATION
		# quick turns
		if(-sign(direction.x)!=sign(angular_velocity.z)):
			angular_velocity.z=sign(-direction.x)*abs(angular_velocity.z)*TURNAROUNDMULTIPLIER
		angular_velocity.x+=direction.z*delta*ACCELERATION
		# quick turns
		if(sign(direction.z)!=sign(angular_velocity.x)):
			angular_velocity.x=sign(direction.z)*abs(angular_velocity.x)*TURNAROUNDMULTIPLIER
		angular_velocity.z=clamp(angular_velocity.z,-movementSpeed,movementSpeed)
		angular_velocity.x=clamp(angular_velocity.x,-movementSpeed,movementSpeed)
	
	
	groundDetector.global_rotation=Vector3.ZERO
	pass
