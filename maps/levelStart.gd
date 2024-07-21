extends Node3D

@export var timeUntilPlayerStarts = 5000

@onready var spawnPad = $SpawnPad

@onready var killZone = $DeathZone

var player=null

var timer=null

func _ready():
	#TEMPORARY PLAYER SPAWN
	player=_create_player()
	player.position.y=spawnPad.position.y+3
	player.position.x=spawnPad.position.x
	player.position.z=spawnPad.position.z
	timer=_create_timer()
	killZone = killZone.get_children()[0]
	pass

func _create_player():
	var playerInstance=preload("res://Objects/Player.tscn").instantiate()
	add_child(playerInstance)
	return playerInstance.get_children()[0]

func _create_timer():
	var timerInstance=preload("res://UIHealthBar.tscn").instantiate()
	add_child(timerInstance)
	return timerInstance.get_children()[0]

func _player_died():
	timeUntilPlayerStarts = 5000
	player.position=Vector3(spawnPad.position.x,spawnPad.position.y+3,spawnPad.position.z)
	player.linear_velocity=Vector3(0,0,0)
	player.angular_velocity=Vector3(0,0,0)

func _physics_process(delta):		
	timeUntilPlayerStarts-=delta*1000
	if(timeUntilPlayerStarts>=0&&player!=null):
		player.linear_velocity.x=0
		player.linear_velocity.z=0
		player.position.x=0
		player.position.z=0
		timer.text=str(floor(timeUntilPlayerStarts/1000))
	pass
