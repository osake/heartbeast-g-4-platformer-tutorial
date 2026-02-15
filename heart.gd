extends Area2D


func _on_body_entered(body: Node2D) -> void:
	queue_free()
	# how many hearts are left?
	var hearts = get_tree().get_nodes_in_group("Hearts")
	print("Length: " + str(len(hearts)) + ", Size: " + str(hearts.size()))
	# the counter won't hit zero, so 1 is the last heart collected
	if hearts.size() == 1:
		Events.level_completed.emit()
		print("Level completed!")
