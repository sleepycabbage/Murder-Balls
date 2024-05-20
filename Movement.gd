extends RigidBody3D

@export var cameraHolder : Node3D

@export var face : Node3D

@export var quickTurn : bool

@onready var groundDetector = $GroundDetector

const movementSpeed=30

const ACCELERATION=40

const airMovementSpeed=30

const maxCoyoteTime=10

const angularMovementMultiplier=10

const TURNAROUNDMULTIPLIER=10

const jumpForce=10

var coyoteTime=0

func _physics_process(delta):
	#detect if we're on the ground
	groundDetector.global_rotation=Vector3.ZERO
	var onGround=groundDetector.is_colliding()
	#reduce coyote time
	coyoteTime-=delta*60
	#if we're on the ground, set coyote time to the max
	if onGround:
		coyoteTime=maxCoyoteTime
	#jumping
	if coyoteTime>0:
		if Input.is_action_just_pressed("Jump"):
			linear_velocity.y=jumpForce
			coyoteTime=0
	#set the camera's position to our position
	cameraHolder.position=position
	
	#get our input direction
	var inputDirection=Input.get_vector("Left","Right","Forward","Backward")
	#get the actual direction lol
	var direction = (cameraHolder.transform.basis * Vector3(inputDirection.x,0,inputDirection.y)).normalized()
	
	#movement uwu
	if direction != Vector3.ZERO:
		angular_velocity.z+=-direction.x*delta*ACCELERATION
		angular_velocity.x+=direction.z*delta*ACCELERATION
		
		if(quickTurn):
			if(-sign(direction.x)!=sign(angular_velocity.z)):
				angular_velocity.z=sign(-direction.x)*abs(angular_velocity.z)*TURNAROUNDMULTIPLIER
			if(sign(direction.z)!=sign(angular_velocity.x)):
				angular_velocity.x=sign(direction.z)*abs(angular_velocity.x)*TURNAROUNDMULTIPLIER
		
		angular_velocity.z=clamp(angular_velocity.z,-movementSpeed,movementSpeed)
		angular_velocity.x=clamp(angular_velocity.x,-movementSpeed,movementSpeed)
	
	# if we're below y -300 set us back to spawn with no speed
	if(position.y<-300):
		position=Vector3(0,3,0)
		linear_velocity=Vector3(0,0,0)
	pass
