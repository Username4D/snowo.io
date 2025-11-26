extends Node2D

func _process(delta: float) -> void:
	$ammo.text = "AMMO: " + var_to_str(self.get_parent().ammo)
