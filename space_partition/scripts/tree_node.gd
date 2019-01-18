extends Node2D

# Imports

const utils = preload("utils.gd")

# Parameters

var map_data
var origin
var ending
var childs
var orientation

var room_pos
var room_size

func init_root(map):
    map_data = map
    origin = Vector2(0,0)
    ending = Vector2(map.SIZE.x, map.SIZE.y)
    childs = []

func get_size():
    return Vector2(ending.x-origin.x, ending.y-origin.y)

func print():
    var cur_size = get_size()
    print("SIZE:("+str(cur_size.x)+","+str(cur_size.y)+") ; origin:("+str(origin.x)+","+str(origin.y)+") ; ending("+str(ending.x)+","+str(ending.y)+")")
