extends RigidBody2D

var WALK_ACCEL = 800.0
var WALK_DEACCEL = 800.0
var WALK_MAX_VELOCITY = 200.0


func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()

	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var move_up = Input.is_action_pressed("move_up")
	var move_down = Input.is_action_pressed("move_down")

	lv.x = calc_axis_movement(move_left, move_right, step, lv.x)
	lv.y = calc_axis_movement(move_up, move_down, step, lv.y)

	s.set_linear_velocity(lv)

func calc_axis_movement(negative_dir, positive_dir, step, vel):
	if negative_dir and not positive_dir:
		if vel > -WALK_MAX_VELOCITY:
			vel -= WALK_ACCEL * step
	elif positive_dir and not negative_dir:
		if vel < WALK_MAX_VELOCITY:
			vel += WALK_ACCEL * step
	else:
		var axisv = abs(vel)
		axisv -= WALK_DEACCEL * step
		if axisv < 0:
			axisv = 0
		vel = sign(vel) * axisv
	return vel
