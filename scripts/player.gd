extends CharacterBody3D

var sensitivity = 0.001
var speed = 4

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.rotation.y += -event.relative.x * sensitivity
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x - event.relative.y * sensitivity,- 1, 1 )
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		self.velocity.y = 5

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = Vector3(direction.x * speed, velocity.y, direction.y * speed).rotated(Vector3(0,1,0), self.rotation.y)
	
	velocity.y -= 0.15
	
	move_and_slide()
