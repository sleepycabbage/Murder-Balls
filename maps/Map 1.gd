extends Node3D

func _ready():
	#TEMPORARY PLAYER SPAWN
	var player=_create_player()
	player.position.y=3

func _create_player():
	var playerInstance=preload("res://Player.tscn").instantiate()
	add_child(playerInstance)
	return playerInstance

func _process(delta):
	pass
