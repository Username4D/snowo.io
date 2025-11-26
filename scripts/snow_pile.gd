extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$reload.visible = true
		body.can_reload = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		$reload.visible = false
		body.can_reload = false
