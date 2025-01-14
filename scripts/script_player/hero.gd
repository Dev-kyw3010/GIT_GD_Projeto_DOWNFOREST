extends KinematicBody2D
class_name Hero

onready var player : Sprite = get_node("texture")
var velocity : Vector2 # Vector2(x,y)
export(int) var player_speed


func _physics_process(delta):
	
	Horizontal_Movement()
	velocity = move_and_slide(velocity)
	
	# Manager_Animations
	player.Manager_Animations(velocity)
func Horizontal_Movement() -> void:
	var horizontal_inputs : float = Input.get_action_strength("R_move") - Input.get_action_strength("L_move")
	
	velocity.x = horizontal_inputs * player_speed
