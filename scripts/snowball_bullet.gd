extends RigidBody3D

@export var origin = 0

func _on_body_entered(body: Node) -> void:
	self.linear_velocity = Vector3.ZERO
	self.angular_velocity = Vector3.ZERO
	self.call_deferred("set_physics_process",false)
