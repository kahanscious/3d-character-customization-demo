extends Control

@onready
var skin_color_picker: ColorPickerButton = $MarginContainer/ScrollContainer/VBoxContainer/SkinColorSection/SkinColorPicker
@onready
var hair_color_picker: ColorPickerButton = $MarginContainer/ScrollContainer/VBoxContainer/HairSection/HairColorPicker
@onready
var hair_style_option: OptionButton = $MarginContainer/ScrollContainer/VBoxContainer/HairSection/HairStyleOption
@onready
var t_shirt_color_picker: ColorPickerButton = $MarginContainer/ScrollContainer/VBoxContainer/TShirtSection/TShirtColorPicker
@onready
var sneakers_color_picker: ColorPickerButton = $MarginContainer/ScrollContainer/VBoxContainer/SneakersSection/SneakersColorPicker
@onready
var t_shirt_toggle: CheckButton = $MarginContainer/ScrollContainer/VBoxContainer/TShirtSection/HBoxContainer/TShirtToggle
@onready
var sneakers_toggle: CheckButton = $MarginContainer/ScrollContainer/VBoxContainer/SneakersSection/HBoxContainer/SneakersToggle
@onready
var zoom_slider: HSlider = $MarginContainer/ScrollContainer/VBoxContainer/ZoomSection/ZoomSlider
@onready
var randomize_button: Button = $MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/RandomizeButton
@onready
var reset_button: Button = $MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/ResetButton
@onready
var jeans_color_picker: ColorPickerButton = $MarginContainer/ScrollContainer/VBoxContainer/JeansSection/JeansColorPicker


func _ready() -> void:
	_setup_options()
	CustomizationManager.customization_updated.connect(_update_ui_from_data)
	_update_ui_from_data()


func _setup_options():
	hair_style_option.clear()
	hair_style_option.add_item("Bald", CharacterData.HairStyle.BALD)
	hair_style_option.add_item("Short Hair", CharacterData.HairStyle.SHORT)

	var data = CustomizationManager.character_data
	skin_color_picker.color = data.skin_color
	hair_color_picker.color = data.hair_color
	t_shirt_color_picker.color = data.tshirt_color
	jeans_color_picker.color = data.jeans_color
	sneakers_color_picker.color = data.sneakers_color

	sneakers_toggle.button_pressed = data.sneakers_visible
	t_shirt_toggle.button_pressed = data.tshirt_visible


func _update_ui_from_data():
	var data = CustomizationManager.character_data

	skin_color_picker.color = data.skin_color
	hair_color_picker.color = data.hair_color
	t_shirt_color_picker.color = data.tshirt_color
	jeans_color_picker.color = data.jeans_color
	sneakers_color_picker.color = data.sneakers_color

	t_shirt_toggle.button_pressed = data.tshirt_visible
	sneakers_toggle.button_pressed = data.sneakers_visible

	for i in hair_style_option.item_count:
		if hair_style_option.get_item_id(i) == data.selected_hair:
			hair_style_option.select(i)
			break


func _on_skin_color_picker_color_changed(color: Color) -> void:
	CustomizationManager.update_color(CharacterData.BodyPart.BASE, color)


func _on_hair_color_picker_color_changed(color: Color) -> void:
	CustomizationManager.update_color(CharacterData.BodyPart.HAIR, color)


func _on_t_shirt_color_picker_color_changed(color: Color) -> void:
	CustomizationManager.update_color(CharacterData.BodyPart.TSHIRT, color)


func _on_hair_style_option_item_selected(index: int) -> void:
	var style_id = hair_style_option.get_item_id(index)
	CustomizationManager.update_part(CharacterData.BodyPart.HAIR, style_id)


func _on_t_shirt_toggle_toggled(toggled_on: bool) -> void:
	CustomizationManager.character_data.tshirt_visible = toggled_on
	CustomizationManager.customization_updated.emit()


func _on_randomize_button_pressed() -> void:
	CustomizationManager.randomize_character()


func _on_reset_button_pressed() -> void:
	CustomizationManager.reset_character()


func _on_sneakers_toggle_toggled(toggled_on: bool) -> void:
	CustomizationManager.character_data.sneakers_visible = toggled_on
	CustomizationManager.customization_updated.emit()


func _on_jeans_color_picker_color_changed(color: Color) -> void:
	CustomizationManager.update_color(CharacterData.BodyPart.JEANS, color)


func _on_sneakers_color_picker_color_changed(color: Color) -> void:
	CustomizationManager.update_color(CharacterData.BodyPart.SNEAKERS, color)


func _on_zoom_slider_value_changed(value: float) -> void:
	var camera = get_tree().get_first_node_in_group("main_camera")
	if camera:
		camera.set_zoom(value)
