{-# LANGUAGE OverloadedStrings #-}

module System.BCD.Config.Redis
  ( RedisConfig (..)
  , FromJsonConfig (..)
  ) where

import           Data.Aeson.Picker ((|--))
import           System.BCD.Config (FromJsonConfig (..), getConfigText)

data RedisConfig = RedisConfig { _host     :: String
                               , _port     :: Int
                               , _user     :: String
                               , _password :: String
                               , _descr    :: String
                               }
  deriving (Show, Read, Eq)


instance FromJsonConfig RedisConfig where
  fromJsonConfig = do
      jsonText <- getConfigText
      let get field = jsonText |-- ["deploy", "redis", field]
      pure $ RedisConfig (get "host")
                         (get "port")
                         (get "user")
                         (get "password")
                         (get "descr")
