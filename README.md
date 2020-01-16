# gredux

[Redux](https://redux.js.org/) inspired addon for state management in Godot.

Similar to modern websites, games need to manage large, ever changing states. This libraries brings Redux to godot in an attempt to make state mutations predictable. By persisting the state of your game in one location you also get certain features for (almost) free, such as **time travel** (undo/redo) and **saving/loading** saved games.

## Adding to a Godot project

We recommend cloning this repository inside an `addons` folder within your godot project.

## Usage

With the files added you can create a redux store as shown below:

```gd
extends Node

const GRedux = preload("res://addons/gredux/gredux.gd")
const CounterContext = preload("res://redux/CounterContext.gd")

var initial_state = {
	"todos": []
}

var reducers = {
	"todos": funcref(CounterContext, "reducer")
}

var Store

func _ready():
	Store = GRedux.new(reducers, initial_state)

	Store.dispatch(CounterContext.add_todo("hello world"))

```

`CounterContext` in the example above contains both a reducer and its actions.

```
extends Node

const ADD_TODO = "ADD_TODO"

static func add_todo(name):
	return {
		"type": ADD_TODO,
		"name": name
	}

static func reducer(state, action):
	if action["type"] == ADD_TODO:
		var next_state = shallow_copy(state)
		next_state.append(action["date"])
		return next_state

	return state

```

### Middlewares

The third argument to `GRedux.new()` is a middleware array. A middleware in this library works slightly differently than in redux. They still have access to the `store` and will execute one after the other before the reducers are invoked, but do not invoke the `next` middleware themselves. You can still use a middleware to transform the action perform side effects or call new actions.

You can find more usages in the examples folder.

## License

[MIT](https://github.com/au-re/gredux/blob/master/LICENSE)
