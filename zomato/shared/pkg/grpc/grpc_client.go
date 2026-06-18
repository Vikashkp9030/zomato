package grpc

import (
	"fmt"
	"log"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

// GRPCClient represents a gRPC client connection
type GRPCClient struct {
	Conn *grpc.ClientConn
}

// NewGRPCClient creates a new gRPC client connection
func NewGRPCClient(address string) (*GRPCClient, error) {
	conn, err := grpc.NewClient(address, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Printf("Failed to connect to gRPC server at %s: %v", address, err)
		return nil, err
	}

	log.Printf("Connected to gRPC server at %s", address)
	return &GRPCClient{Conn: conn}, nil
}

// Close closes the gRPC client connection
func (c *GRPCClient) Close() error {
	if c.Conn != nil {
		return c.Conn.Close()
	}
	return nil
}

// GetConnection returns the underlying gRPC connection
func (c *GRPCClient) GetConnection() *grpc.ClientConn {
	return c.Conn
}

// IsConnected checks if the client is connected
func (c *GRPCClient) IsConnected() bool {
	return c.Conn != nil && c.Conn.GetState().String() == "READY"
}

// MustConnect creates a new gRPC client connection and panics on error
func MustConnect(address string) *GRPCClient {
	client, err := NewGRPCClient(address)
	if err != nil {
		panic(fmt.Sprintf("Failed to connect to gRPC server: %v", err))
	}
	return client
}
