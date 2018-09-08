extends Node2D

const MapData = preload("res://map_data.gd")
const MapEvaluator = preload("res://map_evaluator.gd")

onready var map_spawner = get_node("MapSpawner")

func _ready():
	randomize()
	#new_map()
	var map_data = MapData.new()
	map_data.create_random_room()
	map_data.create_random_room()
	map_data.create_random_corridor()
	map_data.create_random_corridor()
	map_spawner.spawn_map(map_data)
	map_data.print_map_data()
	var map_evaluator = MapEvaluator.new()
	var score = map_evaluator.get_fitness(map_data)
	print("Score: "+str(score))

	
func new_map():
	var map_data = MapData.new()
	var rooms = rand_range(2,5)
	for i in range(rooms):
		map_data.create_room(Vector2(rand_range(1,6),rand_range(1,6)),Vector2(rand_range(2,5),rand_range(2,5)))
		#map_data.create_corridor([Vector2(4,2),Vector2(7,2),Vector2(7,4)])
	map_spawner.spawn_map(map_data)	
			
func create_defined_map():
	var map_data = MapData.new()
	map_data.create_room(Vector2(1,1), Vector2(3,4))
	map_data.create_room(Vector2(5,5), Vector2(4,2))
	map_data.create_corridor([Vector2(4,2),Vector2(7,2),Vector2(7,4)])