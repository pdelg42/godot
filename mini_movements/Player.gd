extends KinematicBody2D

const particles_lifetime	: float = 200.0

onready var sprite		: Sprite = $Sprite
onready var raycast		: RayCast2D = $RayCast2D
onready var particles	: Particles2D = $Particles
onready var	velocity	: Vector2 = Vector2(0, 0)

export (float) var	speed = 100.0
export (float) var	accel = 0.50
export (float) var	rotation_speed = 1.5

var current_speed	: float = 0.0
var	input_dir		: Vector2 = Vector2.ZERO
var	face_to			: Vector2 = Vector2.UP setget set_face_to, get_face_to

func set_face_to(value):
	face_to = value
	if int(rotation_degrees) % 360 == 0:
		rotation_degrees = 0
	look_at(global_position + face_to)

func get_face_to() -> Vector2:
	return (face_to)
	
func _ready():
	set_face_to(face_to)
	particles.lifetime = 0.001

func _physics_process(delta):
	
	if (particles.lifetime > 0.01):
		particles.emitting = true
	else:
		particles.emitting = false
	
	input_dir.x = Input.get_action_strength("ui_right") \
				- Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") \
				- Input.get_action_strength("ui_up")
	
	current_speed = max(0, current_speed)
	
	if input_dir.x:
		set_face_to(face_to.rotated(input_dir.x * PI * delta * rotation_speed))
	if input_dir.y:
		current_speed = lerp(current_speed, -input_dir.y * speed, 0.05)
	
	velocity = velocity.linear_interpolate(face_to.normalized() * current_speed, delta * accel)
		
	particles.lifetime = max(0.001, velocity.length() / 100)
	
	velocity = move_and_slide(velocity)
