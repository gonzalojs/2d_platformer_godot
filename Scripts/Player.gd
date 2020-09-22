extends KinematicBody2D


const MOVE_SPEED = 75
const JUMP_FORCE = 300
const GRAVITY = 30
const MAX_FALL_SPEED = 500

onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer

var y_velocidad = 0
var facing_right = false

func _physics_process(delta: float) -> void:
	var move_dir = 0
	if Input.is_action_pressed("ui_right"):
		move_dir += 1
	if Input.is_action_pressed("ui_left"):
		move_dir -= 1
	move_and_slide(Vector2(move_dir * MOVE_SPEED, y_velocidad), Vector2(0, -1))
	
	var grounded = is_on_floor()
	y_velocidad += GRAVITY
	if grounded and Input.is_action_just_pressed("jump"):
		y_velocidad = -JUMP_FORCE
	if grounded and y_velocidad >= 5:
		y_velocidad = 5
	if y_velocidad > MAX_FALL_SPEED:
		y_velocidad = MAX_FALL_SPEED
	
	if facing_right and move_dir > 0:
		flip()
	if !facing_right and move_dir < 0:
		flip()
	
	if grounded:
		if move_dir == 0:
			play_anim("Idle")
		else:
			play_anim("Run")
	else:
		play_anim("Jump")

func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h

func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)
