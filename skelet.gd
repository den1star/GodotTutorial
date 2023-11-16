extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimatedSprite2D

var chase = false
var attack = false
@onready var player = $"../Player"

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	#anim.play("idle")
	
	var direction = (player.position - self.position).normalized()
	if chase:
		velocity.x = direction.x * SPEED
		anim.play("walk")
	else:
		velocity.x = 0 
		if !attack:
			anim.play("idle")
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	if attack:
		velocity.x = 0
		anim.play("attacks")
		
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		chase = true
		


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_attack_area_body_entered(body):
	if body.name == "Player":
		attack = true
		chase = false

func _on_attack_area_body_exited(body):
	if body.name == "Player":
		attack = false
		chase = true
