# customization_panel_3d.gd
extends Control

@onready
var skin_color_picker := $MarginContainer/ScrollContainer/VBoxContainer/SkinColorSection/SkinColorPicker
@onready
var hair_style_option := $MarginContainer/ScrollContainer/VBoxContainer/HairSection/HairStyleOption
@onready
var hair_color_picker := $MarginContainer/ScrollContainer/VBoxContainer/HairSection/HairColorPicker
@onready
var tshirt_color_picker := $MarginContainer/ScrollContainer/VBoxContainer/TShirtSection/TShirtColorPicker
@onready
var jeans_color_picker := $MarginContainer/ScrollContainer/VBoxContainer/JeansSection/JeansColorPicker
@onready
var sneakers_color_picker := $MarginContainer/ScrollContainer/VBoxContainer/SneakersSection/SneakersColorPicker
@onready
var tshirt_toggle := $MarginContainer/ScrollContainer/VBoxContainer/TShirtSection/HBoxContainer/TShirtToggle
@onready
var sneakers_toggle := $MarginContainer/ScrollContainer/VBoxContainer/SneakersSection/HBoxContainer/SneakersToggle
@onready
var randomize_button := $MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/RandomizeButton
@onready var reset_button := $MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/ResetButton
@onready var zoom_slider := $MarginContainer/ScrollContainer/VBoxContainer/ZoomSection/ZoomSlider


func _ready() -> void:
	_setup_options()
	_connect_signals()
	_update_ui_from_data()


func _setup_options() -> void:
	# Setup hair styles
	hair_style_option.clear()
	hair_style_option.add_item("Bald", CharacterData3D.HairStyle.BALD)
	hair_style_option.add_item("Short Hair", CharacterData3D.HairStyle.SHORT)

	# Set initial colors from data
	var data = CustomizationManager3D.character_data
	skin_color_picker.color = data.skin_color
	hair_color_picker.color = data.hair_color
	tshirt_color_picker.color = data.tshirt_color
	jeans_color_picker.color = data.jeans_color
	sneakers_color_picker.color = data.sneakers_color

	# Set initial toggle states
	tshirt_toggle.button_pressed = data.tshirt_visible
	sneakers_toggle.button_pressed = data.sneakers_visible


func _connect_signals() -> void:
	# Color change signals
	skin_color_picker.color_changed.connect(_on_skin_color_changed)
	hair_color_picker.color_changed.connect(_on_hair_color_changed)
	tshirt_color_picker.color_changed.connect(_on_tshirt_color_changed)
	jeans_color_picker.color_changed.connect(_on_jeans_color_changed)
	sneakers_color_picker.color_changed.connect(_on_sneakers_color_changed)

	# Style selection signals
	hair_style_option.item_selected.connect(_on_hair_style_selected)

	# Clothing visibility signals
	tshirt_toggle.toggled.connect(_on_tshirt_toggled)
	sneakers_toggle.toggled.connect(_on_sneakers_toggled)

	# Control button signals
	randomize_button.pressed.connect(_on_randomize_pressed)
	reset_button.pressed.connect(_on_reset_pressed)

	# Camera zoom signal
	zoom_slider.value_changed.connect(_on_zoom_changed)

	# Listen for customization updates
	CustomizationManager3D.customization_updated.connect(_update_ui_from_data)


func _on_skin_color_changed(color: Color) -> void:
	CustomizationManager3D.update_color(CharacterData3D.BodyPart.BASE, color)


func _on_hair_color_changed(color: Color) -> void:
	CustomizationManager3D.update_color(CharacterData3D.BodyPart.HAIR, color)


func _on_tshirt_color_changed(color: Color) -> void:
	CustomizationManager3D.update_color(CharacterData3D.BodyPart.TSHIRT, color)


func _on_jeans_color_changed(color: Color) -> void:
	CustomizationManager3D.update_color(CharacterData3D.BodyPart.JEANS, color)


func _on_sneakers_color_changed(color: Color) -> void:
	CustomizationManager3D.update_color(CharacterData3D.BodyPart.SNEAKERS, color)


func _on_hair_style_selected(index: int) -> void:
	var style_id = hair_style_option.get_item_id(index)
	CustomizationManager3D.update_part(CharacterData3D.BodyPart.HAIR, style_id)


func _on_tshirt_toggled(button_pressed: bool) -> void:
	CustomizationManager3D.character_data.tshirt_visible = button_pressed
	CustomizationManager3D.customization_updated.emit()


func _on_sneakers_toggled(button_pressed: bool) -> void:
	CustomizationManager3D.character_data.sneakers_visible = button_pressed
	CustomizationManager3D.customization_updated.emit()


func _on_randomize_pressed() -> void:
	CustomizationManager3D.randomize_character()


func _on_reset_pressed() -> void:
	CustomizationManager3D.reset_character()


func _on_zoom_changed(value: float) -> void:
	var camera = get_tree().get_first_node_in_group("main_camera")
	if camera:
		camera.set_zoom(value)


func _update_ui_from_data() -> void:
	var data = CustomizationManager3D.character_data

	# Update colors
	skin_color_picker.color = data.skin_color
	hair_color_picker.color = data.hair_color
	tshirt_color_picker.color = data.tshirt_color
	jeans_color_picker.color = data.jeans_color
	sneakers_color_picker.color = data.sneakers_color

	# Update toggles
	tshirt_toggle.button_pressed = data.tshirt_visible
	sneakers_toggle.button_pressed = data.sneakers_visible

	# Update hair style selection
	for i in hair_style_option.item_count:
		if hair_style_option.get_item_id(i) == data.selected_hair:
			hair_style_option.select(i)
			break
