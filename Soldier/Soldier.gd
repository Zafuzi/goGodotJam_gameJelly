extends KinematicBody

var shoot_distance:float = 70
var close_enemy
var b = 1
var hp = 30
var attack = 4
var move = true
var speed = Vector3(10,0,0)
var die = false
var enemy = 1
var wait = 10


func _physics_process(delta):

	var all_enemy = get_tree().get_nodes_in_group("enemy")
	
	if die == true:
		queue_free()
	
	if 1 == 0:#sealed away for later incase it becomes useful
		for enemy in all_enemy:
			
			var distance = translation.distance_to(enemy.translation)
			
			if distance < shoot_distance:
				shoot_distance = distance
				close_enemy = enemy
	
	if move == true:#movement
		move_and_slide(speed)
	else:#fighting
		enemy.hp -= attack
		print(enemy.hp)
		if enemy.hp <= 0:#continuing after fight
			move = true
	
	if hp <= 0:
		die = true


func _on_Area_body_entered(body):#assign target
	if body.is_in_group("enemy"):
		body.hp -= 10
		enemy = body
		move = false
	


