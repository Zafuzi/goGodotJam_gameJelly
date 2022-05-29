extends KinematicBody

var shoot_distance:float = 70
var close_enemy


func _physics_process(delta):

	var all_enemy = get_tree().get_nodes_in_group("enemy")

	for enemy in all_enemy:
		
		var distance = translation.distance_to(enemy.translation)
		
		if distance < shoot_distance:
			shoot_distance = distance
			close_enemy = enemy
