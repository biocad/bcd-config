{-# LANGUAGE OverloadedStrings #-}

module System.BCD.Config.Postgres
  ( PostgresConfig (..)
  , GetConfig (..)
  ) where

import           Data.Aeson.Picker   ((|--))
import           System.BCD.Config   (GetConfig (..), getConfigText)

data PostgresConfig = PostgresConfig { _host     :: String
                                     , _port     :: Int
                                     , _user     :: String
                                     , _password :: String
                                     , _descr    :: String
                                     }
  deriving (Show, Read, Eq)

instance GetConfig PostgresConfig where
  getConfig = do
      jsonText <- getConfigText
      let get field = jsonText |-- ["deploy", "postgres", field]
      pure $ PostgresConfig (get "host")
                            (get "port")
                            (get "user")
                            (get "password")
                            (get "descr")
