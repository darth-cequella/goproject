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
	"bufio"
	"log"
	"strings"
	"io/ioutil"
)

const (
	VERSION		="GoProject, version 0.1.0-BETA"
	DEVELOPER	="Pedro \"Darth Çeqüella\" de Cavalcante"
)

//-----------------------------------------------------------------------------------------------------------
//HELP
func commandNotFound() {
	fmt.Println("\n\tUnavailable command. If you need help read the 'goproject --help'.\n")
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
	fmt.Println("\tbuild\t\t\t\tCompile a project and generate an executable at WORKSPACE/bin")
	fmt.Println("\trun\t\t\t\tRun the, previously builded, application.\n\n")
	fmt.Println("\tproject\t\t\t\tCreate/Remove a project.\n\n")
}
//INFORMATION
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
				"SOFTWARE.\n")
}
//WORKSPACE
func hasWorkspace() bool {
	gopath := os.Getenv("GOPATH")
	return gopath!=""
}
func showWorkspace() {
	if hasWorkspace(){
		gopath := os.Getenv("GOPATH")
		fmt.Printf("\n\tYou current workspace is '%s'\n", gopath)
		fmt.Println("\tBut you can change using 'goproject set-workspace' or clearing using 'goproject clear-workspace'.\n")
	} else {
		fmt.Println("\n\tYou, already, don't have a workspace")
		fmt.Println("\tBut you can set one using 'goproject set-workspace'.\n")
	}
}
func setBashrc(gopath string) {
	home := os.Getenv("HOME")
	/*
	 * Read .bashrc file to find/change/add GOPATH exportation.
	 * This makes the environment variable persistent.
	 */
	bashAddress := home+"/.bashrc"
	file, err := ioutil.ReadFile(bashAddress)
	
	if err != nil {
		log.Fatalln(err) //If file not found, print error
	}
	
	bashrc := strings.Split(string(file), "\n")
	
	addGopath := true
	for i, line := range bashrc {
		if strings.HasPrefix(line, "export GOPATH") {
			fmt.Println(gopath)
			bashrc[i] = "export GOPATH="+gopath
			addGopath = false
			break
		}
	}
	
	if addGopath {
		bashrc = append(bashrc, "# Go Envinronment variable for GOPATH")
		bashrc = append(bashrc, "export GOPATH="+gopath)
	}
	output := strings.Join(bashrc, "\n")
	err = ioutil.WriteFile(bashAddress, []byte(output), 0644)
	if err != nil{
		log.Fatalln(err)
	}
} 
func setWorkspace() {
	home := os.Getenv("HOME")
	reader := bufio.NewReader(os.Stdin) //Start a reader
	
	fmt.Printf("\nYou need to set a directory to use as Go workspace:\n(empty = %s/Go) ", home)
	gopath, err := reader.ReadString('\n')

	if err != nil{
		log.Fatalln(err)
	} else {
		gopath = gopath[:len(gopath)-1] //Remove final breakline

		if gopath == "" {
			gopath = home+"/Go"
		} else {
			gopath = home+"/"+gopath
		}

		//Create workspace structure
		if err:=os.MkdirAll(gopath, 0775); err!=nil{ 
			log.Fatalln(err) 
		}
		if err:=os.MkdirAll(gopath+"/src", 0775); err!=nil{ 
			log.Fatalln(err) 
		}
		if err:=os.MkdirAll(gopath+"/bin", 0775); err!=nil{ 
			log.Fatalln(err) 
		}
		if err:=os.MkdirAll(gopath+"/pkg", 0775); err!=nil{ 
			log.Fatalln(err) 
		}
		
		if err:=os.Setenv("GOPATH", gopath); err!=nil{ 
			log.Fatalln(err) //Seting environment variable
		} 
		setBashrc(gopath)
		
		fmt.Println("\n\tWorkspace sucessfullly created!")
		fmt.Printf("\tCheck under %s\n\n", gopath)
	}
}
//PROJECT
func listProjects() {
	
}
func newProject(project string) {
	gopath := os.Getenv("GOPATH")
	
	if gopath=="" && project!=""{
		if err:=os.MkdirAll(gopath+"/src/"+project, 0775); err!=nil{ 
			log.Fatalln(err) 
		}
		fmt.Printf("\n\tProject created. Open it on '%s\\src\\%s'\n", gopath, project)
	} else {
		if gopath=="" {
			fmt.Println("\n\tYou don't have defined your workspace yet. \n\tTry 'goproject worspace' for more information\n")
		} else if project=="" {
			fmt.Println("\n\tDefine the name of the project. \n\tTry again 'goproject project new NAME'\n")
		}
	}
}
func removeProject() {
	
}
//MENU
func checkFunction(args []string) {
	function:=args[0]; //Get function accessed by user

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
	case "workspace":
		showWorkspace()
	case "set-workspace":
		setWorkspace()
	default:
		commandNotFound()
	}
}

func main() {
	args := os.Args[1:]

	if len(args) == 0 { // If user not set a function
		genericHelp()
	} else {
		//First, check if exists a workspace. If not, make it!
		if !hasWorkspace() {
			setWorkspace()
		} else {
			checkFunction(args)
		}
	}
}
