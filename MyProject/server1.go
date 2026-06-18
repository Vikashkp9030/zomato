package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

type User struct {
	Name string `json:"name"`
	Age  int    `json:"age"`
	City string `json:"city"`
}

func main() {
	port := 8080

	// Shared middlewares applied to every route.
	limiter := newRateLimiter(100, time.Minute)
	globalMiddlewares := []Middleware{
		RecoveryMiddleware,
		RequestIDMiddleware,
		LoggingMiddleware,
		SecurityHeadersMiddleware,
		CORSMiddleware,
		limiter.Middleware,
		TimeoutMiddleware(10 * time.Second),
	}

	// wrap applies the global middleware chain (plus any route-specific extras).
	wrap := func(h http.HandlerFunc, extra ...Middleware) http.Handler {
		return Chain(h, append(globalMiddlewares, extra...)...)
	}

	mux := http.NewServeMux()

	mux.Handle("/", wrap(func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello, World!"))
		fmt.Println("Hello, World!")
	}))

	// /teacher demonstrates per-route auth + content-type enforcement on POST/PUT.
	mux.Handle("/teacher", wrap(
		func(w http.ResponseWriter, r *http.Request) {
			switch r.Method {
			case http.MethodGet:
				w.Write([]byte("GET request received for teacher route!"))
				fmt.Println("GET request received for teacher route!")

			case http.MethodPost:
				err := r.ParseForm()
				if err != nil {
					w.WriteHeader(http.StatusBadRequest)
					w.Write([]byte("Error parsing form data"))
					fmt.Printf("Error parsing form data: %v", err)
					return
				}
				w.Write([]byte(r.Form.Encode()))
				for key, values := range r.Form {
					for _, value := range values {
						fmt.Printf("Received form data: %s = %s\n", key, value)
					}
				}

				fmt.Printf("Request URL: %s\n", r.URL.String())
				fmt.Printf("Request Headers: %v\n", r.Header)
				fmt.Printf("Request Content Length: %d\n", r.ContentLength)
				fmt.Printf("Request Remote Address: %s\n", r.RemoteAddr)
				fmt.Printf("Request Host: %s\n", r.Host)
				fmt.Printf("Request User Agent: %s\n", r.UserAgent())
				fmt.Printf("Request Form: %v\n", r.Form)
				fmt.Printf("Request Post Form: %v\n", r.PostForm)
				fmt.Printf("Request Multipart Form: %v\n", r.MultipartForm)
				fmt.Printf("Request TLS: %v\n", r.TLS)
				fmt.Printf("Request Proto: %s\n", r.Proto)
				fmt.Printf("Request Proto Major: %d\n", r.ProtoMajor)
				fmt.Printf("Request Proto Minor: %d\n", r.ProtoMinor)
				fmt.Printf("Request Content Type: %s\n", r.Header.Get("Content-Type"))
				fmt.Printf("Request Cookies: %v\n", r.Cookies())
				fmt.Printf("Request Form Value 'name': %s\n", r.FormValue("name"))
				fmt.Printf("Request Form Value 'age': %s\n", r.FormValue("age"))
				fmt.Printf("Request Form Value 'city': %s\n", r.FormValue("city"))
				fmt.Printf("Request Form Value 'name' (PostForm): %s\n", r.PostFormValue("name"))
				fmt.Printf("Request Form Value 'age' (PostForm): %s\n", r.PostFormValue("age"))
				fmt.Printf("Request Form Value 'city' (PostForm): %s\n", r.PostFormValue("city"))

				body, err := io.ReadAll(r.Body)
				if err != nil {
					w.WriteHeader(http.StatusBadRequest)
					w.Write([]byte("Error reading request body"))
					fmt.Printf("Error reading request body: %v", err)
					return
				}
				defer r.Body.Close()
				fmt.Printf("Received request body: %s\n", body)
				fmt.Printf("Received POST request with body: %s\n", string(body))

				var user User
				err = json.Unmarshal(body, &user)
				if err != nil {
					w.WriteHeader(http.StatusBadRequest)
					w.Write([]byte("Error parsing JSON body"))
					fmt.Printf("Error parsing JSON body: %v", err)
					return
				}
				fmt.Printf("Parsed User struct: %+v\n", user)
				fmt.Printf("Parsed User Name: %s\n", user.Name)

				w.Write([]byte("POST request received for teacher route!"))
				fmt.Println("POST request received for teacher route!")

			case http.MethodPut:
				w.Write([]byte("PUT request received for teacher route!"))
				fmt.Println("PUT request received for teacher route!")

			case http.MethodDelete:
				w.Write([]byte("DELETE request received for teacher route!"))

			default:
				w.WriteHeader(http.StatusMethodNotAllowed)
				w.Write([]byte("Method not allowed"))
			}
		},
		// Extra per-route middleware: require auth + JSON content-type on POST/PUT.
		AuthMiddleware,
		ContentTypeMiddleware("application/json"),
	))

	mux.Handle("/student", wrap(func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello Student route!"))
		fmt.Println("Hello, Student!")
	}))

	mux.Handle("/execs", wrap(func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello Execs route!"))
		fmt.Println("Hello, Execs!")
	}))

	// /panic is a demo route to show the recovery middleware working.
	mux.Handle("/panic", wrap(func(w http.ResponseWriter, r *http.Request) {
		panic("intentional panic for recovery demo")
	}))

	err := http.ListenAndServe(fmt.Sprintf(":%d", port), mux)
	if err != nil {
		fmt.Printf("Error starting server: %v", err)
	}
}
