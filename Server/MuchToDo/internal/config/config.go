package config

import (
"os"
"path/filepath"

"github.com/spf13/viper"
)

type Config struct {
ServerPort          string `mapstructure:"PORT"`
MongoURI            string `mapstructure:"MONGO_URI"`
DBName              string `mapstructure:"DB_NAME"`
JWTSecretKey        string `mapstructure:"JWT_SECRET_KEY"`
JWTExpirationHours  int    `mapstructure:"JWT_EXPIRATION_HOURS"`
EnableCache         bool   `mapstructure:"ENABLE_CACHE"`
RedisAddr           string `mapstructure:"REDIS_ADDR"`
RedisPassword       string `mapstructure:"REDIS_PASSWORD"`
LogLevel            string `mapstructure:"LOG_LEVEL"`
LogFormat           string `mapstructure:"LOG_FORMAT"`
}

func LoadConfig(path string) (config Config, err error) {
v := viper.New()
envFile := filepath.Join(path, ".env")

v.SetConfigFile(envFile)
v.SetConfigType("env")
v.AutomaticEnv()

keys := []string{
"PORT",
"MONGO_URI",
"DB_NAME",
"JWT_SECRET_KEY",
"JWT_EXPIRATION_HOURS",
"ENABLE_CACHE",
"REDIS_ADDR",
"REDIS_PASSWORD",
"LOG_LEVEL",
"LOG_FORMAT",
}

for _, key := range keys {
if err := v.BindEnv(key); err != nil {
return config, err
}
}

v.SetDefault("PORT", "8080")
v.SetDefault("ENABLE_CACHE", false)
v.SetDefault("JWT_EXPIRATION_HOURS", 72)

if _, statErr := os.Stat(envFile); statErr == nil {
if err := v.ReadInConfig(); err != nil {
return config, err
}
} else if !os.IsNotExist(statErr) {
return config, statErr
}

err = v.Unmarshal(&config)
return config, err
}
