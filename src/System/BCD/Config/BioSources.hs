module System.BCD.Config.BioSources
  (
    BioSourcesConfig (..)
  , FromJsonConfig (..)
  , FromDotenv (..)
  , loadDotenv
  ) where

import           Control.DeepSeq   (NFData)
import           Control.Monad     (void)
import           Data.Aeson.Picker ((|--))
import           GHC.Generics      (Generic)
import           System.BCD.Config (FromDotenv (..), FromJsonConfig (..),
                                    GetEnv (..), getConfigText, loadDotenv)

-- | This class contains information where to find files that are related to
-- semantic common used library [bio-sources](https://github.com/biocad/bio-sources).
-- That library includes dihedral angles, kmers, ideal aminoacids and functions to work with them.
newtype BioSourcesConfig = BioSourcesConfig { bioSourcesPath :: FilePath }
  deriving (Show, Read, Eq, Generic)

instance NFData BioSourcesConfig

instance FromJsonConfig BioSourcesConfig where
  fromJsonConfig = do
      jsonText <- getConfigText
      let path = jsonText |-- ["deploy", "fs", "bio-sources"]
      pure $ BioSourcesConfig path

instance FromDotenv BioSourcesConfig where
  fromDotenv = do
      void loadDotenv
      bioSourcesPath <- getEnv "BIOSOURCES_PATH"
      pure BioSourcesConfig{..}
