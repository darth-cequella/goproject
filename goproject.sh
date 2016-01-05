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
	if [[ -z $GOPATH ]]; then
		
		read -p "You need to set a GOPATH directory as Go workspace: (default $HOME/GoWorkspace) " gopath

		if [[ $gopath == '' ]]; then
			mkdir -p "$HOME/GoWorkspace"
			mkdir -p "$HOME/GoWorkspace/src"
			mkdir -p "$HOME/GoWorkspace/bin"
			mkdir -p "$HOME/GoWorkspace/pkg"
			export GOPATH=$HOME/GoWorkspace
			echo ""
			echo "Workspace sucessfullly created!"
			echo "Check under $HOME/GoWorkspace"
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

	fi
}
function showWorkspaceName {
	if [[ -z $GOPATH ]]; then
		echo "Yout current workspace is at: $GOPATH"
		echo "Use '' if you like to change the current workspace directory,"
		echo "or '' if you like to remove the reference to the workspace directory (doesn't affect directory/files)"
	else
		checkGoPath
	fi
}
function changeWorkspace {	
	read -p "You need to set a GOPATH directory as Go workspace: (default $HOME/GoWorkspace) " gopath

	if [[ $gopath == '' ]]; then
		mkdir -p "$HOME/GoWorkspace"
		mkdir -p "$HOME/GoWorkspace/src"
		mkdir -p "$HOME/GoWorkspace/bin"
		mkdir -p "$HOME/GoWorkspace/pkg"
		export GOPATH=$HOME/GoWorkspace
		echo ""
		echo "Workspace sucessfullly changed!"
		echo "Check under $HOME/GoWorkspace"
		echo ""
	else
		mkdir -p "$HOME/$gopath"
		mkdir -p "$HOME/$gopath/src"
		mkdir -p "$HOME/$gopath/bin"
		mkdir -p "$HOME/$gopath/pkg"
		export GOPATH=$HOME/$gopath
		echo ""
		echo "Workspace sucessfullly changed!"
		echo "Check under $HOME/$gopath"
		echo ""
	fi
}

##---------------------------------- MAIN CODE

if [[ $# -eq 0 ]]; then
	
	helpScreen

else

	checkGoPath

fi
