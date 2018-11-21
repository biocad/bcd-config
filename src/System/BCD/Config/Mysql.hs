module System.BCD.Config.Mysql
  (
    MysqlConfig (..)
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

data MysqlConfig = MysqlConfig { _host     :: String
                               , _port     :: Int
                               , _user     :: String
                               , _password :: String
                               , _descr    :: String
                               }
  deriving (Show, Read, Eq, Generic)

makeLenses ''MysqlConfig

instance ToJSON MysqlConfig where
  toJSON = genericToJSON $ aesonDrop 1 snakeCase
instance FromJSON MysqlConfig where
  parseJSON = genericParseJSON $ aesonDrop 1 snakeCase

instance FromJsonConfig MysqlConfig where
  fromJsonConfig = do
      config <- getConfigText
      pure $ config |-- ["deploy", "mysql"]
