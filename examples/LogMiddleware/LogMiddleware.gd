static func middleware(store, action):
  '''
  logs the previous state as well as the action type that
  was invoked
  '''
	print("####ACTION: ", action.type)
	print("PREV STATE ", store.get_state())
	return action