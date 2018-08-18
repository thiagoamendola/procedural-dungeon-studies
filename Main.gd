extends Node2D

const MapData = preload("res://MapData.gd")

onready var map_spawner = get_node("MapSpawner")

func _ready():
	var mapData = MapData.new()
	mapData.create_room(Vector2(1,1), Vector2(3,4))
	mapData.create_room(Vector2(5,5), Vector2(4,2))
	mapData.create_corridor([Vector2(4,2),Vector2(7,2),Vector2(7,4)])
	map_spawner.spawn_map(mapData)
	pass
