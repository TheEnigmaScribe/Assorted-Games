extends StaticBody2D

signal player_entered_gate()

func _on_area_2d_area_entered(area: Area2D) -> void:
	player_entered_gate.emit()
