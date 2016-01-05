#!/bin/bash

VERSION="GoProject, version 0.1.0-BETA"
DEVELOPER="Pedro \"Darth Çeqüella\" de Cavalcante"

function commandNotFound {
	echo ""
	echo "	Unavailable command. If you need help read the 'goproject --help'."
	echo ""
}
function helpScreen {
	echo $VERSION
	echo "This commands of GoProject was defined internally. Type 'goproject help' to see this page."
	echo "Type 'goproject help FUNCTION' to understand more about FUNCTION."
	echo ""
	echo "	goproject [OPTIONS] VALUES"
	echo ""
	echo "	help 			 			Open this page."
	echo "	workspace					Show the current workspace directory."
	echo "	change-workspace			Change current Workspace."
	echo "	reset-workspace				Clear the reference to the Workspace (doesn't affect the directories or files)."
	echo "	new 						Create a new project"
	echo "	list-projects				Return the full workspace's projects"
	echo "	version						Current GoProject version"
	echo "	about						About GoProject"
	echo "	build						Compile a project and generate an executable at $GOPATH/bin"
	echo "	run							Run the, previously builded, application."
	echo ""
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
	echo "You need to set a GOPATH directory as Go workspace. MUST BE in your ~/ directory"
	read -p ": (default $HOME/Go) " gopath

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
		echo "	Type correctly: goproject new PROJECT_NAME"
		echo ""
	else
		mkdir -p $GOPATH/src/$1
		echo 'package main' > $GOPATH/src/$1/main.go
		echo ""
		echo "	Project '$1' created!"
		echo "	Start editing: $GOPATH/src/$1/main.go"
		echo ""
	fi
}
function listProjects {
	echo ""
	echo "	Projects in this workspace:"
	ls --color=never $GOPATH/src/
	echo ""
}
function showVersion {
	echo ""
	echo "	$VERSION"
	echo ""
}
function showAbout {
	echo ""
	echo "	$VERSION"
	echo "	Developed by: $DEVELOPER"
	echo "	"
	echo "	The MIT License (MIT)"
	echo "	Copyright (c) 2016 $DEVELOPER

	Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the \"Software\"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE."
	echo ""
}
function buildApplication {
	if [[ $# == 1 ]]; then
		#Check if .goproject file already exists
		FILE="$GOPATH/src/$1/.goproject"
		if [[ -e "$FILE" ]]; then

			#Read the .goproject file
			for line in $(cat $GOPATH/src/$1/.goproject); do
				echo "	Building '$line'"
				go build $line
			done
		fi

		go install $1
	else
		echo ""
		echo "	Type correctly: 'goproject build <PROJECT>'"
		echo ""
	fi

}
function runCode {
	if [[ $# == 1 ]]; then
		
		#Get app location
		bin=${GOPATH/$HOME/}
		bin=${bin:1}
		bin="$bin/bin"

		currentDirectory=$(pwd)
		cd ~
		if [[ -e "$bin/$1" ]]; then
			#Find app
			./$bin/$1
		else
			echo ""
			echo "	Executable not found. First runs 'goproject build $1' "
			echo ""

		fi
		
		cd $currentDirectory

	else
		echo ""
		echo "	Type correctly: 'goproject run <PROJECT>'"
		echo ""

	fi
}
function createModule {
	if [[ $# != 2 ]]; then #Check correct command to create a new module
		echo ""
		echo "	Type correctly: 'goproject create-module <PROJECT_NAME> <MODULE_NAME>'"
		echo ""
	else

		#Create repository and module with start package setted
		mkdir -p $GOPATH/src/$1/$2
		echo "package $2" > $GOPATH/src/$1/$2/$2.go

		#Check if .goproject file already exists
		FILE="$GOPATH/src/$1/.goproject"
		if [[ -e "$FILE" ]]; then

			#Prevent duplied referente in .goproject
			export LISTED="FALSE"
			for line in $(cat $GOPATH/src/$1/.goproject); do
				if [[ $line == "$1/$2" ]]; then
					export LISTED="TRUE"
					break
				fi
			done

			#If module not listed, list it!
			if [[ $LISTED == "FALSE" ]]; then
				echo "$1/$2" >> $GOPATH/src/$1/.goproject
			fi

			unset LISTED
		else
			#.goproject file don't exists. Create it!
			echo "$1/$2" > $GOPATH/src/$1/.goproject
		fi

		echo ""
		echo "	Module '$2' created. Start editing in: $GOPATH/src/$1/$2/$2.go"
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
			list-projects)
				listProjects
				;;
			version)
				showVersion
				;;
			about)
				showAbout
				;;
			build)
				buildApplication $2
				;;
			run)
				runCode $2
				;;
			create-module)
				createModule $2 $3
				;;
			*)
				commandNotFound
				;;
		esac

	fi

fi
