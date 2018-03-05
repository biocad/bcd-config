{-# LANGUAGE OverloadedStrings #-}

module System.BCD.Config.Schrodinger
  ( SchrodingerConfig (..)
  , FromJsonConfig (..)
  ) where

import           Data.Aeson.Picker ((|--))
import           System.BCD.Config (FromJsonConfig (..), getConfigText)

data SchrodingerConfig = SchrodingerConfig { _host     :: String
                                           , _port     :: Int
                                           , _user     :: String
                                           , _password :: String
                                           }
  deriving (Show, Read, Eq)

instance FromJsonConfig SchrodingerConfig where
  fromJsonConfig = do
      jsonText <- getConfigText
      let get field = jsonText |-- ["deploy", "schrodinger", field]
      pure $ SchrodingerConfig (get "host")
                               (get "port")
                               (get "user")
                               (get "password")
