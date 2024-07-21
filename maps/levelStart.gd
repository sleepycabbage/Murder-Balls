extends Node3D

@export var timeUntilPlayerStarts = 5000

var player=null

var timer=null

func _ready():
	#TEMPORARY PLAYER SPAWN
	player=_create_player()
	player.position.y=3
	player.connect("dead",_player_died)
	timer=_create_timer()

func _create_player():
	var playerInstance=preload("res://Player.tscn").instantiate()
	add_child(playerInstance)
	return playerInstance.get_children()[0]

func _create_timer():
	var timerInstance=preload("res://UIHealthBar.tscn").instantiate()
	add_child(timerInstance)
	return timerInstance.get_children()[0]

func _player_died():
	timeUntilPlayerStarts = 5000

func _physics_process(delta):		
	timeUntilPlayerStarts-=delta*1000
	if(timeUntilPlayerStarts>=0&&player!=null):
		player.linear_velocity.x=0
		player.linear_velocity.z=0
		player.position.x=0
		player.position.z=0
		timer.text=str(round(timeUntilPlayerStarts/1000))
	pass
