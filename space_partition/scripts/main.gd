extends Node2D

const MapData = preload("map_data.gd")
const SpacePartition = preload("space_partition.gd")

onready var map_viewer = get_node("MapViewer")
var space_partition

func _ready():
	# Initial setup
	randomize()
	map_viewer.create_map_view()
	# Create population and render
	space_partition = EvolutionManager.new()
	var map_data = space_partition.generate_map()
	map_viewer.render_map(map_data)

func render_population():
	for i in range(EvolutionManager.GENERATION_SIZE):
		map_viewer.build_map(evolution_manager.map_array[i], i)
