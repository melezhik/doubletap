package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

type Check struct {
	Data    string `json:"data"`
	CheckId string `json:"check_id"`
	Params  string `json:"params"`
	Format  string `json:"format"`
}

func main() {

	check := flag.String("check", "hello", "the name of check")
	box := flag.String("box", "hello", "the name of box")
	params := flag.String("params", "", "params")
	api := flag.String("api", "http://127.0.0.1:9191", "api url")
	format := flag.String("format", "text", "output format")

	// times (int, default 1, usage "number of times to greet")
	//times := flag.Int("times", 1, "number of times to greet")
	// capitalize (bool, default false, usage "capitalize the name")

	verbose := flag.Bool("verbose", false, "verbose mode")

	flag.Parse()

	checkParam := *check
	boxParam := *box
	formatParam := *format
	apiParam := *api
	paramsParam := *params

	if *verbose {
		// In a real app, you'd use strings.ToUpper
		fmt.Printf("checkParam: %s\n", checkParam)
		fmt.Printf("boxParam: %s\n", boxParam)
		fmt.Printf("paramsParam: %s\n", paramsParam)
		fmt.Printf("formatParam: %s\n", formatParam)
		fmt.Printf("apiParam: %s\n", apiParam)
	}

	var check_data Check

	if boxParam == "-" {

		fmt.Printf("read box output from stdin \n")

		scanner := bufio.NewScanner(os.Stdin)

		scanner.Scan()

		if err := scanner.Err(); err != nil {
			fmt.Fprintln(os.Stderr, "reading standard input:", err)
		}

		check_data = Check{
			Data:    scanner.Text(),
			CheckId: checkParam,
			Params:  paramsParam,
			Format: formatParam,
		}

	}

	jsonData, err := json.Marshal(check_data)

	if err != nil {
		log.Fatal(err)
	}

	url := fmt.Sprintf("%s/api", apiParam)

	// if *verbose {
	// 	fmt.Printf("jsonData: %s\n", jsonData)
	// }

	var jsonStr = []byte(jsonData)

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonStr))

	if err != nil {
		panic(err)
	}

	//req.Header.Set("X-Custom-Header", "myvalue")

	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	fmt.Println("response Status:", resp.Status)

	fmt.Println("response Headers:", resp.Header)

	body, _ := io.ReadAll(resp.Body)

	fmt.Println("response Body:", string(body))

	//fmt.Printf("body: %s\n", body)
}
