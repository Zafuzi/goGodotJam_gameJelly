extends KinematicBody

var shoot_distance:float = 70
var close_soldier
var b = 1
var hp = 30
var attack = 3
var move = true
var speed = Vector3(-10,0,0)
var die = false
var enemy = 1
var wait = 10


func _physics_process(delta):

	var all_soldier = get_tree().get_nodes_in_group("soldier")
	
	if die == true:
		queue_free()
	
	if 1 == 0:#sealed away for later incase it becomes useful
		for soldier in all_soldier:
			
			var distance = translation.distance_to(soldier.translation)
			
			if distance < shoot_distance:
				shoot_distance = distance
				close_soldier = soldier
	
	if move == true:
		move_and_slide(speed)
	else:
		enemy.hp -= attack
		if enemy.hp <= 0:
			move = true
	
	if hp <= 0:
		die = true


func _on_Area_body_entered(body):#assign target
	if body.is_in_group("soldier"):
		body.hp -= 10
		enemy = body
		move = false


