module System.BCD.Config.FileSystem
  (
    FileSystemConfig (..)
  , FromJsonConfig (..)
  ) where

import           Control.DeepSeq     (NFData)
import           Data.Aeson.Picker   ((|--))
import           Data.HashMap.Strict (HashMap)
import           GHC.Generics        (Generic)
import           System.BCD.Config   (FromJsonConfig (..), getConfigText)

newtype FileSystemConfig = FileSystemConfig (HashMap String FilePath)
  deriving (Show, Read, Eq, Generic)

instance NFData FileSystemConfig

instance FromJsonConfig FileSystemConfig where
  fromJsonConfig = do
      jsonText <- getConfigText
      let fs = jsonText |-- ["deploy", "fs"]
      pure $ FileSystemConfig fs
