extends Node3D

@onready var character: CharacterBody3D = $Character
@onready var camera: Camera3D = $Camera3D


func _ready() -> void:
	character.position = Vector3.ZERO

	camera.position = Vector3(0, 1.6, 2.0)
	camera.look_at(Vector3(0, 0.9, 0))

	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(camera, "position:x", 0.1, 3.0)
	tween.tween_property(camera, "position:x", -0.1, 3.0)
