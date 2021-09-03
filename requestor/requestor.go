package main

import (
	"bytes"
	"log"
	"net/http"
	"time"

	"github.com/nats-io/nats.go"
)

func main() {
	nc, err := nats.Connect("localhost")
	if err != nil {
		log.Fatal(err)
	}
	nc.Subscribe("foo", func(m *nats.Msg) {
		go m.Respond([]byte("OK!"))
	})

	for i := 0; i < 5; i++ {
		hc := &http.Client{}
		go func() {
			for range time.NewTicker(100 * time.Millisecond).C {
				body := bytes.NewBuffer([]byte("{}"))
				resp, err := hc.Post("http://localhost:3000/messages", "application/json", body)
				if err != nil {
					log.Println("Error: ", err)
					continue
				}
				resp.Body.Close()
				log.Println(resp.Status)
			}
		}()
	}
	select {}
}
