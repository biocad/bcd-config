{-# LANGUAGE OverloadedStrings #-}

module System.BCD.Config.Mongo
  ( MongoConfig (..)
  , GetConfig (..)
  ) where

import           Data.Aeson.Picker   ((|--))
import           System.BCD.Config   (GetConfig (..), getConfigText)

data MongoConfig = MongoConfig { _host     :: String
                               , _port     :: Int
                               , _user     :: String
                               , _password :: String
                               , _descr    :: String
                               }
  deriving (Show, Read, Eq)

instance GetConfig MongoConfig where
  getConfig = do
      jsonText <- getConfigText
      let get field = jsonText |-- ["deploy", "mongo", field]
      pure $ MongoConfig (get "host")
                         (get "port")
                         (get "user")
                         (get "password")
                         (get "descr")
