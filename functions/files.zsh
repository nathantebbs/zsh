function files {
	local selected_file=$(find . -type f | fzf)
	if [[ -n $selected_file ]]; then
		vim "$selected_file"
	fi
}

