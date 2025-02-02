extends Node
class_name PlayerStats

export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var collision_area = get_node(collision_area) as Area2D	
onready var invencibility_timer : Timer = get_node("InvencibilityTimer")
var shielding : bool = false

# Valores Base
var base_mana : int = 10
var base_vida : int =15
var base_ataque : int = 1
var base_magic : int = 3
var base_defense : int = 1

# Valores Bonus
var bonus_mana : int = 0
var bonus_vida : int = 0
var bonus_ataque : int = 0
var bonus_magic : int = 0 
var bonus_defense : int = 0

# Currents & Max ( Vida e Mana )
var current_mana : int
var current_vida : int
var max_mana : int
var max_vida : int 

# Experiencia
var current_exp : int = 1
var nvl : int = 1 # Nivel

# Dictionary
var levels : Dictionary = {
	"1": 20,
	"2": 50,
	"3": 80,
	"4": 110,
	"5": 150,
	"6": 190,
	"7": 220,
	"8": 250,
	"9": 280,
	"10": 310 # Max Level
}

# GODOT FUNCTIONS : _ready , _process , _physics_process , ...
func _ready():
	current_mana = base_mana + bonus_mana
	max_mana = current_mana
	
	current_vida = base_vida + bonus_vida
	max_vida = current_vida

# -------------------------------------------------------

# FUNCTIONS : EXPERIENCE
func update_exp(value : int) -> void:
	current_exp += value
	if current_exp >= levels[str(nvl)] and nvl < 10:
		var leftover : int = current_exp - levels[str(nvl)]  # o resto do valor de experiencia
		current_exp = leftover # 30 - 5 => [ leftover = 5]
		
		_level_up() # Atualiza os valores de mana e vida ao subir de nivel
		nvl += 1
	# caso o hero chegue ao nível máximo
	elif current_exp >= levels[str(nvl)] and nvl == 10:
		current_exp = levels[str(nvl)]
	
func _level_up() -> void:
	current_mana = base_mana + bonus_mana
	current_vida = base_vida + bonus_vida
# --------------------------------------------------------

# FUNCTIONS : VIDA

func update_health(type : String , value : int) -> void:
	
	# casos 
	match type:
		"Increase": # adicionando vida ( usar potion , update_exp)
			current_vida += value
			if current_vida >= max_vida:
				current_vida = max_vida
			
		"Decrease": # tirando vida
			verify_shield(value) # Calcula o dano sofrido - o valor de defesa
			
			if current_vida <= 0:
				player.dead = true # animation dead
			else:
				player.on_hit = true # animation hit
				player.attacking = false # impede o ataque
func verify_shield(value:int) ->void:
	if shielding:
		if (base_defense + bonus_defense) > value:
			return # o personagem não perde vida
			
# warning-ignore:narrowing_conversion
		var damage := abs((base_defense + bonus_defense) - value) # valor absoluto
		current_vida -= damage # levando dano
		
	# caso o escudo não seja ativado
	else:
		current_vida -= value
		

# ---------------------------------------

# FUNCTIONS : MANA

func update_mana(type : String, value : int) -> void:
	match type:
		"Increase": 
			current_mana += value
			if current_mana >= max_mana:
				current_mana = max_mana
			
		"Decrease": 
			current_mana -= value
			
			
	
# Teste e Verificação das Animações de HIT e DEAD
func _process(delta) :
	if Input.is_action_just_pressed("hit_test"):
		update_health("Decrease", 5)





func _on_collision_area_entered(area):
	
	if area.name == "EnemyAttackArea":
		update_health("Decrease", area.damage)
		collision_area.set_deferred("monitoring",false)
		invencibility_timer.start(area.invencibility_timer) # varia de inimigo para outro
	


func _on_InvencibilityTimer_timeout() -> void:
	collision_area.set_deferred("monitoring", true)
	
