extends StaticBody

var wait = 0
var hp = 30

onready var soldier = preload("res://Enemy/Enemy.tscn")
onready var soldier2 = preload("res://Enemy/Enemy.tscn")
onready var soldier3 = preload("res://Enemy/Enemy.tscn")

func _process(delta):
	if wait == 0:
		wait = 120
		var s1 = soldier.instance()
		var s2 = soldier2.instance()
		var s3 = soldier3.instance()
		$Spatial.add_child(s1)
		$Spatial2.add_child(s2)
		$Spatial3.add_child(s3)
	else:
		wait -= 1
	
	
	if hp <= 0:
		queue_free()
