from kittens.tui.handler import result_handler

def main(args):
	pass

@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
	tab = boss.active_tab
	if tab is not None:
		if tab.current_layout.name == "stack":
			tab.last_used_layout()
			tab.current_layout.must_draw_borders = False
			tab.relayout()
		else:
			try:
				tab.goto_layout("stack")
				tab.current_layout.must_draw_borders = True
				tab.relayout()
			except Exception:
				pass
