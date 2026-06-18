package cache

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/redis/go-redis/v9"
	"github.com/vikashkp9030/zomato/shared/pkg/logger"
)

// RedisCache represents a Redis cache client
type RedisCache struct {
	client *redis.Client
}

// RedisConfig contains Redis configuration
type RedisConfig struct {
	Addr     string
	DB       int
	PoolSize int
	Password string
}

// NewRedisCache creates a new Redis cache instance
func NewRedisCache(addr string) (*RedisCache, error) {
	return NewRedisCacheWithConfig(RedisConfig{
		Addr:     addr,
		DB:       0,
		PoolSize: 10,
	})
}

// NewRedisCacheWithConfig creates a new Redis cache with custom config
func NewRedisCacheWithConfig(config RedisConfig) (*RedisCache, error) {
	if config.PoolSize == 0 {
		config.PoolSize = 10
	}

	client := redis.NewClient(&redis.Options{
		Addr:     config.Addr,
		DB:       config.DB,
		Password: config.Password,
		PoolSize: config.PoolSize,
	})

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := client.Ping(ctx).Err(); err != nil {
		logger.Error("Failed to connect to Redis", "error", err.Error(), "addr", config.Addr)
		return nil, err
	}

	logger.Info("Connected to Redis", "address", config.Addr, "db", config.DB)
	return &RedisCache{client}, nil
}

// Set sets a JSON-serialized value with expiry
func (rc *RedisCache) Set(ctx context.Context, key string, value interface{}, expiry time.Duration) error {
	data, err := json.Marshal(value)
	if err != nil {
		logger.Error("Failed to marshal value", "key", key, "error", err.Error())
		return err
	}
	return rc.client.Set(ctx, key, data, expiry).Err()
}

// Get retrieves and deserializes a value
func (rc *RedisCache) Get(ctx context.Context, key string, dest interface{}) error {
	val, err := rc.client.Get(ctx, key).Result()
	if err == redis.Nil {
		return nil
	}
	if err != nil {
		logger.Error("Failed to get value from Redis", "key", key, "error", err.Error())
		return err
	}
	return json.Unmarshal([]byte(val), dest)
}

// Delete removes one or more keys
func (rc *RedisCache) Delete(ctx context.Context, keys ...string) error {
	if len(keys) == 0 {
		return nil
	}
	return rc.client.Del(ctx, keys...).Err()
}

// Exists checks if a key exists
func (rc *RedisCache) Exists(ctx context.Context, key string) (bool, error) {
	val, err := rc.client.Exists(ctx, key).Result()
	return val > 0, err
}

// Increment increments a numeric value
func (rc *RedisCache) Increment(ctx context.Context, key string, delta int64) (int64, error) {
	return rc.client.IncrBy(ctx, key, delta).Result()
}

// SetString sets a string value with expiry
func (rc *RedisCache) SetString(ctx context.Context, key, value string, expiry time.Duration) error {
	return rc.client.Set(ctx, key, value, expiry).Err()
}

// GetString retrieves a string value
func (rc *RedisCache) GetString(ctx context.Context, key string) (string, error) {
	return rc.client.Get(ctx, key).Result()
}

// SetHash sets a hash map in Redis
func (rc *RedisCache) SetHash(ctx context.Context, key string, values map[string]interface{}) error {
	return rc.client.HSet(ctx, key, values).Err()
}

// GetHash retrieves a hash map from Redis
func (rc *RedisCache) GetHash(ctx context.Context, key string) (map[string]string, error) {
	return rc.client.HGetAll(ctx, key).Result()
}

// AppendToList appends values to a list
func (rc *RedisCache) AppendToList(ctx context.Context, key string, values ...interface{}) error {
	return rc.client.RPush(ctx, key, values...).Err()
}

// GetList retrieves a list of values
func (rc *RedisCache) GetList(ctx context.Context, key string) ([]string, error) {
	return rc.client.LRange(ctx, key, 0, -1).Result()
}

// SetExpiry sets the expiration time for a key
func (rc *RedisCache) SetExpiry(ctx context.Context, key string, expiry time.Duration) error {
	return rc.client.Expire(ctx, key, expiry).Err()
}

// TTL gets the remaining time to live for a key
func (rc *RedisCache) TTL(ctx context.Context, key string) (time.Duration, error) {
	return rc.client.TTL(ctx, key).Result()
}

// FlushDB clears all keys from the current database
func (rc *RedisCache) FlushDB(ctx context.Context) error {
	return rc.client.FlushDB(ctx).Err()
}

// Keys retrieves all keys matching a pattern
func (rc *RedisCache) Keys(ctx context.Context, pattern string) ([]string, error) {
	return rc.client.Keys(ctx, pattern).Result()
}

// Ping tests the connection to Redis
func (rc *RedisCache) Ping(ctx context.Context) (string, error) {
	return rc.client.Ping(ctx).Result()
}

// Close closes the Redis connection
func (rc *RedisCache) Close() error {
	if rc.client == nil {
		return nil
	}
	logger.Info("Closing Redis connection")
	return rc.client.Close()
}

// GetClient returns the underlying Redis client
func (rc *RedisCache) GetClient() *redis.Client {
	return rc.client
}

// MustConnect creates a Redis cache and panics on error
func MustConnect(addr string) *RedisCache {
	cache, err := NewRedisCache(addr)
	if err != nil {
		panic(fmt.Sprintf("Failed to connect to Redis: %v", err))
	}
	return cache
}
