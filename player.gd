extends Area2D

signal hit


@export var speed = 400 #how fast the player will move (pixels/sec).
@export var explode_scene: PackedScene
var screen_size #size of the game window.
var player_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	player_size = $CollisionShape2D.shape.get_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO+player_size/2, screen_size-player_size/2)
	#position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		#$AnimatedSprite2D.flip_h = velocity.x < 0


func _on_body_entered(body):
        var boom = explode_scene.instantiate()
        boom.position = body.position
        get_parent().add_child(boom)
        boom.play()
        hide() # Player disappears after being hit.
        hit.emit()
        # Must be deferred as we can't change physics properties on a physics callback.
        $CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
