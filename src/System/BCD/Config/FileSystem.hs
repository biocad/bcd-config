{-# LANGUAGE OverloadedStrings #-}

module System.BCD.Config.FileSystem
  ( FileSystemConfig (..)
  , FromJsonConfig (..)
  ) where

import           Data.Aeson.Picker   ((|--))
import           Data.HashMap.Strict (HashMap)
import           System.BCD.Config   (FromJsonConfig (..), getConfigText)

newtype FileSystemConfig = FileSystemConfig (HashMap String FilePath)
  deriving (Show, Read, Eq)

instance FromJsonConfig FileSystemConfig where
  fromJsonConfig = do
      jsonText <- getConfigText    
      let fs = jsonText |-- ["deploy", "fs"]
      pure $ FileSystemConfig fs
