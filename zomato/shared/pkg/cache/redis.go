package cache

import (
	"context"
	"encoding/json"
	"time"

	"github.com/redis/go-redis/v9"
	"github.com/vikashkp9030/zomato/shared/pkg/logger"
)

type RedisCache struct {
	client *redis.Client
}

func NewRedisCache(addr string) (*RedisCache, error) {
	client := redis.NewClient(&redis.Options{
		Addr:     addr,
		DB:       0,
		PoolSize: 10,
	})

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := client.Ping(ctx).Err(); err != nil {
		logger.Error("Failed to connect to Redis", "error", err.Error())
		return nil, err
	}

	logger.Info("Connected to Redis", "address", addr)
	return &RedisCache{client}, nil
}

func (rc *RedisCache) Set(ctx context.Context, key string, value interface{}, expiry time.Duration) error {
	data, err := json.Marshal(value)
	if err != nil {
		return err
	}
	return rc.client.Set(ctx, key, data, expiry).Err()
}

func (rc *RedisCache) Get(ctx context.Context, key string, dest interface{}) error {
	val, err := rc.client.Get(ctx, key).Result()
	if err == redis.Nil {
		return nil
	}
	if err != nil {
		return err
	}
	return json.Unmarshal([]byte(val), dest)
}

func (rc *RedisCache) Delete(ctx context.Context, keys ...string) error {
	return rc.client.Del(ctx, keys...).Err()
}

func (rc *RedisCache) Exists(ctx context.Context, key string) (bool, error) {
	val, err := rc.client.Exists(ctx, key).Result()
	return val > 0, err
}

func (rc *RedisCache) Increment(ctx context.Context, key string, delta int64) (int64, error) {
	return rc.client.IncrBy(ctx, key, delta).Result()
}

func (rc *RedisCache) SetString(ctx context.Context, key, value string, expiry time.Duration) error {
	return rc.client.Set(ctx, key, value, expiry).Err()
}

func (rc *RedisCache) GetString(ctx context.Context, key string) (string, error) {
	return rc.client.Get(ctx, key).Result()
}

func (rc *RedisCache) Close() error {
	return rc.client.Close()
}
