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
	space_partition = SpacePartition.new()
	var map_data = MapData.new()
	space_partition.generate_map(map_data)
	map_viewer.render_map(map_data)
