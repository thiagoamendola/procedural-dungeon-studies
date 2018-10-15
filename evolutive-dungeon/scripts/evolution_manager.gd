extends Node


const GENERATION_SIZE = 10
const GENERATION_SURVIVORS = 5
const RANDOM_PER_GENERATION = 2

const ROOMS_MUTATION_CHANCE = 0.5
const CORRIDORS_MUTATION_CHANCE = 0.5

const MapData = preload("map_data.gd")
const MapEvaluator = preload("map_evaluator.gd")

var generation
var map_array

#onready var map_evaluator = MapEvaluator.new()


func initiate_population():
    generation = 1
    # Reinstantiate vector of maps
    var map_data
    map_array = []
    for i in range(GENERATION_SIZE):
        # Create new random map
        map_data = MapData.new()
        map_data.create_random_map()
        map_array.append(map_data)


func update_generation():
    # sort maps by fitness
    map_array.sort_custom(self, "sort_maps")
    # delete worst maps
    for i in range(GENERATION_SIZE-GENERATION_SURVIVORS):
        map_array.pop_back()
    # recreate destroyed maps based on survivors
    var parent = 0
    var map_data
    for i in range(GENERATION_SURVIVORS-RANDOM_PER_GENERATION):
        # create crossover child
        map_data = maps_crossover(map_array[parent], map_array[parent+1])
        map_array.append(map_data)
        parent+=2
    for i in range(RANDOM_PER_GENERATION):
        # create random child
        map_data = MapData.new()
        map_data.create_random_map()
        map_array.append(map_data)

# Crossover

func maps_crossover(map1, map2):
    var map_child = MapData.new()
    crossover_rooms(map_child, map1, map2)
    crossover_corridors(map_child, map1, map2)
    #mutate_map(map_child, map1, map2)
    return map_child

func crossover_rooms(map_child, map1, map2):
    # Get random number between both map sizes.
    var num_rooms = rand_range(min(map1.room_list.size(),map2.room_list.size()),
                               max(map1.room_list.size(),map2.room_list.size())+1)
    # Create set with all rooms.
    var maps_rooms = []
    for room in map1.room_list:
        maps_rooms.append(room)
    for room in map2.room_list:
        maps_rooms.append(room)
    # Select randomly some of the rooms.
    for i in range(num_rooms):
        var index = rand_range(0,maps_rooms.size())
        var room = maps_rooms[index]
        maps_rooms.remove(index)
        map_child.room_list.append(room)

func crossover_corridors(map_child, map1, map2):
    # Get random number between both map sizes.
    var num_corridors = rand_range(min(map1.corridor_list.size(),map2.corridor_list.size()),
                                   max(map1.corridor_list.size(),map2.corridor_list.size())+1)
    # Create set with all corridors.
    var maps_corridors = []
    for corridor in map1.corridor_list:
        maps_corridors.append(corridor)
    for corridor in map2.corridor_list:
        maps_corridors.append(corridor)
    # Select randomly some of the corridors.
    for i in range(num_corridors):
        var index = rand_range(0,maps_corridors.size())
        var corridor = maps_corridors[index]
        maps_corridors.remove(index)
        map_child.corridor_list.append(corridor)

# Mutation

func mutate_map(map):
    mutate_rooms(map)
    mutate_corridors(map)

func mutate_rooms(map):
    if rand_range(0.0, 1.0) >= ROOMS_MUTATION_CHANCE:
        var prob = rand_range(0.0, 1.0)
        if prob > 0.5:
            map.create_random_room()
        else:
            map.room_list.remove(rand_range(0,len(map.room_list)))

func mutate_corridors(map):
    if rand_range(0.0, 1.0) >= CORRIDORS_MUTATION_CHANCE:
        var prob = rand_range(0.0, 1.0)
        if prob > 0.5:
            map.create_random_corridor()
        else:
            map.corridor_list.remove(rand_range(0,len(map.corridor_list)))

# Others

static func sort_maps(a, b):
    var map_evaluator = MapEvaluator.new()
    if map_evaluator.get_fitness(a) > map_evaluator.get_fitness(b):
        return true
    return false
    