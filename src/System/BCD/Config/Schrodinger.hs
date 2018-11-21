module System.BCD.Config.Schrodinger
  (
    SchrodingerConfig (..)
  , FromJsonConfig (..)
  , host
  , port
  , user
  , password
  ) where

import           Control.Lens      (makeLenses)
import           Data.Aeson        (FromJSON (..), ToJSON (..),
                                    genericParseJSON, genericToJSON)
import           Data.Aeson.Casing (aesonDrop, snakeCase)
import           Data.Aeson.Picker ((|--))
import           GHC.Generics      (Generic)
import           System.BCD.Config (FromJsonConfig (..), getConfigText)

data SchrodingerConfig = SchrodingerConfig { _host     :: String
                                           , _port     :: Int
                                           , _user     :: String
                                           , _password :: String
                                           }
  deriving (Show, Read, Eq, Generic)

makeLenses ''SchrodingerConfig

instance ToJSON SchrodingerConfig where
  toJSON = genericToJSON $ aesonDrop 1 snakeCase
instance FromJSON SchrodingerConfig where
  parseJSON = genericParseJSON $ aesonDrop 1 snakeCase

instance FromJsonConfig SchrodingerConfig where
  fromJsonConfig = do
      config <- getConfigText
      pure $ config |-- ["deploy", "schrodinger"]
