extends Node2D

const MapData = preload("map_data.gd")
const MapEvaluator = preload("map_evaluator.gd")
const EvolutionManager = preload("evolution_manager.gd")

onready var map_viewer = get_node("MapViewer")
var evolution_manager

func _ready():
	# Initial setup
	randomize()
	map_viewer.create_map_view(EvolutionManager.GENERATION_SIZE)
	# Create population and render
	#test2()
	evolution_manager = EvolutionManager.new()
	evolution_manager.initiate_population()
	render_population()
	# Initiate UI
	#var next_gen_btn = get_node("NextGenBtn")
	#var ui_height = map_viewer.TILE_SIZE.y * (MapData.SIZE.y+2) + 0
	#ui_height *= map_viewer.scale.y
	#next_gen_btn.rect_position.y = ui_height

func render_population():
	for i in range(EvolutionManager.GENERATION_SIZE):
		map_viewer.build_map(evolution_manager.map_array[i], i)

func go_to_next_gen():
	evolution_manager.update_generation()
	render_population()

# Events

func _on_NextGenBtn_pressed():
	go_to_next_gen()

# Legacy
	
func test2():
	var evolution_manager = EvolutionManager.new()
	var map_data = MapData.new()
	map_data.create_random_map()
	#var map_data2 = MapData.new()
	#map_data2.create_random_map()
	#var map_data3 = evolution_manager.maps_crossover(map_data,map_data2)
	map_viewer.build_map(map_data, 0)
	#map_viewer.build_map(map_data2, 1)
	#map_viewer.build_map(map_data3, 2)
	evolution_manager.mutate_map(map_data)
	map_viewer.build_map(map_data, 1)
	
func test1():
	# var map_data = MapData.new()
	# map_data.create_random_room()
	# map_data.create_random_room()
	# map_data.create_random_corridor()
	# map_data.create_random_corridor()
	# map_spawner.spawn_map(map_data)
	# map_data.print_map_data()
	# var map_evaluator = MapEvaluator.new()
	# var score = map_evaluator.get_fitness(map_data)
	# print("Score: "+str(score))
	pass
	
	
func new_map():
	var map_data = MapData.new()
	var rooms = rand_range(2,5)
	for i in range(rooms):
		map_data.create_room(Vector2(rand_range(1,6),rand_range(1,6)),Vector2(rand_range(2,5),rand_range(2,5)))
		#map_data.create_corridor([Vector2(4,2),Vector2(7,2),Vector2(7,4)])
	#map_spawner.spawn_map(map_data)	
			
func create_defined_map():
	var map_data = MapData.new()
	map_data.create_room(Vector2(1,1), Vector2(3,4))
	map_data.create_room(Vector2(5,5), Vector2(4,2))
	map_data.create_corridor([Vector2(4,2),Vector2(7,2),Vector2(7,4)])

