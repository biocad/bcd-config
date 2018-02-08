{-# LANGUAGE OverloadedStrings #-}

module System.BCD.Config.Neo4j
  ( Neo4jConfig (..)
  , GetConfig (..)
  ) where

import           Data.Aeson.Picker ((|--))
import           System.BCD.Config (GetConfig (..), getConfigText)

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

instance GetConfig Neo4jConfig where
  getConfig = do
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
