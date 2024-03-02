extends Node

class_name Inventory

signal item_added(item: Pickup)
signal item_removed(item: Pickup)

var items: Array[Pickup] = []
var weight : float = 0.0

func add_item(item: Pickup):
	items.append(item)
	item_added.emit(item)

func remove_item(item: Pickup):
	items.erase(item)
	item_removed.emit(item)
