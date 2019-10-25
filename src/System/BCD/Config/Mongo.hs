module System.BCD.Config.Mongo
  (
    MongoConfig (..)
  , FromJsonConfig (..)
  , FromDotenv (..)
  , loadDotenv
  , host
  , port
  , user
  , password
  , database
  , descr
  ) where

import           Control.DeepSeq   (NFData)
import           Control.Lens      (makeLenses)
import           Control.Monad     (void)
import           Data.Aeson        (FromJSON (..), ToJSON (..),
                                    genericParseJSON, genericToJSON)
import           Data.Aeson.Casing (aesonDrop, snakeCase)
import           Data.Aeson.Picker ((|--))
import           GHC.Generics      (Generic)
import           System.BCD.Config (FromDotenv (..), FromJsonConfig (..),
                                    GetEnv (..), getConfigText, loadDotenv)

data MongoConfig = MongoConfig { _host     :: String
                               , _port     :: Int
                               , _user     :: String
                               , _password :: String
                               , _database :: String
                               , _descr    :: String
                               }
  deriving (Show, Read, Eq, Generic)

makeLenses ''MongoConfig

instance NFData MongoConfig

instance ToJSON MongoConfig where
  toJSON = genericToJSON $ aesonDrop 1 snakeCase
instance FromJSON MongoConfig where
  parseJSON = genericParseJSON $ aesonDrop 1 snakeCase

instance FromJsonConfig MongoConfig where
  fromJsonConfig = do
      config <- getConfigText
      pure $ config |-- ["deploy", "mongo"]

instance FromDotenv MongoConfig where
  fromDotenv = do
      void loadDotenv
      _host     <- getEnv "MONGO_HOST"
      _port     <- getEnv "MONGO_PORT"
      _user     <- getEnv "MONGO_USER"
      _password <- getEnv "MONGO_PASSWORD"
      _database <- getEnv "MONGO_DATABASE"
      _descr    <- getEnv "MONGO_DESCR"
      pure MongoConfig{..}
