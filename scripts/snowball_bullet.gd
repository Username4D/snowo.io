extends RigidBody3D

@export var origin = 0

func _on_body_entered(body: Node) -> void:
	if !body.is_in_group("player"):
		self.linear_velocity = Vector3.ZERO
		self.angular_velocity = Vector3.ZERO
		await get_tree().physics_frame
		
		self.freeze = true
		death()
	elif origin != int(body.name):
		self.queue_free()
		body.die()

func death():
	$snowball_timer.start()
	await $snowball_timer.timeout
	$snowball_timer.start()
	while $snowball_timer.time_left != 0:
		await get_tree().process_frame
		$MeshInstance3D.mesh.material.albedo_color.a = $snowball_timer.time_left / 4
	self.queue_free()
