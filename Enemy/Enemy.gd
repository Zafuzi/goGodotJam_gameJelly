extends KinematicBody

var shoot_distance:float = 70
var close_soldier


func _physics_process(delta):

	var all_soldiers = get_tree().get_nodes_in_group("soldier")

	for soldier in all_soldiers:
		
		var distance = translation.distance_to(soldier.translation)
		
		if distance < shoot_distance:
			shoot_distance = distance
			close_soldier = soldier
