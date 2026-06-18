package main

import (
	"context"
	"log"
	"math/rand"
	"net/http"
	"strconv"
	"sync"
	"time"
)

// ============================================================
// MIDDLEWARE IN GO — CORE CONCEPT
// ============================================================
// A middleware is a function that wraps an http.Handler to add
// behaviour before and/or after the actual handler runs.
//
// Pattern:
//
//	func SomeMiddleware(next http.Handler) http.Handler {
//	    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
//	        // --- code BEFORE handler ---
//	        next.ServeHTTP(w, r)   // call the real handler
//	        // --- code AFTER handler ---
//	    })
//	}
//
// Middleware type alias makes function signatures readable.
type Middleware func(http.Handler) http.Handler

// Chain wraps h with every middleware in the given order.
// The first middleware in the slice is the outermost wrapper,
// so it runs first on the way in and last on the way out.
//
// Example: Chain(handler, A, B, C)
// Request flow:  A → B → C → handler
// Response flow: handler → C → B → A
func Chain(h http.Handler, middlewares ...Middleware) http.Handler {
	// Apply in reverse so the first middleware ends up outermost.
	for i := len(middlewares) - 1; i >= 0; i-- {
		h = middlewares[i](h)
	}
	return h
}

// ============================================================
// 1. LOGGING MIDDLEWARE
// ============================================================
// Logs every HTTP request with: method, path, response status,
// and how long the handler took to respond.
//
// Why capture status?
// http.ResponseWriter does not expose the status code after it
// has been written, so we wrap it in statusRecorder to intercept
// the WriteHeader call and save the code for later logging.

// statusRecorder wraps ResponseWriter to capture the status code.
type statusRecorder struct {
	http.ResponseWriter        // embed so all other methods still work
	status              int    // status code written by the handler
}

// WriteHeader intercepts the status code before passing it along.
func (r *statusRecorder) WriteHeader(code int) {
	r.status = code
	r.ResponseWriter.WriteHeader(code)
}

// LoggingMiddleware logs: [LOG] METHOD /path -> STATUS (duration)
func LoggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()

		// Wrap the writer so we can read the status code after the handler runs.
		rec := &statusRecorder{ResponseWriter: w, status: http.StatusOK}

		next.ServeHTTP(rec, r) // run the actual handler

		// Log after handler finishes — we now know the status and duration.
		log.Printf("[LOG] %s %s -> %d (%s)", r.Method, r.URL.Path, rec.status, time.Since(start))
	})
}

// ============================================================
// 2. RECOVERY MIDDLEWARE
// ============================================================
// Go servers crash the goroutine (and drop the connection) on
// an unhandled panic. This middleware uses defer+recover to catch
// any panic, log it, and return a 500 response instead, so the
// server keeps running and other requests are unaffected.

func RecoveryMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			if err := recover(); err != nil {
				// err can be any type — log it as-is with %v.
				log.Printf("[RECOVERY] panic: %v", err)
				http.Error(w, "Internal Server Error", http.StatusInternalServerError)
			}
		}()
		next.ServeHTTP(w, r)
	})
}

// ============================================================
// 3. AUTHENTICATION MIDDLEWARE
// ============================================================
// Checks the Authorization header for a Bearer token.
// Real apps would verify a JWT or look the token up in a DB.
// Here we compare against a hardcoded secret for demonstration.
//
// Header format expected:
//
//	Authorization: Bearer secret-token
//
// Returns 401 Unauthorized if the header is missing or wrong.

const validToken = "secret-token"

func AuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		token := r.Header.Get("Authorization")
		if token != "Bearer "+validToken {
			// Stop the chain here — do NOT call next.ServeHTTP.
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}
		// Token is valid; continue to the next middleware or handler.
		next.ServeHTTP(w, r)
	})
}

// ============================================================
// 4. CORS MIDDLEWARE
// ============================================================
// Cross-Origin Resource Sharing (CORS) is a browser security
// feature. When a browser makes a request from origin A to
// server B, B must explicitly allow it via response headers.
//
// Preflight: before a non-simple request (e.g. POST with JSON),
// the browser sends an OPTIONS request first. We respond with
// 204 No Content and the allow-headers so the real request proceeds.
//
// In production, replace "*" with your actual allowed origin(s).

func CORSMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Allow any origin — tighten this in production.
		w.Header().Set("Access-Control-Allow-Origin", "*")
		// Methods the client is allowed to use.
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		// Headers the client is allowed to send.
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")

		// Handle preflight request — respond and stop the chain.
		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusNoContent)
			return
		}

		next.ServeHTTP(w, r)
	})
}

// ============================================================
// 5. RATE LIMITING MIDDLEWARE
// ============================================================
// Prevents a single client (identified by IP) from making more
// than maxReqs requests within a rolling time window.
//
// How it works:
//   - A map tracks request counts per IP address.
//   - A background goroutine resets the map every window duration,
//     so counts are effectively per-window (not sliding, but simple).
//   - A mutex protects the map from concurrent access.
//
// Returns 429 Too Many Requests when the limit is exceeded.

type rateLimiter struct {
	mu      sync.Mutex        // guards counts
	counts  map[string]int    // IP → request count in current window
	window  time.Duration     // how long each window lasts
	maxReqs int               // max requests allowed per window per IP
}

// newRateLimiter creates a limiter and starts the reset goroutine.
func newRateLimiter(maxReqs int, window time.Duration) *rateLimiter {
	rl := &rateLimiter{
		counts:  make(map[string]int),
		window:  window,
		maxReqs: maxReqs,
	}
	// Background goroutine: reset all counts at the end of each window.
	go func() {
		for range time.Tick(window) {
			rl.mu.Lock()
			rl.counts = make(map[string]int) // discard old map — GC handles cleanup
			rl.mu.Unlock()
		}
	}()
	return rl
}

