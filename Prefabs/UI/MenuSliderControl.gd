@tool
extends HBoxContainer

signal value_changed;
signal label_changed;

@export var value: float:
	set(val):
		value = val
		$Slider.value = clamp(value * 100, 0,100)
		$Value.text = str(floor(100 * value)) + "%"
		emit_signal( "value_changed", value )
	get:
		return value

@export var label: String: 
	set(str):
		label = str
		$Label.text = str
		emit_signal( "label_changed", str)
	get:
		return label


func _on_slider_value_changed(value):
	self.value = $Slider.value / 100
