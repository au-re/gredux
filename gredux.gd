# ##############
# gredux: Redux inspired addon for state management in Godot.
# Copyright © 2020 Aurélien Franky and contributors - MIT License
# ##############

extends Node

var ActionTypes = {
	"INIT": "@@redux/INIT"
}

var _state = {}
var _reducers = {}
var _middlewares = []

signal store_changed(name, state)


func get_state():
	return _state


func _init(reducers, preloaded_state={}, middlewares=[]):
	"""
	initialize the store with a preloaded state
	map the reducers with their identifiers
	initialize all reducers by emitting an INIT event
	"""
	_state = preloaded_state
	_middlewares = middlewares

	for reducer in reducers:
		if not _state.has(reducer):
			_state[reducer] = {}
		if not _reducers.has(reducer):
			_reducers[reducer] = reducers[reducer]

	dispatch({ "type": ActionTypes.INIT })


func dispatch(action):
	"""
	dispatch an action, this is the only way to modify the state
	"""
	for middleware in _middlewares:
		action = middleware.call_func(self, action)
		if !action:
			return

	for reducer in _reducers:
		var next_state = _reducers[reducer].call_func(_state[reducer], action)
		if next_state == null:
			_state.erase(reducer)
			emit_signal("store_changed", reducer, null)
		elif _state[reducer] != next_state:
			_state[reducer] = next_state
			emit_signal("store_changed", reducer, next_state)


func subscribe(ref, callback):
	"""
	subscribe to changes to the state
	"""
	connect("store_changed", ref, callback)
