extends KinematicBody2D
class_name EnemyTemplate

onready var texture : Sprite = get_node("Texture") # Ref Sprite
onready var floor_ray : RayCast2D = get_node("FloorRay") # Ref RayCast2D
onready var animation : AnimationPlayer = get_node("Animation") # Ref animationPlayer

# flags
var can_die : bool = false
var can_hit : bool = false
var can_attack : bool = false

# Herança
var velocity : Vector2
var player_ref : Hero = null

# Exports
export(int) var speed
export(int) var gravity_speed
export(int) var proximity_threshold # Limite de proximodade entre o inimigo e o personagem

func _physics_process(delta : float):
	
	enemy_gravity(delta)
	move_behavior()
	
func enemy_gravity(delta : float) -> void:
	velocity.y += delta * gravity_speed


func move_behavior() -> void:
	if player_ref != null:
		var distance : Vector2 = player_ref.global_position - global_position
		var direction : Vector2 = distance.normalized()
		
		if abs(distance.x) <= proximity_threshold:
			velocity.x = 0
			can_attack = true
		elif floor_collision() and not can_attack:
			velocity.x = direction.x * speed
		
		else:
			velocity.x = 0
		return
		
	velocity.x = 0 # se o personagem não estiver no alcance
			
func floor_collision() :
	pass
