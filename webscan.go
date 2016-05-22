package main

import (
	"bufio"
	"log"
	"net/http"
	"os"
	"os/exec"
)

const scan_binary = "scanimage.sh"

func main() {

	// start http server
	http.HandleFunc("/scan", func(w http.ResponseWriter, r *http.Request) {
		// fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
		// invoke scan script that is going to scan document and convert to PDF
		stdout, err := exec.Command(scan_binary).Output()
		if err != nil {
			log.Printf("Could not execute command. Error: %v\n", err)
			w.WriteHeader(500)
			return
		}

		scannedPdfPath := string(stdout)

		f, err := os.Open(string(scannedPdfPath))
		if err != nil {
			log.Printf("Cannot open file. Error: %v\n", err)
			w.WriteHeader(500)
			return
		}
		defer f.Close()

		fr := bufio.NewReader(f)
		fr.WriteTo(w)

		// set header to reflect that we are returning a PDF
		w.Header().Set("Content-Type", "application/pdf")
	})

	log.Fatal(http.ListenAndServe(":8080", nil))
}
