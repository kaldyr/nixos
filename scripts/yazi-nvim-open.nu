def main [file_path: path] {
	zellij action toggle-floating-panes

	let list_clients_output = (zellij action list-clients | lines | get 1)

	zellij action write 27
	zellij action write-chars $":e \"($file_path)\""
	zellij action write 13
}
