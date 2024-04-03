@tool
extends HBoxContainer

signal value_changed;
signal label_changed;

@export var value: float:
	set(val):
		value = val;
		var clamped = floor(100 * val);
		if $Slider.value != clamped:
			$Slider.value = clamped;
		$Value.text = str(floor(100 * val)) + "%";
		emit_signal( "value_changed", value );
	get:
		return value;

@export var label: String: 
	set(str):
		label = str;
		$Label.text = str;
		emit_signal( "label_changed", str)
	get:
		return label;


func _on_slider_value_changed(value):
	self.value = $Slider.value / 100;
