# character_3d.gd
extends CharacterBody3D

# Node references
@onready var character_container: Node3D = $CharacterContainer
@onready var character_model: Node3D = $CharacterContainer/CharacterModel

# Material arrays for each customizable part
var skin_materials: Array[BaseMaterial3D] = []
var hair_materials: Array[BaseMaterial3D] = []
var tshirt_materials: Array[BaseMaterial3D] = []
var jeans_materials: Array[BaseMaterial3D] = []
var sneakers_materials: Array[BaseMaterial3D] = []
var iris_materials: Array[BaseMaterial3D] = []  # Only for the colored part of the eye

# Mesh references for visibility control
var tshirt_mesh: MeshInstance3D
var jeans_mesh: MeshInstance3D
var sneakers_mesh: MeshInstance3D
var hair_mesh: MeshInstance3D

# Constants for mesh names
const HAIR_MESH_NAME = "Classic_short"


func _ready() -> void:
	character_container.add_to_group("character_container")
	_cache_materials()
	_connect_signals()
	_update_from_data()


func _cache_materials() -> void:
	print("\n=== Starting Material Cache ===")
	for child in character_model.find_children("*", "MeshInstance3D"):
		if "Eye" in child.name or "Cornea" in child.name:
			print("\nFound eye-related mesh: ", child.name)
			print("Path: ", child.get_path())
			var mesh := child as MeshInstance3D
			if mesh and mesh.mesh:
				print("Surface count: ", mesh.mesh.get_surface_count())
				for i in range(mesh.mesh.get_surface_count()):
					var mat = mesh.get_active_material(i)
					if mat:
						print("Surface ", i, " material: ", mat.resource_name)
	for child in character_model.find_children("*", "MeshInstance3D"):
		var mesh := child as MeshInstance3D
		if not mesh or not mesh.mesh:
			continue

		var surface_count: int = mesh.mesh.get_surface_count()
		print("\nMesh: %s, Surfaces: %s" % [child.name, surface_count])

		# Handle eye-related meshes first
		if child.name == "CC_Base_Eye" or child.name.begins_with("Std_Cornea"):
			print("Processing eye mesh: %s" % child.name)
			for surface_idx in range(surface_count):
				var material = mesh.get_active_material(surface_idx)
				if material and material is StandardMaterial3D:
					var unique_material := material.duplicate() as StandardMaterial3D
					child.set_surface_override_material(surface_idx, unique_material)

					print("Material name: %s" % material.resource_name)

					# Handle iris materials
					if (
						material.resource_name.contains("Eye")
						and not material.resource_name.contains("Occlusion")
					):
						print("Adding iris material")
						iris_materials.append(unique_material)
						_setup_iris_material(unique_material)

					# Handle cornea materials
					elif material.resource_name.contains("Cornea"):
						print("Setting up cornea material")
						_setup_cornea_material(unique_material)
			continue

		# Regular material processing for other meshes
		for surface_idx in range(surface_count):
			var material = mesh.get_active_material(surface_idx)
			if material and material is StandardMaterial3D:
				var unique_material := material.duplicate() as StandardMaterial3D

				match child.name:
					"CC_Base_Body":
						child.set_surface_override_material(surface_idx, unique_material)
						skin_materials.append(unique_material)
					HAIR_MESH_NAME:
						child.set_surface_override_material(surface_idx, unique_material)
						hair_materials.append(unique_material)
						hair_mesh = child
					"Basic_T_shirts":
						child.set_surface_override_material(surface_idx, unique_material)
						tshirt_materials.append(unique_material)
						tshirt_mesh = child
					"Slim_Jeans":
						child.set_surface_override_material(surface_idx, unique_material)
						jeans_materials.append(unique_material)
						jeans_mesh = child
					"Sport_sneakers":
						child.set_surface_override_material(surface_idx, unique_material)
						sneakers_materials.append(unique_material)
						sneakers_mesh = child


func _setup_iris_material(material: StandardMaterial3D) -> void:
	material.metallic = 0.1
	material.roughness = 0.2
	material.clearcoat = 0.5
	material.clearcoat_roughness = 0.1
	material.refraction_enabled = false
	material.backlight = Color(0.1, 0.1, 0.1)
	material.rim = 0.2
	material.rim_tint = 0.5
	material.cull_mode = BaseMaterial3D.CULL_BACK


func _setup_cornea_material(material: StandardMaterial3D) -> void:
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(1, 1, 1, 0.5)
	material.metallic = 0.1
	material.roughness = 0.0
	material.clearcoat = 1.0
	material.clearcoat_roughness = 0.0
	material.refraction_enabled = true
	material.refraction_scale = 0.05
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_ALWAYS


func _connect_signals() -> void:
	if not CustomizationManager3D.color_updated.is_connected(_on_color_updated):
		CustomizationManager3D.color_updated.connect(_on_color_updated)
	if not CustomizationManager3D.customization_updated.is_connected(_on_customization_updated):
		CustomizationManager3D.customization_updated.connect(_on_customization_updated)


func _update_from_data() -> void:
	var data = CustomizationManager3D.character_data
	_update_skin_color(data.skin_color)
	_update_eye_color(data.eye_color)
	_update_hair_color(data.hair_color)
	_update_tshirt_color(data.tshirt_color)
	_update_jeans_color(data.jeans_color)
	_update_sneakers_color(data.sneakers_color)
	_update_hair_visibility(data.selected_hair)
	_update_clothing_visibility(data)


func _on_color_updated(part: CharacterData3D.BodyPart, color: Color) -> void:
	match part:
		CharacterData3D.BodyPart.BASE:
			_update_skin_color(color)
		CharacterData3D.BodyPart.EYES:
			_update_eye_color(color)
		CharacterData3D.BodyPart.HAIR:
			_update_hair_color(color)
		CharacterData3D.BodyPart.TSHIRT:
			_update_tshirt_color(color)
		CharacterData3D.BodyPart.JEANS:
			_update_jeans_color(color)
		CharacterData3D.BodyPart.SNEAKERS:
			_update_sneakers_color(color)


func _update_skin_color(color: Color) -> void:
	for material in skin_materials:
		material.albedo_color = color


func _update_eye_color(color: Color) -> void:
	for material in iris_materials:
		material.albedo_color = color
		material.roughness = 0.1  # Makes eyes slightly glossy
		material.metallic = 0.1  # Adds subtle reflection


func _update_hair_color(color: Color) -> void:
	for material in hair_materials:
		material.albedo_color = color
		material.roughness = 0.7
		material.metallic = 0.3


func _update_tshirt_color(color: Color) -> void:
	for material in tshirt_materials:
		material.albedo_color = color


func _update_jeans_color(color: Color) -> void:
	for material in jeans_materials:
		material.albedo_color = color


func _update_sneakers_color(color: Color) -> void:
	for material in sneakers_materials:
		material.albedo_color = color


func _update_hair_visibility(selected_hair: CharacterData3D.HairStyle) -> void:
	if hair_mesh:
		hair_mesh.visible = selected_hair == CharacterData3D.HairStyle.SHORT


func _update_clothing_visibility(data: CharacterData3D) -> void:
	if tshirt_mesh:
		tshirt_mesh.visible = data.tshirt_visible
	if sneakers_mesh:
		sneakers_mesh.visible = data.sneakers_visible


func _on_customization_updated() -> void:
	_update_from_data()
