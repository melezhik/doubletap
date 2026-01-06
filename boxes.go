package main

import (
	"embed"
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
)

//go:embed boxes/*.sh

var folder embed.FS

func BoxList() []string {
	return []string{"http-client"}
}

func RunBox(box string, params string) string {

	// Define the command and its arguments separately

	box_content, _ := folder.ReadFile(fmt.Sprintf("boxes/%s.sh", box))

	if params != "" {
		params = strings.ReplaceAll(params, ",", " ")
		c := params + "\n" + string(box_content)
		box_content = []byte(c)
	}

	hdir, err := os.UserHomeDir()

	dir := fmt.Sprintf("%s/.dtap/boxes", hdir)

	err = os.MkdirAll(dir, 0755)

	if err != nil {
		log.Fatalf("Error creating directory:", err)
	}

	file := fmt.Sprintf("%s/%s.sh", dir, box)

	err = os.WriteFile(file, box_content, 0644)
	if err != nil {
		log.Fatal(err)
	}

	cmd := exec.Command("sh", file)

	output, err := cmd.CombinedOutput() // Run the command and wait for completion

	if err != nil {
		log.Fatalf("sh %s failed with %s\n", file, err)
	}

	return string(output)
}
