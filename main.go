package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"time"
	"io/ioutil"
	"path/filepath"
)

type Check struct {
	Data    string `json:"data"`
	CheckId string `json:"check_id"`
	Desc string `json:"desc"`
	Params  string `json:"params"`
}

type CheckResult struct {
	Status string `json:"status"`
	Report string `json:"report"`
	Desc string `json:"desc"`
}

func main() {

	check := flag.String("check", "hello", "the name of check")
	box := flag.String("box", "hello", "the name of box")
	params := flag.String("params", "", "params")
	session := flag.String("session", "", "session id")
	desc := flag.String("desc", "check", "check desc")
	api := flag.String("api", "http://127.0.0.1:9191", "api url")

	// times (int, default 1, usage "number of times to greet")
	//times := flag.Int("times", 1, "number of times to greet")
	// capitalize (bool, default false, usage "capitalize the name")

	verbose := flag.Bool("verbose", false, "verbose mode")
	report := flag.Bool("report", false, "show report")

	flag.Parse()

	checkParam := *check
	boxParam := *box
	apiParam := *api
	paramsParam := *params
	sessionParam := *session
	reportParam := *report
	descParam := *desc

	if reportParam == true && sessionParam != "" {

		fmt.Printf("DTAP report\nsession: %s\n===\n",sessionParam);
		hdir, err := os.UserHomeDir()

		dir := fmt.Sprintf("%s/.dtap/%s", hdir, sessionParam)

		files, err := ioutil.ReadDir(dir)
    	if err != nil {
        	log.Fatal(err)
    	}

		for _, file := range files {
			path := filepath.Join(dir, file.Name())
			data, err := os.ReadFile(path)
			if err != nil {
				log.Fatal(err)
			}

			var r CheckResult

			err = json.Unmarshal(data, &r)
			if err != nil {
				log.Fatalf("error unmarshalling: %v", err)
			}
			fmt.Printf("%s ...... %s\n",r.Desc,r.Status)
		}

		return;
	}

	if *verbose {
		// In a real app, you'd use strings.ToUpper
		fmt.Printf("checkParam: %s\n", checkParam)
		fmt.Printf("boxParam: %s\n", boxParam)
		fmt.Printf("paramsParam: %s\n", paramsParam)
		fmt.Printf("apiParam: %s\n", apiParam)
		fmt.Printf("sessionParam: %s\n", sessionParam)
	}

	var check_data Check

	if boxParam == "-" {

		if *verbose {
			fmt.Printf("read box output from stdin \n")
		}	

		data, err := io.ReadAll(os.Stdin)

		if err != nil {
			fmt.Fprintln(os.Stderr, "reading standard input:", err)
		}

		check_data = Check{
			Data:    string(data),
			CheckId: checkParam,
			Params:  paramsParam,
			Desc: descParam,
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

	body, _ := io.ReadAll(resp.Body)

	var r CheckResult

	err = json.Unmarshal(body, &r)
	if err != nil {
		log.Fatalf("error unmarshalling: %v", err)
	}

	if sessionParam != "" {
		now := time.Now()
		hdir, err := os.UserHomeDir()
		report_id := now.UnixNano()
		dir := fmt.Sprintf("%s/.dtap/%s", hdir, sessionParam)
		err = os.MkdirAll(dir, 0755)
		if err != nil {
			log.Fatalf("Error creating directory:", err)
		}
		file := fmt.Sprintf("%s/%d.json",dir, report_id)
		err = os.WriteFile(file, body, 0644)
		if err != nil {
			log.Fatal(err)
		}
	} else {
		fmt.Println("%s", string(r.Report))
	}

	//fmt.Println("response Status:", resp.Status)

	//fmt.Println("response Headers:", resp.Header)

}
