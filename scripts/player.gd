extends CharacterBody3D

var sensitivity = 0.001
var speed = 4

var can_shoot = true
var ammo = 6
var snowball = preload("res://scenes/snowball_bullet.tscn")
@export var can_reload = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.rotation.y += -event.relative.x * sensitivity
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x - event.relative.y * sensitivity,- 1, 1 )
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		self.velocity.y = 5
	
	if Input.is_action_just_pressed("shoot") and can_shoot and ammo > 0:
		
		can_shoot = false
		start_shot()
	
	if Input.is_action_just_pressed("reload") and can_reload:
		ammo = 6
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = Vector3(direction.x * speed, velocity.y, direction.y * speed).rotated(Vector3(0,1,0), self.rotation.y)
	
	velocity.y -= 0.15
	
	move_and_slide()
func start_shot():
	var bullet = snowball.instantiate()
	bullet.transform = $Camera3D/snowball_start.global_transform
	self.get_parent().add_child(bullet)
	
	var drag = 0.1
	while not Input.is_action_just_released("shoot"):
		drag = move_toward(drag, 1, 0.01)
		bullet.global_position = $Camera3D/snowball_start.global_position - ease(drag, 3) * ($Camera3D/snowball_start.global_position - $Camera3D/snowball_back.global_position)
		await get_tree().process_frame
	bullet.process_mode = Node.PROCESS_MODE_ALWAYS
	await get_tree().physics_frame
	bullet.apply_central_impulse(ease(drag, 3) * ($Camera3D/snowball_start.global_position - $Camera3D/snowball_back.global_position) * 15)
	ammo -= 1
	await get_tree().create_timer(.05)
	can_shoot = true
