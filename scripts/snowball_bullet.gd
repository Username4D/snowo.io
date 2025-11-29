extends RigidBody3D

@export var origin = 0

func _on_body_entered(body: Node) -> void:
	if !body.is_in_group("player"):
		self.linear_velocity = Vector3.ZERO
		self.angular_velocity = Vector3.ZERO
		await get_tree().physics_frame
		self.process_mode = Node.PROCESS_MODE_DISABLED
	elif origin != int(body.name):
		body.die()
