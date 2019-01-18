extends Node

var map_to_test

func test_map(map):
    map_to_test = map
    get_tree().change_scene("map_tester/map_tester.tscn")