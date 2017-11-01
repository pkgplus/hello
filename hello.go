package main

import (
	"fmt"
	"log"
	"net/http"
	"strings"
)

func main() {
	http.HandleFunc("/",
		func(w http.ResponseWriter, r *http.Request) {
			fmt.Fprintf(w, "Hello %s", getIPAdress(r))
		},
	)

	log.Print("now listen :8080 ...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func getIPAdress(r *http.Request) string {
	var ipAddress string
	for _, h := range []string{"X-Forwarded-For", "X-Real-Ip"} {
		for _, ip := range strings.Split(r.Header.Get(h), ",") {
			// header can contain spaces too, strip those out.
			// realIP := net.ParseIP(strings.Replace(ip, " ", "", -1))
			ipAddress = ip
		}
	}

	if ipAddress == "" {
		ipAddress = r.RemoteAddr
	}
	return ipAddress
}
