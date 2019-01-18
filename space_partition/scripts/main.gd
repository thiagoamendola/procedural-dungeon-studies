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
	#map_viewer.render_partition_limits()
	update()

func _draw():
	if map_viewer!=null:
		map_viewer.render_partition_limits(space_partition.tree_node)
	

func _on_ResetBtn_pressed():
	var map_data = MapData.new()
	space_partition.generate_map(map_data)
	map_viewer.render_map(map_data)
	update()

func _on_PartitionsBtn_pressed():
	map_viewer.partitions_visible = !map_viewer.partitions_visible
	update()
