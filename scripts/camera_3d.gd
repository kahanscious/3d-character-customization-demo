# camera_3d.gd
extends Camera3D

var target_position := Vector3(0, 0.9, 0)
var dragging := false
var drag_start_position := Vector2()
var current_zoom := 2.5  # Match the slider's default value


func _ready() -> void:
	near = 0.01
	far = 100.0
	_update_camera_position()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_start_position = event.position
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		var drag_delta = event.position - drag_start_position
		var horizontal_rotation = deg_to_rad(drag_delta.x * 0.5)

		var character = get_tree().get_first_node_in_group("character_container")
		if character:
			character.rotate_y(horizontal_rotation)

		drag_start_position = event.position


func set_zoom(value: float) -> void:
	current_zoom = value
	_update_camera_position()


func _update_camera_position() -> void:
	position = Vector3(0, target_position.y + 0.7, 5.0 - current_zoom)
	look_at(target_position)
