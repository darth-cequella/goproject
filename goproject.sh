#!/bin/bash

function commandNotFound {
	echo ""
	echo "	Unavailable command. If you need help read the 'goproject --help'."
	echo ""
}
function helpScreen {
	echo "GoProject, versão 1.0.0-RC1"
	echo "This commands of GoProject was defined internally. Type 'goproject help' to see this page."
	echo "Type 'goproject help FUNCTION' to understand more about FUNCTION."
	echo ""
	echo "	goproject [OPTIONS] VALUES"
	echo ""
	echo "	--help 			-h 			Open this page."
	echo "	--workspace					Show the current workspace directory."
	echo "	--change-workspace			Change current Workspace."
	echo "	--reset-workspace			Clear the reference to the Workspace (doesn't affect the directories or files)."
}
function checkGoPath {	
	read -p "You need to set a GOPATH directory as Go workspace: (default $HOME/Go) " gopath

	if [[ $gopath == '' ]]; then
		mkdir -p "$HOME/Go"
		mkdir -p "$HOME/Go/src"
		mkdir -p "$HOME/Go/bin"
		mkdir -p "$HOME/Go/pkg"
		export GOPATH=$HOME/Go
		echo ""
		echo "Workspace sucessfullly created!"
		echo "Check under $HOME/Go"
		echo ""
	else
		mkdir -p "$HOME/$gopath"
		mkdir -p "$HOME/$gopath/src"
		mkdir -p "$HOME/$gopath/bin"
		mkdir -p "$HOME/$gopath/pkg"
		export GOPATH=$HOME/$gopath
		echo ""
		echo "Workspace sucessfullly created!"
		echo "Check under $HOME/$gopath"
		echo ""
	fi
}
function showWorkspaceName {
	echo ""
	echo "	Your current workspace is at: $GOPATH"
	echo "	Use 'goproject change-workspace' if you like to change the current workspace directory,"
	echo "	or 'goproject reset-workspace' if you like to remove the reference to the workspace directory (doesn't affect directory/files)"
	echo ""
}
function changeWorkspace {	
	echo ""
	read -p "You need to set a GOPATH directory as Go workspace: (default $HOME/Go) " gopath

	if [[ $gopath == '' ]]; then
		mkdir -p "$HOME/Go"
		mkdir -p "$HOME/Go/src"
		mkdir -p "$HOME/Go/bin"
		mkdir -p "$HOME/Go/pkg"
		export GOPATH=$HOME/Go
		echo ""
		echo "	Workspace sucessfullly changed!"
		echo "	Check under $HOME/Go"
		echo ""
	else
		mkdir -p "$HOME/$gopath"
		mkdir -p "$HOME/$gopath/src"
		mkdir -p "$HOME/$gopath/bin"
		mkdir -p "$HOME/$gopath/pkg"
		export GOPATH=$HOME/$gopath
		echo ""
		echo "	Workspace sucessfullly changed!"
		echo "	Check under $HOME/$gopath"
		echo ""
	fi
}
function resetWorkspace {	
	export GOPATH=
	echo ""
	echo "	Now you don't have any workspace. "
	echo "	If you want to develop in Go you will need a workspace."
	echo "	Use 'goproject change-workspace' to create a new directory or to set some directory that already exists."
	echo ""
}
function createNewProject {
	if [[ $# -eq 0 ]]; then
		echo ""
		echo "	type correctly: goproject new PROJECT_NAME"
		echo ""
	else
		mkdir -p $GOPATH/src/$1
		echo 'package main' > $GOPATH/src/$1/main.go
		echo ""
		echo "	Project '$1' created!"
		echo "	Start editing: $GOPATH/usr/$1/main.go"
		echo ""
	fi
}

##---------------------------------- MAIN CODE

if [[ $# -eq 0 ]]; then
	
	helpScreen

else

	if [[ -z $GOPATH ]]; then
		checkGoPath
	else

		case $1 in
			workspace )
				showWorkspaceName
				;;
			change-workspace)
				changeWorkspace
				;;
			reset-workspace)
				resetWorkspace
				;;
			new)
				createNewProject $2
				;;
			*)
				commandNotFound
				;;
		esac

	fi

fi
