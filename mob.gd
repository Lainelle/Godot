extends RigidBody2D

@export var rot_speed = 1  # радианы в секунду

func _ready():
	$AnimatedSprite2D.play()
	angular_velocity = rot_speed   # радианы/сек

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
