extends Node3D

@export var timeUntilPlayerStarts = 5000

@export var timeUntilPlayerLeaves = 5000

@onready var spawnPad = $SpawnPad

@onready var winPad = $WinPad

@onready var killZone = $DeathZone

@onready var player=$Player

var hasWon=false

var timer=null

var playerLeaveTimer=0

func _ready():
	#spawn the player at the position
	player=player.get_children()[0]
	player.position.y=spawnPad.position.y+3
	player.position.x=spawnPad.position.x
	player.position.z=spawnPad.position.z
	player.hasWon.connect(_win)
	#make the timer/text display
	timer=_create_timer()
	pass

func _create_timer():
	var timerInstance=preload("res://UIHealthBar.tscn").instantiate()
	add_child(timerInstance)
	return timerInstance.get_children()[0]

func _win():
	#win!!!
	timeUntilPlayerLeaves=5000
	hasWon=true
	pass

func _player_died():
	#if the player died run this crap
	timeUntilPlayerStarts = 5000
	player.position=Vector3(spawnPad.position.x,spawnPad.position.y+3,spawnPad.position.z)
	player.linear_velocity=Vector3(0,0,0)
	player.angular_velocity=Vector3(0,0,0)

func _physics_process(delta):
	#reduce these values
	timeUntilPlayerStarts-=delta*1000
	timeUntilPlayerLeaves-=delta*1000
	
	#Run this code when they won
	if(timeUntilPlayerLeaves>0&&hasWon):
		timer.text="WIN!!!!!!!"
		player.linear_velocity=Vector3(0,0,0)
		player.position.y-=(player.position.y-(winPad.position.y+1))/10
		player.position.x-=(player.position.x-winPad.position.x)/10
		player.position.z-=(player.position.z-winPad.position.z)/10
		#go back to the menu when you win
		if(timeUntilPlayerLeaves<=0):
			get_tree().change_scene_to_file("res://maps/menu.tscn")
	#if player falls out of map do that
	if(player.position.y<killZone.position.y):
		_player_died()
	#run this if the player is starting
	if(timeUntilPlayerStarts>=0&&player!=null):
		player.linear_velocity.x=0
		player.linear_velocity.z=0
		player.position.x=0
		player.position.z=0
		timer.text=str(ceil(timeUntilPlayerStarts/1000))
	pass
