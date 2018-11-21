module System.BCD.Config.BioSources
  (
    BioSourcesConfig (..)
  , FromJsonConfig (..)
  ) where

import           Data.Aeson.Picker ((|--))
import           System.BCD.Config (FromJsonConfig (..), getConfigText)

-- | This class contains information where to find files that are related to
-- semantic common used library [bio-sources](https://github.com/biocad/bio-sources).
-- That library includes dihedral angles, kmers, ideal aminoacids and functions to work with them.
newtype BioSourcesConfig = BioSourcesConfig { bioSourcesPath :: FilePath }
  deriving (Show, Read, Eq)

instance FromJsonConfig BioSourcesConfig where
  fromJsonConfig = do
      jsonText <- getConfigText
      let path = jsonText |-- ["deploy", "fs", "bio-sources"]
      pure $ BioSourcesConfig path