// Middleware is a method so it closes over the rateLimiter's state.
func (rl *rateLimiter) Middleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// r.RemoteAddr is "IP:port" — use the full string as the key.
		// In production, check X-Forwarded-For / X-Real-IP for proxied requests.
		ip := r.RemoteAddr

		rl.mu.Lock()
		rl.counts[ip]++
		count := rl.counts[ip]
		rl.mu.Unlock()

		if count > rl.maxReqs {
			http.Error(w, "Too Many Requests", http.StatusTooManyRequests)
			return
		}
		next.ServeHTTP(w, r)
	})
}

// ============================================================
// 6. REQUEST ID MIDDLEWARE
// ============================================================
// Assigns a unique ID to every request. This ID is:
//   - Stored in the request context so handlers can read it.
//   - Sent back to the client as the X-Request-ID response header.
//
// Use cases: correlating log lines for a single request,
// debugging distributed systems, client-side error reporting.

// contextKey is a private type to avoid key collisions in context.
// Using a plain string as a key is risky because any package could
// accidentally use the same string. A named type prevents that.
type contextKey string

const RequestIDKey contextKey = "requestID"

func RequestIDMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Generate a random 64-bit number, format as hex string.
		id := strconv.FormatInt(rand.Int63(), 16)

		// Store in context — handlers retrieve it with r.Context().Value(RequestIDKey).
		ctx := context.WithValue(r.Context(), RequestIDKey, id)

		// Echo the ID back to the client for tracing.
		w.Header().Set("X-Request-ID", id)

		// Pass the new context (with ID) to downstream handlers.
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

// ============================================================
// 7. TIMEOUT MIDDLEWARE
// ============================================================
// Sets a deadline on the request context. If the handler takes
// longer than the timeout, the context is cancelled automatically.
//
// Important: context cancellation does NOT stop a running goroutine
// by itself. Handlers must check ctx.Done() or use context-aware
// functions (e.g. database queries that accept a context) to
// actually abort work early.
//
// This is a factory (returns a Middleware) so the timeout duration
// can be configured differently per route.

func TimeoutMiddleware(timeout time.Duration) Middleware {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// WithTimeout derives a new context that cancels after `timeout`.
			ctx, cancel := context.WithTimeout(r.Context(), timeout)
			defer cancel() // always release the timer, even if handler finishes early

			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

// ============================================================
// 8. CONTENT-TYPE ENFORCEMENT MIDDLEWARE
// ============================================================
// Ensures the client sends the correct Content-Type header on
// requests that include a body (POST and PUT). Returning 415
// Unsupported Media Type before the body is read avoids wasted
// parsing of badly formed payloads.
//
// This is a factory so you can require different content types
// on different routes (e.g. "application/json" vs "text/xml").

func ContentTypeMiddleware(contentType string) Middleware {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// Only enforce on methods that carry a request body.
			if r.Method == http.MethodPost || r.Method == http.MethodPut {
				if r.Header.Get("Content-Type") != contentType {
					http.Error(w, "Unsupported Media Type", http.StatusUnsupportedMediaType)
					return
				}
			}
			next.ServeHTTP(w, r)
		})
	}
}

// ============================================================
// 9. SECURITY HEADERS MIDDLEWARE
// ============================================================
// Adds HTTP response headers that instruct the browser to apply
// additional security protections. These do nothing server-side
// but harden the client-side behaviour of your API/web app.
//
//   - X-Content-Type-Options: nosniff
//     Stops the browser from guessing the MIME type. Without this,
//     a browser might execute a text file as JavaScript.
//
//   - X-Frame-Options: DENY
//     Prevents the page from being loaded inside an <iframe>,
//     protecting against clickjacking attacks.
//
//   - X-XSS-Protection: 1; mode=block
//     Enables the browser's built-in XSS filter (legacy browsers).
//     Modern browsers use Content-Security-Policy instead.
//
//   - Strict-Transport-Security (HSTS)
//     Tells the browser to only contact this server over HTTPS for
//     the next 63072000 seconds (2 years), even if the user types
//     http://. includeSubDomains extends this to all subdomains.

func SecurityHeadersMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("X-Content-Type-Options", "nosniff")
		w.Header().Set("X-Frame-Options", "DENY")
		w.Header().Set("X-XSS-Protection", "1; mode=block")
		w.Header().Set("Strict-Transport-Security", "max-age=63072000; includeSubDomains")
		next.ServeHTTP(w, r)
	})
}

// ============================================================
// 10. REQUEST BODY SIZE LIMIT MIDDLEWARE
// ============================================================
// Wraps the request body with http.MaxBytesReader, which returns
// an error when more than maxBytes are read. This prevents:
//   - Clients from uploading arbitrarily large files/payloads.
//   - Memory exhaustion attacks (e.g. sending a 10 GB body).
//
// http.MaxBytesReader also sets a flag that causes the server to
// send a 413 Request Entity Too Large response automatically when
// the limit is hit during io.ReadAll / json.Decode.
//
// This is a factory so you can set different limits per route
// (e.g. 1 MB for JSON APIs, 20 MB for file upload endpoints).

func MaxBodySizeMiddleware(maxBytes int64) Middleware {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// Replace r.Body with a size-limited reader.
			r.Body = http.MaxBytesReader(w, r.Body, maxBytes)
			next.ServeHTTP(w, r)
		})
	}
}
