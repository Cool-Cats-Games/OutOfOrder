extends Node2D

var lines = []

var lineSeparation = 15.0

func add_entry(text1,text2,text3,number,priority=0):
	var newLine = $Template.duplicate()
	self.add_child(newLine)
	newLine.visible=true
	lines.push_front(newLine)
	newLine.get_node("Description").text = "[left]"+text1+"[/left]"
	newLine.get_node("Score").text = "[left]"+text2+"[/left]"
	newLine.get_node("Count").text = "[right]x"+text3+"[/right]"
	
	update_line_positions()

func clear_lines():
	for line in lines:
		line.queue_free()
	lines = []

func change_priority(index,newPriority):
	pass

func remove_entry(index):
	pass

func find_entry(text):
	pass

func update_line_positions():
	var index = 0
	for line in lines:
		line.position = Vector2(0,0) + (Vector2(0,1) * lineSeparation + Vector2(0,10))* index
		index += 1
