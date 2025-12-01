extends CharacterBody3D

var sensitivity = 0.001
var speed = 4

var can_shoot = true
var ammo = 6

var d_bullet = preload("res://scenes/snowball_bullet_decoy.tscn")
var r_bullet = preload("res://scenes/snowball_bullet.tscn")

@export var active = true
var paused = false
@export var can_reload = false

@export var team = "none"

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	respawn()
	respawn.rpc( )
	if !is_multiplayer_authority(): return
	await game_server_handler_class.game_server_handler.get_node("MultiplayerSynchronizer").synchronized
	if game_server_handler_class.game_server_handler.match_state == "win_red":
		win("red")
	elif game_server_handler_class.game_server_handler.match_state == "win_blue":
		win("blue")
	else:
		print(game_server_handler_class.game_server_handler.match_state)
func _input(event: InputEvent) -> void:
	
	if !is_multiplayer_authority():
		return
	
	if Input.is_action_just_pressed("esc") and active:
		if paused: close_menu() 
		else: open_menu()
	
	
	if !active: return
	if paused: return
	if event is InputEventMouseMotion:
		self.rotation.y += -event.relative.x * sensitivity
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x - event.relative.y * sensitivity,- 1, 1 )
	
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		self.velocity.y = 5
	
	if Input.is_action_just_pressed("shoot") and can_shoot and ammo > 0:
		
		can_shoot = false
		start_shot()
	
	if Input.is_action_just_pressed("reload") and can_reload:
		ammo = 6
func _physics_process(delta: float) -> void:
	
	if !is_multiplayer_authority(): return
	if !active: return
	if velocity.x != 0 or velocity.z != 0:
		$AuxScene/AnimationPlayer.current_animation = "Running(2)_1"

	else:
		$AuxScene/AnimationPlayer.current_animation = "Idle(1)_2"

	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") if !paused else Vector2.ZERO
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
	
	shoot.rpc(int(self.name), drag, $Camera3D/snowball_start.global_position - ease(drag, 3) * ($Camera3D/snowball_start.global_position - $Camera3D/snowball_back.global_position), ease(drag, 3) * ($Camera3D/snowball_start.global_position - $Camera3D/snowball_back.global_position) * 25)
	shoot(int(self.name), drag, $Camera3D/snowball_start.global_position - ease(drag, 3) * ($Camera3D/snowball_start.global_position - $Camera3D/snowball_back.global_position), ease(drag, 3) * ($Camera3D/snowball_start.global_position - $Camera3D/snowball_back.global_position) * 25)
	bullet.queue_free()
	ammo -= 1
	await get_tree().create_timer(.05)
	can_shoot = true
func _ready() -> void:
	if !is_multiplayer_authority(): return
	$Camera3D.current = true
	close_menu()
	await get_tree().process_frame
	game_server_handler_class.game_server_handler.win.connect(win)
@rpc("any_peer") func shoot(origin, drag, nposition, impulse):
	var bullet = r_bullet.instantiate()
	bullet.global_position = nposition
	bullet.origin = origin
	self.get_parent().add_child(bullet)
	bullet.apply_central_impulse(impulse)
func _process(delta: float) -> void:
	$AuxScene/Node/Skeleton3D/Cube.get_surface_override_material(0).albedo_color = Color(1,0,0, int(!is_multiplayer_authority())) if team == "red" else Color(0,0,1, int(!is_multiplayer_authority()))
	$hud.visible = is_multiplayer_authority()
func die():
	$AuxScene.visible = false
	if !is_multiplayer_authority(): return
	print("death registred")
	active = false
	$deathscreen.pop_up()
@rpc("any_peer") func respawn():
	$AuxScene.visible = true
	if !is_multiplayer_authority(): return
	ammo = 6
	active = true
	self.position = self.get_parent().get_node("spawn_points_red").get_children()[randi_range(0,11)].position
func win(team):
	close_menu()
	$deathscreen.visible = false
	print("win_triggered")
	print(game_server_handler_class.game_server_handler.match_state)
	$win_screen.pop_up(team)
	active = false
	await game_server_handler_class.game_server_handler.restart
	active = true
	respawn()
func open_menu():
	paused = true
	$pause_menu.visible = true
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
func close_menu():
	paused = false
	$pause_menu.visible = false
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
