module System.BCD.Config.Redis
  (
    RedisConfig (..)
  , FromJsonConfig (..)
  , host
  , port
  , user
  , password
  , descr
  ) where

import           Control.Lens      (makeLenses)
import           Data.Aeson        (FromJSON (..), ToJSON (..),
                                    genericParseJSON, genericToJSON)
import           Data.Aeson.Casing (aesonDrop, snakeCase)
import           Data.Aeson.Picker ((|--))
import           GHC.Generics      (Generic)
import           System.BCD.Config (FromJsonConfig (..), getConfigText)

data RedisConfig = RedisConfig { _host     :: String
                               , _port     :: Int
                               , _user     :: String
                               , _password :: String
                               , _descr    :: String
                               }
  deriving (Show, Read, Eq, Generic)

makeLenses ''RedisConfig

instance ToJSON RedisConfig where
  toJSON = genericToJSON $ aesonDrop 1 snakeCase
instance FromJSON RedisConfig where
  parseJSON = genericParseJSON $ aesonDrop 1 snakeCase

instance FromJsonConfig RedisConfig where
  fromJsonConfig = do
      config <- getConfigText
      pure $ config |-- ["deploy", "redis"]
