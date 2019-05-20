module System.BCD.Config.Postgres
  (
    PostgresConfig (..)
  , FromJsonConfig (..)
  , host
  , port
  , user
  , password
  , databases
  , descr
  ) where

import           Control.DeepSeq   (NFData)
import           Control.Lens      (makeLenses)
import           Data.Aeson        (FromJSON (..), ToJSON (..),
                                    genericParseJSON, genericToJSON)
import           Data.Aeson.Casing (aesonDrop, snakeCase)
import           Data.Aeson.Picker ((|--))
import           Data.Map.Strict   (Map)
import           Data.Text         (Text)
import           GHC.Generics      (Generic)
import           System.BCD.Config (FromJsonConfig (..), getConfigText)

data PostgresConfig = PostgresConfig { _host      :: String
                                     , _port      :: Int
                                     , _user      :: String
                                     , _password  :: String
                                     , _databases :: Map String Text
                                     , _descr     :: String
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
