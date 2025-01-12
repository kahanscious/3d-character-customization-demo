extends Node

signal color_updated(part: CharacterData.BodyPart, color: Color)
signal customization_updated

var character_data: CharacterData


func _ready() -> void:
	character_data = CharacterData.new()
	customization_updated.emit()


func update_color(part: CharacterData.BodyPart, color: Color) -> void:
	match part:
		CharacterData.BodyPart.BASE:
			character_data.skin_color = color
		CharacterData.BodyPart.HAIR:
			character_data.hair_color = color
		CharacterData.BodyPart.TSHIRT:
			character_data.tshirt_color = color
		CharacterData.BodyPart.JEANS:
			character_data.jeans_color = color
		CharacterData.BodyPart.SNEAKERS:
			character_data.sneakers_color = color

	color_updated.emit(part, color)
	customization_updated.emit()


func reset_character() -> void:
	character_data = CharacterData.new()
	customization_updated.emit()


func randomize_character() -> void:
	character_data.skin_color = Color(
		randf_range(0.5, 1.0), randf_range(0.4, 0.9), randf_range(0.3, 0.8), 1.0
	)

	character_data.hair_color = Color(
		randf_range(0.1, 0.8), randf_range(0.1, 0.8), randf_range(0.1, 0.8), 1.0
	)

	character_data.tshirt_color = Color(
		randf_range(0.2, 1.0), randf_range(0.2, 1.0), randf_range(0.2, 1.0), 1.0
	)

	character_data.jeans_color = Color(
		randf_range(0.2, 1.0), randf_range(0.2, 1.0), randf_range(0.2, 1.0), 1.0
	)

	character_data.sneakers_color = Color(
		randf_range(0.2, 1.0), randf_range(0.2, 1.0), randf_range(0.2, 1.0), 1.0
	)

	character_data.selected_hair = randi_range(0, CharacterData.HairStyle.values().size() - 1)

	character_data.tshirt_visible = true
	character_data.sneakers_visible = false

	customization_updated.emit()


func update_part(part: CharacterData.BodyPart, index: int) -> void:
	match part:
		CharacterData.BodyPart.HAIR:
			character_data.selected_hair = index
	customization_updated.emit()
