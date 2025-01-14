extends Sprite
class_name TextureHero

func Manager_Animations(direction : Vector2) -> void:
	verify_flip(direction)
	horizontal_anima(direction)
	
func verify_flip(direction:Vector2) -> void:
	if direction.x > 0: 
		flip_h = false # right
	elif direction.x < 0:
		flip_h = true # left
func horizontal_anima(direction : Vector2) -> void:
	pass
