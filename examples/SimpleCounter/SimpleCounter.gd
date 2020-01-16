extends Node

const GRedux = preload("res://addons/gredux/gredux.gd")

var Store

const INCREMENT = "INCREMENT"
const DECREMENT = "DECREMENT"


static func increment():
	return { "type": INCREMENT }


static func decrement():
	return { "type": DECREMENT }


static func counter(state = 0, action):
	if action["type"] == INCREMENT:
		return state + 1

	if action["type"] == DECREMENT:
		return state - 1

	return state


var initial_state = {
	counter: 0,
}

var reducers = {
	counter: funcref(self, "counter")
}


func on_store_changed(name, state):
	print(state)


func _ready():
	# Create a Redux store holding the state of your app.
	# Its API is { subscribe, dispatch, getState }.
	Store = GRedux.new(reducers, initial_state)

	# You can use subscribe() to react to state changes.
	# Our on_store_changed function will be called when the state changes, it will also receive the
	# name of the reducer that changed to allow filtering out irrelevant updates
	Store.subscribe(self, "on_store_changed")

	# The only way to mutate the internal state is to dispatch an action.
	# The actions can be serialized, logged or stored and later replayed.
	Store.dispatch(increment())
 	# 1
	Store.dispatch(increment())
	# 2
	Store.dispatch(decrement())
	# 3
