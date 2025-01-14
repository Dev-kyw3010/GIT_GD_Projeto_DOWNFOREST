extends ParallaxBackground
class_name Background

export(Array,int) var spd_layers
export(bool) var can_process

func _ready():
	
	if can_process == false:
		set_physics_process(false)
		
func _physics_process(delta : float):
	for index in get_child_count():
		if get_child(index) is ParallaxLayer:
			get_child(index).motion_offset.x -= delta * spd_layers[index]
