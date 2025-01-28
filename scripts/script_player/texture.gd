extends Sprite
class_name TextureHero

# Reiniciando a cena após morrer
signal game_over
var normal_attack : bool = false
var suffix : String = "_right"
var shield_off : bool = false
var crouching_off : bool = false
# Usando o AnimationPlayer
export(NodePath) onready var animation = get_node(animation) as AnimationPlayer
export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var attack_collision = get_node(attack_collision) as CollisionShape2D #  ref HitBox
func Manager_Animations(direction : Vector2) -> void:
	verify_flip(direction)
	if player.on_hit or player.dead:
		hit_anima()
	elif player.attacking or player.defending or player.crouching or player.next_to_wall():
		actions_anima()
	elif direction.y != 0:
		vertical_anima(direction)
	elif player.landing == true:
		animation.play("Landing") # Landing
		player.set_physics_process(false)
	else:
		horizontal_anima(direction)
	
func verify_flip(direction:Vector2) -> void:
	if direction.x > 0: 
		flip_h = false # right
		suffix = "_right"
		player.direcao = -1 # da direta para esquerda
		position = Vector2.ZERO # Vector2(0,0)
		player.wallray.cast_to = Vector2(6,0)
	elif direction.x < 0:
		flip_h = true # left
		suffix = "_left"
		player.direcao = 1 # da esquerda para a direita
		position = Vector2(-2,0) # um pouco para a esquerda
		player.wallray.cast_to = Vector2(-8,0)
		
func horizontal_anima(direction : Vector2) -> void:
	
	if direction.x != 0:
		animation.play("Run")
	else:
		animation.play("Idle")
		
func vertical_anima(direction : Vector2)	-> void:
	
	if direction.y > 0 :
		player.landing = true
		animation.play("fall")
	elif direction.y < 0:
		animation.play("jump")
		
func actions_anima() -> void :
	#Anima : wall_slide
	if player.next_to_wall():
		animation.play("wall_slide")
	# Anima : Actions
	elif player.attacking and normal_attack:
		animation.play("attack" + suffix)
	elif player.defending and shield_off:
		animation.play("shield")
		shield_off = false
	elif player.crouching and crouching_off:
		animation.play("crouch")
		crouching_off = false
		
func hit_anima() -> void:
	player.set_physics_process(false)
	if player.dead :
		animation.play("dead")
		attack_collision.set_deferred("disabled", true)
	elif player.on_hit:
		animation.play("hit")
		
func _animation_finished(anim_name : String):
	match anim_name:
		"Landing" :
			player.landing = false
			player.set_physics_process(true)
		"attack_left":
			player.attacking = false
			normal_attack = false
			
		"attack_right":
			player.attacking = false
			normal_attack = false
		"hit":
			player.on_hit = false
			player.set_physics_process(true)
			
			# Verificação
			if player.defending:
				animation.play("shield")
			
			if player.crouching :
				animation.play("crouch")
		"dead":
			emit_signal("game_over")
