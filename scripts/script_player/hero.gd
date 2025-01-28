extends KinematicBody2D
class_name Hero

onready var player : Sprite = get_node("texture") # referencia a Sprite
onready var wallray : RayCast2D = get_node("wall_ray") # referencia ao RayCast2D
onready var stats : Node = get_node("Stats") # referencia ao Node
var velocity : Vector2 # Vector2(x,y)

var jump_count : int = 0
var landing : bool = false
# EXPORTS
export(int) var player_speed # velocidade de movimentação horizontal
export(int) var jump_speed
export(int) var player_gravity # gravidade do personagem
 
# Variaveis de Attack , Shield e Crouch
var attacking : bool = false # flag de ataque
var defending : bool = false # flag de defesa
var crouching : bool = false # flag de agachar
var can_track_input : bool = true # gerenciar as flags de action

# Wall_Ray
var on_wall : bool = false
var not_on_wall : bool = true
var direcao : int = 1 # por padrão , começa olhando para a direita
export(int) var wall_jump_speed # velocidade do pulo na parede
export(int) var wall_gravity # gravidade do wallslide
export(int) var wall_impulse_speed # impulso da parede

# ON_HIT e DEAD
var on_hit : bool = false
var dead : bool = false
func _physics_process(delta):
	
	horizontal_movement_env()
	vertical_movement_env()
	gravity(delta)
	actions()
	velocity = move_and_slide(velocity,Vector2.UP)
	
	# Manager_Animations
	player.Manager_Animations(velocity)

# Horizontal Movement
func horizontal_movement_env() -> void:
	var horizontal_inputs : float = Input.get_action_strength("R_move") - Input.get_action_strength("L_move")
	if (can_track_input == false) or attacking:
		velocity.x = 0
		return # ignorar o código abaixo 
	else:
		velocity.x = horizontal_inputs * player_speed

# Vertical Movement
func vertical_movement_env() -> void:
	if is_on_floor() or is_on_wall():
		jump_count = 0
	
	var jump_condition = can_track_input and not attacking # Encurtando a verificação
	
	if Input.is_action_just_pressed("Jump") and jump_count < 2 and jump_condition:
		jump_count += 1
		if next_to_wall() and not is_on_floor():
			velocity.y = wall_jump_speed
			velocity.x += wall_impulse_speed * direcao
		else:
			velocity.y = jump_speed
	
# Actions Environment
func actions() -> void:
	attack()
	crouch()
	defense()
# Components
func gravity(delta : float)	-> void:
	if next_to_wall(): # configuração do wall_gravity
		velocity.y += wall_gravity * delta
		if velocity.y >= wall_gravity:
			velocity.y = wall_gravity
	else:
		# configuração do gravity
		velocity.y += delta * player_gravity
		if velocity.y >= player_gravity:
			velocity.y = player_gravity
		
func attack() -> void:
	var attack_condition : bool = not attacking and not crouching and not defending
	
	if Input.is_action_just_pressed("ataque") and attack_condition and is_on_floor():
		attacking = true # ativando a flag de attack
		player.normal_attack = true

func crouch() -> void:
	# Ativando o crouch
	if Input.is_action_pressed("D_move") and is_on_floor() and not defending:
		crouching = true
		stats.shielding = false
		can_track_input = false
	# Desativando o crouch
	elif not defending:
		crouching = false
		can_track_input = true
		stats.shielding = false
		player.crouching_off = true
	
func defense() -> void:
	# Ativando o crouch
	if Input.is_action_pressed("shield") and is_on_floor() and not crouching:
		defending = true
		stats.shielding = true
		can_track_input = false
	# Desativando o crouch
	elif not crouching:
		defending = false
		can_track_input = true
		stats.shielding = false
		player.shield_off = true	

# Components : WallSlide

func next_to_wall() -> bool	:
	if wallray.is_colliding() and not is_on_floor():
		if not_on_wall: # deslizar para cima
			velocity.y = 0
			not_on_wall	= false
		return true
	else:
		not_on_wall = true
		return false
		
