extends Node3D

@export var timeUntilPlayerStarts = 2000

@export var timeUntilPlayerLeaves = 2000

@onready var spawnPad = $SpawnPad

@onready var winPad = $WinPad

@onready var killZone = $DeathZone

@onready var player = $Player

@onready var audio = $Audio

var hasWon=false

var timer=null

var speedrunTimer=null

var playerLeaveTimer=0

var speedrunTime=0

var playedGo = false

var music = null

var readySFX = null

var goSFX = null

func _ready():
	#spawn the player at the position
	player=player.get_children()[0]
	player.position.y=spawnPad.position.y+3
	player.position.x=spawnPad.position.x
	player.position.z=spawnPad.position.z
	player.hasWon.connect(_win)
	#make the timer/text display
	timer=_create_timer()
	speedrunTimer=timer[0]
	timer=timer[1]
	music = audio.get_node("Music")
	readySFX = audio.get_node("Ready")
	goSFX = audio.get_node("Go")
	readySFX.play()
	pass

func _create_timer():
	var timerInstance=preload("res://Components/UI.tscn").instantiate()
	add_child(timerInstance)
	return timerInstance.get_children()

func _win():
	#win!!!
	timeUntilPlayerLeaves = 2000
	hasWon = true
	pass

func _player_died():
	#if the player died run this crap
	timeUntilPlayerStarts = 2000
	player.position=Vector3(spawnPad.position.x,spawnPad.position.y+3,spawnPad.position.z)
	player.linear_velocity=Vector3(0,0,0)
	player.angular_velocity=Vector3(0,0,0)
	playedGo = false
	music.stop()
	readySFX.play()
	speedrunTime=0

func _physics_process(delta):
	
	if(timeUntilPlayerStarts<=0&&!hasWon):
		speedrunTime+=delta*1000
	
	var speedrunTimeMS=speedrunTime
	
	var speedrunTimeSeconds=0
	
	while(speedrunTimeMS>1000):
		speedrunTimeMS-=1000
		speedrunTimeSeconds+=1
	
	speedrunTimer.text=str(floor(speedrunTimeSeconds))+" : "+str(floor(speedrunTimeMS))
	
	#reduce these values
	timeUntilPlayerStarts-=delta*1000
	timeUntilPlayerLeaves-=delta*1000
	
	#Run this code when they won
	if(timeUntilPlayerLeaves>0&&hasWon):
		timer.text="WIN"
		player.linear_velocity=Vector3(0,0,0)
		player.position.y-=(player.position.y-(winPad.position.y+1))/10
		player.position.x-=(player.position.x-winPad.position.x)/10
		player.position.z-=(player.position.z-winPad.position.z)/10
	#go back to the menu when you win
	if(timeUntilPlayerLeaves<=0&&hasWon):
		get_tree().change_scene_to_file("res://Rooms/Main Menu.tscn")
	#if player falls out of map do that
	if(player.position.y<killZone.position.y):
		_player_died()
	if(timeUntilPlayerStarts<=500&&!goSFX.is_playing()&&!playedGo):
		goSFX.play()
	if(!playedGo&&timeUntilPlayerStarts<=0):
		music.play()
		playedGo=true
	#run this if the player is starting
	if(timeUntilPlayerStarts>=0&&player!=null):
		player.linear_velocity.x = 0
		player.linear_velocity.z = 0
		player.position.x = spawnPad.position.x
		player.position.z = spawnPad.position.z
		timer.text=str(ceil(timeUntilPlayerStarts/1000))
		if(timeUntilPlayerStarts<=30):
			timer.text=""
	pass
