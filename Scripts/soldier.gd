extends Spatial

var b = 1
var hp = 30
var attack = 3
var move = false
var speed = Vector3(10,0,0)
var die = true
var enemy = null
var wait = 10

var _initial_position

func _ready():
	_initial_position = get_translation()
	hide()

func _process(delta):
	var wr = weakref(enemy)
	if wr.get_ref():
		enemy.hp -= attack
		if enemy.hp <= 0:
			enemy = null
			move = true


func _physics_process(delta):
	if hp <= 0:
		reset()

	if move == true:
		translation += speed * delta
		
	if translation.x > 100:
		reset()

func reset():
	hp = 30
	die = true
	move = false
	enemy = null
	set_translation(_initial_position)

func makeAlive():
	die = false
	move = true
	show()


func _on_Area_area_entered(area):
	if area.is_in_group("enemy") or area.is_in_group("enemy_spawner"):
		enemy = area.get_owner()
		move = false
