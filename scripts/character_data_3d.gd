# character_data_3d.gd
class_name CharacterData3D extends Resource

enum BodyPart { BASE, HAIR, TSHIRT, JEANS, SNEAKERS }
enum HairStyle { BALD = 0, SHORT = 1 }

# Base appearance
@export var skin_color: Color = Color(0.98, 0.84, 0.65, 1.0)

# Hair properties
@export var hair_color: Color = Color(0.35, 0.25, 0.15, 1.0)
@export var selected_hair: HairStyle = HairStyle.BALD

# Individual clothing colors
@export var tshirt_color: Color = Color(1, 1, 1, 1)
@export var jeans_color: Color = Color(0.2, 0.3, 0.8, 1)
@export var sneakers_color: Color = Color(0.8, 0.8, 0.8, 1)

# Visibility flags for each piece
@export var tshirt_visible: bool = true
@export var sneakers_visible: bool = false
