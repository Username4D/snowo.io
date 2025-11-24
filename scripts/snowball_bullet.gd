extends RigidBody3D


func _on_body_entered(body: Node) -> void:
	self.linear_velocity = Vector3.ZERO
	self.angular_velocity = Vector3.ZERO
	self.process_mode = Node.PROCESS_MODE_DISABLED
	
