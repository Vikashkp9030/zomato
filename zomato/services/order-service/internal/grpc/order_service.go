package grpc

import (
	"context"
	"log"

	pb "github.com/vikashkp9030/zomato/shared/pb"
	"github.com/vikashkp9030/zomato/services/order-service/internal/repository"
	"github.com/vikashkp9030/zomato/services/order-service/internal/usecase"
)

// OrderServiceImpl implements pb.OrderServiceServer
type OrderServiceImpl struct {
	pb.UnimplementedOrderServiceServer
	repository repository.OrderRepository
	usecase    usecase.OrderUsecase
}

// NewOrderServiceImpl creates a new order service implementation
func NewOrderServiceImpl(repo repository.OrderRepository, uc usecase.OrderUsecase) *OrderServiceImpl {
	return &OrderServiceImpl{
		repository: repo,
		usecase:    uc,
	}
}

// CreateOrder implements the CreateOrder RPC
func (s *OrderServiceImpl) CreateOrder(ctx context.Context, req *pb.CreateOrderRequest) (*pb.CreateOrderResponse, error) {
	log.Printf("gRPC: CreateOrder called for user %s", req.UserId)

	if req.UserId == "" || req.RestaurantId == "" {
		return nil, ErrInvalidRequest
	}

	order := &Order{
		UserID:       req.UserId,
		RestaurantID: req.RestaurantId,
		Items:        convertProtoItems(req.Items),
		Status:       "pending",
	}

	createdOrder, err := s.usecase.CreateOrder(ctx, order)
	if err != nil {
		log.Printf("Error creating order: %v", err)
		return nil, err
	}

	return &pb.CreateOrderResponse{
		Order: convertOrderToProto(createdOrder),
	}, nil
}

// GetOrder implements the GetOrder RPC
func (s *OrderServiceImpl) GetOrder(ctx context.Context, req *pb.GetOrderRequest) (*pb.GetOrderResponse, error) {
	log.Printf("gRPC: GetOrder called for order %s", req.OrderId)

	if req.OrderId == "" {
		return nil, ErrInvalidRequest
	}

	order, err := s.usecase.GetOrder(ctx, req.OrderId)
	if err != nil {
		log.Printf("Error getting order: %v", err)
		return nil, err
	}

	return &pb.GetOrderResponse{
		Order: convertOrderToProto(order),
	}, nil
}

// UpdateOrderStatus implements the UpdateOrderStatus RPC
func (s *OrderServiceImpl) UpdateOrderStatus(ctx context.Context, req *pb.UpdateOrderStatusRequest) (*pb.UpdateOrderStatusResponse, error) {
	log.Printf("gRPC: UpdateOrderStatus called for order %s", req.OrderId)

	if req.OrderId == "" || req.Status == "" {
		return nil, ErrInvalidRequest
	}

	order, err := s.usecase.UpdateOrderStatus(ctx, req.OrderId, req.Status)
	if err != nil {
		log.Printf("Error updating order status: %v", err)
		return nil, err
	}

	return &pb.UpdateOrderStatusResponse{
		Order: convertOrderToProto(order),
	}, nil
}

// ListOrders implements the ListOrders RPC
func (s *OrderServiceImpl) ListOrders(ctx context.Context, req *pb.ListOrdersRequest) (*pb.ListOrdersResponse, error) {
	log.Printf("gRPC: ListOrders called for user %s", req.UserId)

	if req.UserId == "" {
		return nil, ErrInvalidRequest
	}

	orders, err := s.usecase.ListUserOrders(ctx, req.UserId)
	if err != nil {
		log.Printf("Error listing orders: %v", err)
		return nil, err
	}

	protoOrders := make([]*pb.Order, len(orders))
	for i, o := range orders {
		protoOrders[i] = convertOrderToProto(o)
	}

	return &pb.ListOrdersResponse{
		Orders: protoOrders,
	}, nil
}

// Helper functions

func convertProtoItems(items []*pb.OrderItem) []OrderItem {
	result := make([]OrderItem, len(items))
	for i, item := range items {
		result[i] = OrderItem{
			DishID:   item.DishId,
			Quantity: int(item.Quantity),
			Price:    float64(item.Price),
		}
	}
	return result
}

func convertOrderToProto(order *Order) *pb.Order {
	items := make([]*pb.OrderItem, len(order.Items))
	for i, item := range order.Items {
		items[i] = &pb.OrderItem{
			Id:       item.ID,
			DishId:   item.DishID,
			Quantity: int32(item.Quantity),
			Price:    float32(item.Price),
		}
	}

	return &pb.Order{
		Id:            order.ID,
		UserId:        order.UserID,
		RestaurantId:  order.RestaurantID,
		TotalAmount:   float32(order.TotalAmount),
		Status:        order.Status,
		PaymentStatus: order.PaymentStatus,
		Items:         items,
		CreatedAt:     order.CreatedAt.Unix(),
		UpdatedAt:     order.UpdatedAt.Unix(),
	}
}

// Order domain model
type Order struct {
	ID            string
	UserID        string
	RestaurantID  string
	Items         []OrderItem
	TotalAmount   float64
	Status        string
	PaymentStatus string
	CreatedAt     time.Time
	UpdatedAt     time.Time
}

type OrderItem struct {
	ID       string
	DishID   string
	Quantity int
	Price    float64
}

var ErrInvalidRequest = status.Errorf(codes.InvalidArgument, "invalid request")
