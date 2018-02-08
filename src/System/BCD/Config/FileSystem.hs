{-# LANGUAGE OverloadedStrings #-}

module System.BCD.Config.FileSystem
  ( FileSystemConfig (..)
  , GetConfig (..)
  ) where

import           Data.Aeson.Picker   ((|--))
import           Data.HashMap.Strict (HashMap)
import           System.BCD.Config   (GetConfig (..), getConfigText)

newtype FileSystemConfig = FileSystemConfig (HashMap String FilePath)
  deriving (Show, Read, Eq)

instance GetConfig FileSystemConfig where
  getConfig = do
      jsonText <- getConfigText    
      let fs = jsonText |-- ["deploy", "fs"]
      pure $ FileSystemConfig fs
