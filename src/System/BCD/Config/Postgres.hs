module System.BCD.Config.Postgres
  (
    PostgresConfig (..)
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

data PostgresConfig = PostgresConfig { _host     :: String
                                     , _port     :: Int
                                     , _user     :: String
                                     , _password :: String
                                     , _database :: String
                                     , _descr    :: String
                                     }
  deriving (Show, Read, Eq, Generic)

makeLenses ''PostgresConfig

instance NFData PostgresConfig

instance ToJSON PostgresConfig where
  toJSON = genericToJSON $ aesonDrop 1 snakeCase
instance FromJSON PostgresConfig where
  parseJSON = genericParseJSON $ aesonDrop 1 snakeCase

instance FromJsonConfig PostgresConfig where
  fromJsonConfig = do
      config <- getConfigText
      pure $ config |-- ["deploy", "postgres"]

instance FromDotenv PostgresConfig where
  fromDotenv = do
      void loadDotenv
      _host     <- getEnv "POSTGRES_HOST"
      _port     <- getEnv "POSTGRES_PORT"
      _user     <- getEnv "POSTGRES_USER"
      _password <- getEnv "POSTGRES_PASSWORD"
      _database <- getEnv "POSTGRES_DATABASE"
      _descr    <- getEnv "POSTGRES_DESCR"
      pure PostgresConfig{..}
