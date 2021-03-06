module System.BCD.Config.Schrodinger
  (
    SchrodingerConfig (..)
  , FromJsonConfig (..)
  , FromDotenv (..)
  , loadDotenv
  , host
  , port
  , user
  , password
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

data SchrodingerConfig = SchrodingerConfig { _host     :: String
                                           , _port     :: Int
                                           , _user     :: String
                                           , _password :: String
                                           }
  deriving (Show, Read, Eq, Generic)

makeLenses ''SchrodingerConfig

instance NFData SchrodingerConfig

instance ToJSON SchrodingerConfig where
  toJSON = genericToJSON $ aesonDrop 1 snakeCase
instance FromJSON SchrodingerConfig where
  parseJSON = genericParseJSON $ aesonDrop 1 snakeCase

instance FromJsonConfig SchrodingerConfig where
  fromJsonConfig = do
      config <- getConfigText
      pure $ config |-- ["deploy", "schrodinger"]

instance FromDotenv SchrodingerConfig where
  fromDotenv = do
      void loadDotenv
      _host     <- getEnv "SCHRODINGER_HOST"
      _port     <- getEnv "SCHRODINGER_PORT"
      _user     <- getEnv "SCHRODINGER_USER"
      _password <- getEnv "SCHRODINGER_PASSWORD"
      pure SchrodingerConfig{..}
