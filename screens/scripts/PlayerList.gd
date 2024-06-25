extends VBoxContainer


func add_player(name):
	var label = Label.new()
	label.text = name
	add_child(label)
	
func remove_player(index):
	get_child(index).queue_free()
	
func remove_all():
	for child in get_children():
		child.queue_free()
