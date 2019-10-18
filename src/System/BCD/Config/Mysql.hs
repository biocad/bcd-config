module System.BCD.Config.Mysql
  (
    MysqlConfig (..)
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

data MysqlConfig = MysqlConfig { _host     :: String
                               , _port     :: Int
                               , _user     :: String
                               , _password :: String
                               , _database :: String
                               , _descr    :: String
                               }
  deriving (Show, Read, Eq, Generic)

makeLenses ''MysqlConfig

instance NFData MysqlConfig

instance ToJSON MysqlConfig where
  toJSON = genericToJSON $ aesonDrop 1 snakeCase
instance FromJSON MysqlConfig where
  parseJSON = genericParseJSON $ aesonDrop 1 snakeCase

instance FromJsonConfig MysqlConfig where
  fromJsonConfig = do
      config <- getConfigText
      pure $ config |-- ["deploy", "mysql"]

instance FromDotenv MysqlConfig where
  fromDotenv = do
      void loadDotenv
      _host     <- getEnv "MYSQL_HOST"
      _port     <- getEnv "MYSQL_PORT"
      _user     <- getEnv "MYSQL_USER"
      _password <- getEnv "MYSQL_PASSWORD"
      _database <- getEnv "MYSQL_DATABASE"
      _descr    <- getEnv "MYSQL_DESCR"
      pure MysqlConfig{..}
