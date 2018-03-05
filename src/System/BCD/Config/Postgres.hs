{-# LANGUAGE OverloadedStrings #-}

module System.BCD.Config.Postgres
  ( PostgresConfig (..)
  , FromJsonConfig (..)
  ) where

import           Data.Aeson.Picker   ((|--))
import           System.BCD.Config   (FromJsonConfig (..), getConfigText)

data PostgresConfig = PostgresConfig { _host     :: String
                                     , _port     :: Int
                                     , _user     :: String
                                     , _password :: String
                                     , _descr    :: String
                                     }
  deriving (Show, Read, Eq)

instance FromJsonConfig PostgresConfig where
  fromJsonConfig = do
      jsonText <- getConfigText
      let get field = jsonText |-- ["deploy", "postgres", field]
      pure $ PostgresConfig (get "host")
                            (get "port")
                            (get "user")
                            (get "password")
                            (get "descr")
