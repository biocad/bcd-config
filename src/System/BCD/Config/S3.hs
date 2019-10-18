module System.BCD.Config.S3
  (
    S3Config (..)
  , FromJsonConfig (..)
  , FromDotenv (..)
  , loadDotenv
  , Host
  , Port
  , Secret
  , Bucket
  , host
  , port
  , bucket
  , s3key
  , s3secret
  ) where

import           Control.DeepSeq   (NFData)
import           Control.Lens      (makeLenses)
import           Control.Monad     (void)
import           Data.Aeson        (FromJSON (..), ToJSON (..),
                                    genericParseJSON, genericToJSON)
import           Data.Aeson.Casing (aesonDrop, snakeCase)
import           Data.Aeson.Picker ((|--))
import           Data.Text         (Text)
import           GHC.Generics      (Generic)
import           System.BCD.Config (FromDotenv (..), FromJsonConfig (..),
                                    GetEnv (..), getConfigText, loadDotenv)

type Host = Text

type Port = Int

type Secret = Text

type Bucket = Text

data S3Config
   = S3Config { _host     :: Host
              , _port     :: Port
              , _bucket   :: Bucket
              , _s3key    :: Secret
              , _s3secret :: Secret
              }
  deriving (Show, Read, Eq, Generic)

makeLenses ''S3Config

instance NFData S3Config

instance ToJSON S3Config where
  toJSON = genericToJSON $ aesonDrop 1 snakeCase
instance FromJSON S3Config where
  parseJSON = genericParseJSON $ aesonDrop 1 snakeCase

instance FromJsonConfig S3Config where
  fromJsonConfig = do
      config <- getConfigText
      pure $ config |-- ["deploy", "s3"]

instance FromDotenv S3Config where
  fromDotenv = do
      void loadDotenv
      _host   <- getEnv "S3_HOST"
      _port   <- getEnv "S3_PORT"
      _bucket <- getEnv "S3_BUCKET"
      _s3key    <- getEnv "S3_KEY"
      _s3secret <- getEnv "S3_SECRET"
      pure S3Config{..}
