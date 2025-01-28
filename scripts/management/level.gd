extends Node2D
class_name Level

onready var hero : KinematicBody2D = get_node("Player") # Referenciando o KinematicBody2D
 
func _ready() -> void:
	var _game_over : bool = hero.get_node("texture").connect("game_over", self , "on_game_over")
	
func on_game_over() -> void:
	var reload : bool = get_tree().reload_current_scene()
