package main

import (
	"encoding/json"
	"fmt"
	"github.com/labstack/echo/v5"
	"github.com/labstack/echo/v5/middleware"
	"io"
	"log"
  "log/slog"
	"net/http"
	"os"
	"path/filepath"
  "os/exec"
  "strings"
)

type Check struct {
        Data    string `json:"data"`
        CheckId string `json:"check_id"`
        Desc    string `json:"desc"`
        Params  string `json:"params"`
}

type CheckResult struct {
        Status bool
        Report string
        Desc   string
}

func main() {

	// Echo instance
	e := echo.New()

	// Middleware
	e.Use(middleware.RequestLogger()) // use the RequestLogger middleware with slog logger
	e.Use(middleware.Recover())       // recover panics as errors for proper error handling

	// Routes
	e.GET("/api/checks", check_list)
	e.POST("/api", run_check)

	// Start server
	if err := e.Start("127.0.0.1:9191"); err != nil {
		slog.Error("failed to start server", "error", err)
	}
}

func check_list(c *echo.Context) error {

  searchDir := "checks" // Target directory

	entries, err := os.ReadDir(searchDir)
	if err != nil {
		log.Fatalf("check_list, error reading checks/ directory: %s",err)
	}

  var list []string

	fmt.Println("check_list, checks found:")
	for _, entry := range entries {
		// Filter out files, keeping only directories
		if entry.IsDir() {
			fmt.Println("- " + entry.Name())
      list = append(list,entry.Name())
		}
	}

  return c.String(
    http.StatusOK,
    fmt.Sprintf("checks: %s", strings.Join(list, "\n")),
  )
}

func run_check(c *echo.Context) error {

	var r Check

	bodyBytes, err := io.ReadAll(c.Request().Body)

	if err != nil {
		return err
	}

	defer c.Request().Body.Close()

	log.Printf("run_check, Request Body: %s\n", string(bodyBytes))

	err = json.Unmarshal(bodyBytes, &r)

	if err != nil {
		log.Printf("run_check: error unmarshaling JSON: %v", err)
		return echo.NewHTTPError(http.StatusBadRequest, "Invalid JSON body")
	}

  dir, err := os.MkdirTemp("", "check-*")

	if err != nil {
		log.Fatal(err)
	}

	// Always clean up the directory when done
	//defer os.RemoveAll(dir)

	fmt.Println("run_check, Temp dir created at", dir)

  path := filepath.Join("checks", r.CheckId, "task.check")

  dat, err := os.ReadFile(path)

	if err != nil {
		log.Fatalf("run_check, error reading check file: %s", err)
	}

  err = os.WriteFile(fmt.Sprintf("%s/task.check", dir), dat, 0644)

	if err != nil {
		log.Fatalf("run_check, error writing task.check file: %s", err)
	}

  filename := filepath.Join("checks", r.CheckId, "config.yaml")
  _, err = os.Stat(filename)

	if err == nil {

    dat, err := os.ReadFile(filename)

    if err != nil {
      log.Fatalf("run_check, error reading config.yaml file: %s", err)
    }

    err = os.WriteFile(fmt.Sprintf("%s/config.yaml", dir), dat, 0644)

    if err != nil {
      log.Fatalf("run_check, error writting config.yaml file: %s",err)
    }
	}

  err = os.WriteFile(fmt.Sprintf("%s/data.txt", dir), []byte(r.Data), 0644)

  if err != nil {
    log.Fatalf("run_check, error writting data.txt file: %s",err)
  }

  err = os.WriteFile(fmt.Sprintf("%s/task.bash", dir), []byte("cat data.txt"), 0644)

  if err != nil {
    log.Fatalf("run_check, error writting task.bash file: %s",err)
  }

  parts := []string{}

  parts = append(parts,"s6")

  parts = append(parts,"--task-run")

  if r.Params != "" {
    parts = append(parts, fmt.Sprintf(".@%s",r.Params))
  } else {
    parts = append(parts,".")
  }

	fmt.Printf("run_check, check command: %s\n", parts)

  cmd := exec.Command(parts[0], parts[1:]...)

  cmd.Dir = dir

  var output []byte

  var res CheckResult

  res.Desc = r.Desc

  output, err = cmd.CombinedOutput()

  res.Report = string(output)

	if err != nil {

    res.Status = false

	} else {

    res.Status = true

  }

	fmt.Print(string(output))

	return c.JSON(http.StatusOK, res)

}
