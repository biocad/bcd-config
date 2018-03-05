{-# LANGUAGE OverloadedStrings #-}

module System.BCD.Config.Mysql
  ( MysqlConfig (..)
  , FromJsonConfig (..)
  ) where

import           Data.Aeson.Picker   ((|--))
import           System.BCD.Config   (FromJsonConfig (..), getConfigText)

data MysqlConfig = MysqlConfig { _host     :: String
                               , _port     :: Int
                               , _user     :: String
                               , _password :: String
                               , _descr    :: String
                               }
  deriving (Show, Read, Eq)

instance FromJsonConfig MysqlConfig where
  fromJsonConfig = do
      jsonText <- getConfigText
      let get field = jsonText |-- ["deploy", "mysql", field]
      pure $ MysqlConfig (get "host")
                         (get "port")
                         (get "user")
                         (get "password")
                         (get "descr")
