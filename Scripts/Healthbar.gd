extends Sprite3D

func _ready():
	texture = $Viewport.get_texture()
	
func update(amount):
	$Viewport/HealthBar.value = amount
