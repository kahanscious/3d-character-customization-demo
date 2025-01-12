# customization_manager.gd
extends Node

signal color_updated(part: CharacterData3D.BodyPart, color: Color)
signal customization_updated

var character_data: CharacterData3D


func _ready() -> void:
	character_data = CharacterData3D.new()


func update_color(part: CharacterData3D.BodyPart, color: Color) -> void:
	match part:
		CharacterData3D.BodyPart.BASE:
			character_data.skin_color = color
		CharacterData3D.BodyPart.HAIR:
			character_data.hair_color = color
		CharacterData3D.BodyPart.TSHIRT:
			character_data.tshirt_color = color
		CharacterData3D.BodyPart.JEANS:
			character_data.jeans_color = color
		CharacterData3D.BodyPart.SNEAKERS:
			character_data.sneakers_color = color

	color_updated.emit(part, color)
	customization_updated.emit()


func reset_character() -> void:
	character_data = CharacterData3D.new()  # Create fresh instance with default values
	customization_updated.emit()


func randomize_character() -> void:
	# Randomize skin
	character_data.skin_color = Color(
		randf_range(0.5, 1.0), randf_range(0.4, 0.9), randf_range(0.3, 0.8), 1.0
	)

	# Randomize hair
	character_data.hair_color = Color(
		randf_range(0.1, 0.8), randf_range(0.1, 0.8), randf_range(0.1, 0.8), 1.0
	)

	# Randomize clothing colors
	character_data.tshirt_color = Color(
		randf_range(0.2, 1.0), randf_range(0.2, 1.0), randf_range(0.2, 1.0), 1.0
	)
	character_data.jeans_color = Color(
		randf_range(0.2, 1.0), randf_range(0.2, 1.0), randf_range(0.2, 1.0), 1.0
	)
	character_data.sneakers_color = Color(
		randf_range(0.2, 1.0), randf_range(0.2, 1.0), randf_range(0.2, 1.0), 1.0
	)

	# Randomize hair style
	character_data.selected_hair = randi() % CharacterData3D.HairStyle.values().size()

	# Randomize visibility
	character_data.tshirt_visible = true
	character_data.sneakers_visible = true if randf() > 0.5 else false

	customization_updated.emit()


func update_part(part: CharacterData3D.BodyPart, index: int) -> void:
	match part:
		CharacterData3D.BodyPart.HAIR:
			character_data.selected_hair = index
	customization_updated.emit()
