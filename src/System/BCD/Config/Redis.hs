module System.BCD.Config.Redis
  (
    RedisConfig (..)
  , FromJsonConfig (..)
  , FromDotenv (..)
  , loadDotenv
  , host
  , port
  , user
  , password
  , descr
  ) where

import           Control.DeepSeq   (NFData)
import           Control.Monad     (void)
import           Control.Lens      (makeLenses)
import           Data.Aeson        (FromJSON (..), ToJSON (..),
                                    genericParseJSON, genericToJSON)
import           Data.Aeson.Casing (aesonDrop, snakeCase)
import           Data.Aeson.Picker ((|--))
import           GHC.Generics      (Generic)
import           System.BCD.Config (FromDotenv (..), FromJsonConfig (..),
                                    GetEnv (..), getConfigText, loadDotenv)

data RedisConfig = RedisConfig { _host     :: String
                               , _port     :: Int
                               , _user     :: String
                               , _password :: String
                               , _descr    :: String
                               }
  deriving (Show, Read, Eq, Generic)

makeLenses ''RedisConfig

instance NFData RedisConfig

instance ToJSON RedisConfig where
  toJSON = genericToJSON $ aesonDrop 1 snakeCase
instance FromJSON RedisConfig where
  parseJSON = genericParseJSON $ aesonDrop 1 snakeCase

instance FromJsonConfig RedisConfig where
  fromJsonConfig = do
      config <- getConfigText
      pure $ config |-- ["deploy", "redis"]

instance FromDotenv RedisConfig where
  fromDotenv = do
      void loadDotenv
      _host     <- getEnv "REDIS_HOST"
      _port     <- getEnv "REDIS_PORT"
      _user     <- getEnv "REDIS_USER"
      _password <- getEnv "REDIS_PASSWORD"
      _descr    <- getEnv "REDIS_DESCR"
      pure RedisConfig{..}
