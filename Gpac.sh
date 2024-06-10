#!/bin/bash

# Function to display usage
usage() {
	echo "Usage: $0 {install|update|remove} <package_name>"
}

# Main menu
main_menu() {
	# Use Zenity question dialog with custom buttons
	local choice=$(zenity --question \
		--title="Gpac - Pacman GUI" \
		--text="Choose an action:" \
		--switch \
		--extra-button="Install Package" \
		--extra-button="Update System" \
		--extra-button="Remove Package")

	# Handle the choice made by the user
	case $choice in
	"Install Package")
		install_package
		;;
	"Update System")
		update_system
		;;
	"Remove Package")
		remove_package
		;;
	*)
		zenity --error --text="Invalid option selected."
		exit 1
		;;
	esac
}

# Function to install a package
install_package() {
	local pkg_name=$(zenity --entry --title="Install Package" --text="Enter package name:")

	if [[ -n "$pkg_name" ]]; then
		PASSWORD=$(zenity --password)
		echo $PASSWORD | sudo -S pacman -S --noconfirm "$pkg_name"
	else
		zenity --error --text="No package name entered."
	fi
}

# Function to update the system
update_system() {
	PASSWORD=$(zenity --password)
	echo $PASSWORD | sudo -S pacman -Syu --noconfirm
}

# Function to remove a package
remove_package() {
	local pkg_name=$(zenity --entry --title="Remove Package" --text="Enter package name:")

	if [[ -n "$pkg_name" ]]; then
		PASSWORD=$(zenity --password)
		echo $PASSWORD | sudo -S pacman -Rns --noconfirm "$pkg_name"
	else
		zenity --error --text="No package name entered."
	fi
}

# Check if arguments were passed
if [[ $# -eq 0 ]]; then
	main_menu
else
	usage
fi
