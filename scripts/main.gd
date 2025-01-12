extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var character: CharacterBody3D = $Character3D


func _ready() -> void:
	# Position the character at origin
	character.position = Vector3.ZERO

	# Set up camera for full body view
	camera.position = Vector3(0, 1.6, 2.0)
	camera.look_at(Vector3(0, 0.9, 0))  # Look at middle of body instead of head

	# Optional: Add subtle camera animation
	var tween = create_tween()
	tween.set_loops()  # Make it continuous
	tween.tween_property(camera, "position:x", 0.1, 3.0)
	tween.tween_property(camera, "position:x", -0.1, 3.0)


func _process(_delta: float) -> void:
	# Keep camera looking at character's center
	camera.look_at(Vector3(0, 0.9, 0))
