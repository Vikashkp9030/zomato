package grpc

import (
	"fmt"
	"log"
	"net"

	"google.golang.org/grpc"
)

// GRPCServer represents a gRPC server
type GRPCServer struct {
	Server   *grpc.Server
	Listener net.Listener
	Port     int
}

// NewGRPCServer creates a new gRPC server
func NewGRPCServer(port int) (*GRPCServer, error) {
	listener, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		log.Printf("Failed to listen on port %d: %v", port, err)
		return nil, err
	}

	server := grpc.NewServer()

	log.Printf("gRPC Server created on port %d", port)
	return &GRPCServer{
		Server:   server,
		Listener: listener,
		Port:     port,
	}, nil
}

// Start starts the gRPC server
func (s *GRPCServer) Start() error {
	log.Printf("Starting gRPC server on port %d...", s.Port)
	if err := s.Server.Serve(s.Listener); err != nil {
		log.Printf("gRPC server error: %v", err)
		return err
	}
	return nil
}

// Stop gracefully stops the gRPC server
func (s *GRPCServer) Stop() {
	if s.Server != nil {
		log.Printf("Stopping gRPC server on port %d...", s.Port)
		s.Server.GracefulStop()
	}
}

// GetServer returns the underlying gRPC server
func (s *GRPCServer) GetServer() *grpc.Server {
	return s.Server
}

// GetPort returns the gRPC server port
func (s *GRPCServer) GetPort() int {
	return s.Port
}

// GetAddress returns the gRPC server address
func (s *GRPCServer) GetAddress() string {
	return fmt.Sprintf(":%d", s.Port)
}
