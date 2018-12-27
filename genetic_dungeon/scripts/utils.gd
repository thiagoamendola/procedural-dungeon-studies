
# Normal distribution implementation through Box-Muller polar transform.
static func normal(mean, deviation):
    var x1 = null
    var x2 = null
    var w = null
    while true:
        x1 = rand_range(0, 2) - 1
        x2 = rand_range(0, 2) - 1
        w = x1*x1 + x2*x2
        if 0 < w && w < 1:
            break
    w = sqrt(-2 * log(w)/w)
    return floor(mean + deviation * x1 * w)

# Normal distribution with stablished limits.
static func normal_limits(mean, deviation, lower_bound, upper_bound):
    return min(upper_bound, max(lower_bound, normal(mean, deviation)))

# Check if value is between upper and lower bounds.
static func between(lower, value, upper):
    if value >= lower and value <= upper:
        return true
    return false




    # for x in range(map.SIZE.x):
    #    var text = ""
    #    for y in range(map.SIZE.y):
    #        text += ", "+str(matrix[x][y])
    #    print(text)

