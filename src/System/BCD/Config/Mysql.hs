{-# LANGUAGE OverloadedStrings #-}

module System.BCD.Config.Mysql
  ( MysqlConfig (..)
  , GetConfig (..)
  ) where

import           Data.Aeson.Picker   ((|--))
import           System.BCD.Config   (GetConfig (..), getConfigText)

data MysqlConfig = MysqlConfig { _host     :: String
                               , _port     :: Int
                               , _user     :: String
                               , _password :: String
                               , _descr    :: String
                               }
  deriving (Show, Read, Eq)

instance GetConfig MysqlConfig where
  getConfig = do
      jsonText <- getConfigText
      let get field = jsonText |-- ["deploy", "mysql", field]
      pure $ MysqlConfig (get "host")
                         (get "port")
                         (get "user")
                         (get "password")
                         (get "descr")
