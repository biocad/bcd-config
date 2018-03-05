{-# LANGUAGE OverloadedStrings #-}

module System.BCD.Config.Neo4j
  ( Neo4jConfig (..)
  , FromJsonConfig (..)
  ) where

import           Data.Aeson.Picker ((|--))
import           System.BCD.Config (FromJsonConfig (..), getConfigText)

data Neo4jConfig = Neo4jConfig { _host     :: String
                               , _port     :: Int
                               , _user     :: String
                               , _password :: String
                               , _stripes  :: Int
                               , _timeout  :: Int
                               , _rps      :: Int
                               , _descr    :: String
                               }
  deriving (Show, Read, Eq)

instance FromJsonConfig Neo4jConfig where
  fromJsonConfig = do
      jsonText <- getConfigText
      let get field = jsonText |-- ["deploy", "neo4j", field]
      pure $ Neo4jConfig (get "host")
                         (get "port")
                         (get "user")
                         (get "password")
                         (get "stripes")
                         (get "timeout")
                         (get "rps")
                         (get "descr")
