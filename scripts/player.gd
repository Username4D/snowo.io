extends CharacterBody3D

var sensitivity = 0.001
var speed = 4

var can_shoot = true
var ammo = 6

var d_bullet = preload("res://scenes/snowball_bullet_decoy.tscn")
var r_bullet = preload("res://scenes/snowball_bullet.tscn")
@export var can_reload = false

@export var team = "none"

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		get_multiplayer_authority()
		print(self.name)
		return
	if event is InputEventMouseMotion:
		self.rotation.y += -event.relative.x * sensitivity
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x - event.relative.y * sensitivity,- 1, 1 )
	
	if Input.is_action_just_pressed("esc"):
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_VISIBLE else DisplayServer.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		self.velocity.y = 5
	
	if Input.is_action_just_pressed("shoot") and can_shoot and ammo > 0:
		
		can_shoot = false
		start_shot()
	
	if Input.is_action_just_pressed("reload") and can_reload:
		ammo = 6
func _physics_process(delta: float) -> void:
	
	if !is_multiplayer_authority(): return
	
	if velocity.x != 0 or velocity.z != 0:
		$AuxScene/AnimationPlayer.current_animation = "Running(2)_1"

	else:
		$AuxScene/AnimationPlayer.current_animation = "Idle(1)_2"

	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = Vector3(direction.x * speed, velocity.y, direction.y * speed).rotated(Vector3(0,1,0), self.rotation.y)
	
	velocity.y -= 0.15
	
	move_and_slide()
func start_shot():

	var bullet = d_bullet.instantiate()
	bullet.transform = $Camera3D/snowball_start.global_transform
	self.add_child(bullet)
	var drag = 0.1
	while not Input.is_action_just_released("shoot"):
		drag = move_toward(drag, 1, 0.01)
		bullet.global_position = $Camera3D/snowball_start.global_position - ease(drag, 3) * ($Camera3D/snowball_start.global_position - $Camera3D/snowball_back.global_position)
		await get_tree().process_frame
	await get_tree().physics_frame
	
	shoot.rpc(int(self.name), drag, $Camera3D/snowball_start.global_position - ease(drag, 3) * ($Camera3D/snowball_start.global_position - $Camera3D/snowball_back.global_position), ease(drag, 3) * ($Camera3D/snowball_start.global_position - $Camera3D/snowball_back.global_position) * 15)
	shoot(int(self.name), drag, $Camera3D/snowball_start.global_position - ease(drag, 3) * ($Camera3D/snowball_start.global_position - $Camera3D/snowball_back.global_position), ease(drag, 3) * ($Camera3D/snowball_start.global_position - $Camera3D/snowball_back.global_position) * 15)
	bullet.queue_free()
	ammo -= 1
	await get_tree().create_timer(.05)
	can_shoot = true
func _ready() -> void:
	if !is_multiplayer_authority(): return
	$Camera3D.current = true
	
@rpc("any_peer") func shoot(origin, drag, nposition, impulse):
	var bullet = r_bullet.instantiate()
	bullet.global_position = nposition
	self.get_parent().add_child(bullet)
	bullet.apply_central_impulse(impulse)
	
func _process(delta: float) -> void:
	$AuxScene/Node/Skeleton3D/Cube.get_surface_override_material(0).albedo_color = Color(1,0,0, int(!is_multiplayer_authority())) if team == "red" else Color(0,0,1, int(!is_multiplayer_authority()))
