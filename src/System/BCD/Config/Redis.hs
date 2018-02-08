{-# LANGUAGE OverloadedStrings #-}

module System.BCD.Config.Redis
  ( RedisConfig (..)
  , GetConfig (..)
  ) where

import           Data.Aeson.Picker ((|--))
import           System.BCD.Config (GetConfig (..), getConfigText)

data RedisConfig = RedisConfig { _host     :: String
                               , _port     :: Int
                               , _user     :: String
                               , _password :: String
                               , _descr    :: String
                               }
  deriving (Show, Read, Eq)


instance GetConfig RedisConfig where
  getConfig = do
      jsonText <- getConfigText
      let get field = jsonText |-- ["deploy", "redis", field]
      pure $ RedisConfig (get "host")
                         (get "port")
                         (get "user")
                         (get "password")
                         (get "descr")
