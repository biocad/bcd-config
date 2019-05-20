module System.BCD.Config.Neo4j
  (
    Neo4jConfig (..)
  , FromJsonConfig (..)
  , host
  , port
  , user
  , password
  , stripes
  , timeout
  , rps
  , descr
  ) where

import           Control.DeepSeq   (NFData)
import           Control.Lens      (makeLenses)
import           Data.Aeson        (FromJSON (..), ToJSON (..),
                                    genericParseJSON, genericToJSON)
import           Data.Aeson.Casing (aesonDrop, snakeCase)
import           Data.Aeson.Picker ((|--))
import           GHC.Generics      (Generic)
import           System.BCD.Config (FromJsonConfig (..), getConfigText)

data Neo4jConfig = Neo4jConfig { _host     :: String
                               , _port     :: Int
                               , _user     :: String
                               , _password :: String
                               , _stripes  :: Int
                               , _timeout  :: Int
                               , _rps      :: Int
                               , _descr    :: String
                               }
  deriving (Show, Read, Eq, Generic)

makeLenses ''Neo4jConfig

instance NFData Neo4jConfig

instance ToJSON Neo4jConfig where
  toJSON = genericToJSON $ aesonDrop 1 snakeCase
instance FromJSON Neo4jConfig where
  parseJSON = genericParseJSON $ aesonDrop 1 snakeCase

instance FromJsonConfig Neo4jConfig where
  fromJsonConfig = do
      config <- getConfigText
      pure $ config |-- ["deploy", "neo4j"]
