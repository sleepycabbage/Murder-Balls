extends Control

@export var room : String

@export var buttonName : String

@onready var child = $Button

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	child.text=buttonName

func _on_button_pressed():	
	get_tree().change_scene_to_file("res://maps/"+room)
	
	pass # Replace with function body.
