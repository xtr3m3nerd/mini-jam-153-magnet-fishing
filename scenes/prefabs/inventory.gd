extends Node

class_name Inventory

signal item_added(item)
signal item_removed(item)

var items = []
var weight : float = 0.0

func add_item(item):
	items.append(item)
	item_added.emit(item)

func remove_item(item):
	items.erase(item)
	item_removed.emit(item)
