extends KinematicBody

var path = []
var path_node = 0

var speed = 10

onready var nav = get_parent()
export(String) var enemyGroupName

var enemy = null

func _process(delta):
	var enemies = get_tree().get_nodes_in_group(enemyGroupName)

	# assume the first enemy node is closest
	var nearest_enemy = enemies[0]

	# look through enemy nodes to see if any are closer
	for e in enemies:
		if e.global_transform.origin.distance_to(global_transform.origin) < nearest_enemy.global_transform.origin.distance_to(global_transform.origin):
			nearest_enemy = e
	
	enemy = nearest_enemy

func _physics_process(delta):
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_Timer_timeout():
	if enemy:
		print(enemy)
		move_to(enemy.global_transform.origin)
