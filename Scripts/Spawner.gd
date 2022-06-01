extends Spatial

export(PackedScene) var pawnScene

export(int) var pawnsToPreload = 9
export(int) var maxSpawnsAliveAtOnce = 1

var pawns = []
var alivePawns = 0

export(NodePath) var objective

func _ready():
	assert(objective != "", "ERROR: Set an objective for spawner to attack")
	
	objective = get_node(objective)
	
	for i in pawnsToPreload:
		var p = pawnScene.instance()
		p.set_translation(get_translation())
		p.objective = objective
		pawns.append(p)
		get_parent().call_deferred("add_child", p)

func _on_RespawnTimer_timeout():
	alivePawns = 0
		
	for pawn in pawns:
		if !pawn.isDead():
			alivePawns += 1
			
	if alivePawns > maxSpawnsAliveAtOnce:
		return
		
	var pawnToSpawn = null
	
	for pawn in pawns:
		if pawn.isDead():
			pawnToSpawn = pawn
			break
			
	if pawnToSpawn:
		pawnToSpawn.set_translation(get_translation())
		pawnToSpawn.makeAlive()
