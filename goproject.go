/**
	The MIT License (MIT)

	Copyright (c) 2016 Pedro "Darth Çeqüella" de Cavalcante

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
**/

package main

import (
	"fmt"
	"os"
)

const (
	VERSION		="GoProject, version 0.1.0-BETA"
	DEVELOPER	="Pedro \"Darth Çeqüella\" de Cavalcante"
)

//-----------------------------------------------------------------------------------------------------------

func commandNotFound() {
	fmt.Println("\n\tUnavailable command. If you need help read the 'goproject --help'.")
}
func genericHelp() {
	fmt.Println()
	fmt.Println(VERSION)
	fmt.Println("This commands of GoProject was defined internally. Type 'goproject help' to see this page.")
	fmt.Println("Type 'goproject help FUNCTION' to understand more about FUNCTION.\n")
	fmt.Println("\tgoproject [OPTIONS] VALUES\n")
	fmt.Println("\thelp\t\t\t\tOpen this page.")
	fmt.Println("\tworkspace\t\t\tShow the current workspace directory.")
	fmt.Println("\tchange-workspace\t\tChange current Workspace.")
	fmt.Println("\treset-workspace\t\t\tClear the reference to the Workspace (doesn't affect the directories or files).")
	fmt.Println("\tnew\t\t\t\tCreate a new project")
	fmt.Println("\tlist-projects\t\t\tReturn the full workspace's projects")
	fmt.Println("\tversion\t\t\t\tCurrent GoProject version")
	fmt.Println("\tabout\t\t\t\tAbout GoProject")
	fmt.Println("\tbuild\t\t\t\tCompile a project and generate an executable at $GOPATH/bin")
	fmt.Println("\trun\t\t\t\tRun the, previously builded, application.\n")
}
func showVersion() {
	fmt.Println()
	fmt.Println("\t",VERSION)
}
func showAbout() {
	fmt.Println()
	fmt.Println("\t"+VERSION)
	fmt.Println("\tDeveloped by: "+DEVELOPER)
	fmt.Println("\tThe MIT License (MIT)")
	fmt.Println("\tCopyright (c) 2016 "+DEVELOPER+"\n\n"+
				"\tPermission is hereby granted, free of charge, to any person obtaining a copy"+
				"of this software and associated documentation files (the \"Software\"), to deal"+
				"in the Software without restriction, including without limitation the rights"+
				"to use, copy, modify, merge, publish, distribute, sublicense, and/or sell"+
				"copies of the Software, and to permit persons to whom the Software is"+
				"furnished to do so, subject to the following conditions:\n\n"+
				"\tThe above copyright notice and this permission notice shall be included in all"+
				"copies or substantial portions of the Software.\n\n"+
				"\tTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR"+
				"IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,"+
				"FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE"+
				"AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER"+
				"LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,"+
				"OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE"+
				"SOFTWARE.")
}

func main() {
	args := os.Args[1:]

	if len(args) == 0 { // If user not set a function
		genericHelp()
	} else {

		function:=args[0]; //Function accessed by user
		switch function{
		case "help":
			if len(args) == 1 {
				genericHelp()
			} else {
				//specific help
			}
		case "about":
			showAbout()
		case "version":
			showVersion()
		default:
			commandNotFound()
		}
	}
}