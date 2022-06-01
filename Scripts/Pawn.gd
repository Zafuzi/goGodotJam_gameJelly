extends KinematicBody

var path = []
var path_node = 0

var speed = 10

onready var nav = get_parent()
export(String) var enemyGroupName

var objective

enum STATES {
	ATTACKING
	MOVING
	IDLE
	DEAD
}

var enemy = null

var currentState = STATES.DEAD

var hp = 0 # start dead
var MAX_HP = 30

var initial_position
var initial_rotation


signal take_damage
signal killed_enemy

var canAttack = true

func _ready():
	connect("take_damage", self, "_on_take_damage")
	connect("killed_enemy", self, "_on_killed_enemy")
	initial_position = get_translation()
	initial_rotation = get_rotation()
	

func _process(delta):
	if currentState == STATES.DEAD:
		return
		
	if enemy != null and enemy.hp <= 0:
		enemy = null
		
	if currentState == STATES.IDLE:
		var enemies = get_tree().get_nodes_in_group(enemyGroupName)
		
		if enemies.size() > 0:
			# assume the first enemy node is closest
			var nearest_enemy = enemies[0]

			# look through enemy nodes to see if any are closer
			for e in enemies:
				if e.global_transform.origin.distance_to(global_transform.origin) < nearest_enemy.global_transform.origin.distance_to(global_transform.origin):
					nearest_enemy = e
						
				if e.enemy == null:
					nearest_enemy = objective
			
			enemy = nearest_enemy
		
	if currentState == STATES.ATTACKING and enemy != null:
		if canAttack:
			canAttack = false
			enemy.emit_signal("take_damage")
#			Sparrow: has no idea why this is giving null referance ?
#			$AnimationTree.set("parameters/Attacking/active",true)

func _physics_process(delta):
	if currentState == STATES.DEAD:
		return
		
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
			if currentState == STATES.MOVING:
				move_and_slide(direction.normalized() * speed, Vector3.UP)

func move_to(target_pos):
	if currentState == STATES.DEAD:
		return
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_Timer_timeout():
	if currentState == STATES.DEAD:
		return
		
	if enemy:
		var distanceToEnemy = enemy.global_transform.origin.distance_to(global_transform.origin)
		
		if distanceToEnemy < $AttackSphere/CollisionShape.shape.radius * 2:
			currentState = STATES.ATTACKING
		else:
			currentState = STATES.MOVING
			move_to(enemy.global_transform.origin)
	else:
		currentState = STATES.IDLE

func _on_AttackSphere_body_entered(body):
	if body.is_in_group(enemyGroupName):
		currentState = STATES.ATTACKING
		enemy = body

func _on_take_damage():
	print(hp)
	hp -= 1
	if $HealthBar:
		$HealthBar.update(hp)
	if hp <= 0:
		die()
		
func _on_killed_enemy():
	currentState = STATES.IDLE
	enemy = null
		
func die():
	if enemy != null:
		enemy.emit_signal("killed_enemy")
	currentState = STATES.DEAD
	hide()
	set_translation(initial_position)
	set_rotation(initial_rotation)
	
func isDead():
	return currentState == STATES.DEAD
	
func makeAlive():
	hp = MAX_HP
	currentState = STATES.IDLE
	show()
	$HealthBar.update(hp)


func _on_AttackTimer_timeout():
	canAttack = true
