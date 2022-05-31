extends Spatial

var wait = 0
var hp = 1000

var MAX_ENEMIES = 12

export(PackedScene) var pawn
onready var pawns = []

func _ready():
	
	assert( pawn != null, "ERROR: You must give pawn a value.");
		
	var spawnerNumber = 1
	for i in MAX_ENEMIES:
		var p = pawn.instance()
		pawns.append(p)
		
		if(spawnerNumber == 1):
			$Spatial.add_child(p)
			
		if(spawnerNumber == 2):
			$Spatial2.add_child(p)
			
		if(spawnerNumber == 3):
			$Spatial3.add_child(p)
			
		spawnerNumber += 1
		if spawnerNumber > 3:
			spawnerNumber = 1

func _process(delta):
	if hp <= 0:
		queue_free()

func _on_RespawnTimer_timeout():
	var i = 0
	for p in pawns:
		if p.die:
			p.reset()
			p.makeAlive()
			i += 1
			
			if i > 3:
				break
