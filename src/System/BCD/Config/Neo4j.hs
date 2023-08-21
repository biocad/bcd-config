module System.BCD.Config.Neo4j
  (
    Neo4jConfig (..)
  , FromJsonConfig (..)
  , FromDotenv (..)
  , loadDotenv
  , host
  , port
  , user
  , password
  , stripes
  , timeout
  , rps
  , descr
  , version
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

data Neo4jConfig = Neo4jConfig { _host     :: String
                               , _port     :: Int
                               , _user     :: String
                               , _password :: String
                               , _stripes  :: Int
                               , _timeout  :: Int
                               , _rps      :: Int
                               , _descr    :: String
                               , _version  :: Maybe Int
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

instance FromDotenv Neo4jConfig where
  fromDotenv = do
      void loadDotenv
      _host     <- getEnv "NEO4J_HOST"
      _port     <- getEnv "NEO4J_PORT"
      _user     <- getEnv "NEO4J_USER"
      _password <- getEnv "NEO4J_PASSWORD"
      _stripes  <- getEnv "NEO4J_STRIPES"
      _timeout  <- getEnv "NEO4J_TIMEOUT"
      _rps      <- getEnv "NEO4J_RPS"
      _descr    <- getEnv "NEO4J_DESCR"
      _version  <- getEnvMaybe "NEO4J_BOLT_VERSION"
      pure Neo4jConfig{..}
