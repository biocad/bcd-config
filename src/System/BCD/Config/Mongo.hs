{-# LANGUAGE OverloadedStrings #-}

module System.BCD.Config.Mongo
  ( MongoConfig (..)
  , FromJsonConfig (..)
  ) where

import           Data.Aeson.Picker ((|--))
import           System.BCD.Config (FromJsonConfig (..), getConfigText)

data MongoConfig = MongoConfig { _host     :: String
                               , _port     :: Int
                               , _user     :: String
                               , _password :: String
                               , _database :: String
                               , _descr    :: String
                               }
  deriving (Show, Read, Eq)

instance FromJsonConfig MongoConfig where
  fromJsonConfig = do
      jsonText <- getConfigText
      let get field = jsonText |-- ["deploy", "mongo", field]
      pure $ MongoConfig (get "host")
                         (get "port")
                         (get "user")
                         (get "password")
                         (get "database")
                         (get "descr")
