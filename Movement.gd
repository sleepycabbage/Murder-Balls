extends RigidBody3D

@export var cameraHolder : Node3D

@export var face : Node3D

@export var quickTurn : bool

@export var jumpBufferTime : int

@onready var groundDetector = $GroundDetector

signal dead

const movementSpeed=30

const ACCELERATION = 400

const airMovementSpeed=30

const maxCoyoteTime=10

const angularMovementMultiplier=10

const TURNAROUNDMULTIPLIER=10

const jumpForce=10

var coyoteTime=0

var jumpBuffer=0

var camera=null

var defaultFov = 99.4

@export var maxHealth : float

var localHealth=100

func _ready():
	camera=cameraHolder.get_children()[0].get_children()[1]
	print(camera)
	pass

func _physics_process(delta):	
	var speedNormal = Vector3(linear_velocity.x,0,linear_velocity.z).normalized()
	
	var speed = speedNormal.x+speedNormal.z
	
	camera.fov-=(camera.fov-defaultFov*(abs(speed/7)+1))/10
	
	#detect if we're on the ground
	groundDetector.global_rotation=Vector3.ZERO
	var onGround=groundDetector.is_colliding()
	#reduce coyote time
	coyoteTime-=delta*60
	
	jumpBuffer-=delta*60
	
	print(jumpBuffer)
	
	if Input.is_action_just_pressed("Jump"):
		jumpBuffer=jumpBufferTime
	
	#if we're on the ground, set coyote time to the max
	if onGround:
		coyoteTime=maxCoyoteTime
	#jumping
	if coyoteTime>0:
		if jumpBuffer>0:
			linear_velocity.y=jumpForce
			coyoteTime=0
			jumpBuffer=0
	#set the camera's position to our position
	cameraHolder.position=position
	
	#get our input direction
	var inputDirection=Input.get_vector("Left","Right","Forward","Backward")
	#get the actual direction lol
	var direction = (cameraHolder.global_basis * Vector3(inputDirection.x,0,inputDirection.y)).normalized()
	
	#because torque is different
	direction = direction.rotated(Vector3.UP,PI/2.0)
	
	#movement uwu
	if direction != Vector3.ZERO:
		apply_torque(direction*delta*ACCELERATION)
	pass
