{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE TypeSynonymInstances #-}

module System.BCD.Config
  (
    FromDotenv (..)
  , GetEnv (..)
  , loadDotenv
  , FromJsonConfig (..)
  , getConfigText
  ) where

import           Configuration.Dotenv   (defaultConfig, loadFile)
import           Control.Applicative    ((<|>))
import           Control.Monad          (void)
import           Control.Monad.IO.Class (MonadIO, liftIO)
import           Data.List              (find, isPrefixOf)
import           Data.Maybe             (fromJust, maybe)
import           Data.Text              as T (Text, pack)
import           Data.Text.IO           (readFile)
import           Prelude                hiding (readFile)
import           System.Environment     (getArgs, lookupEnv)
--
-------------------------------------------------------------------------------
-- dotenv
-------------------------------------------------------------------------------

-- | Describes possibility to read something from dotenv configuration.
--
class FromDotenv a where
  fromDotenv :: MonadIO m => m a

loadDotenv :: MonadIO m => m ()
loadDotenv = liftIO $ void $ loadFile defaultConfig

class GetEnv a where
  getEnv :: MonadIO m => String -> m a
  getEnv key = do
      valueM <- liftIO $ lookupEnv key
      maybe (error $ "bcd-config: could not find environment <" <> key <> ">") (pure . convert) valueM

  convert :: String -> a

instance GetEnv String where
  convert = id

instance GetEnv Text where
  convert = T.pack

instance GetEnv Int where
  convert = read

instance GetEnv Float where
  convert = read

instance GetEnv Bool where
  convert = read

-------------------------------------------------------------------------------
-- config.json
-------------------------------------------------------------------------------

-- | class 'FromJsonConfig' describes possibility to read something from configutaion.
--
class FromJsonConfig a where
  fromJsonConfig :: MonadIO m => m a

{-|
  The 'getConfig' function returns 'Text' in 'IO' monad with content of JSON file with config.
  More information on JSON config file convention is available here: <https://wiki.math.bio/x/JwAvAw>.

  This function will looks for config file with such params:
  @
  ./some-application --config-file=/path/to/config.json
  ./some-application -f /path/to/config.json
  @
  By default it is looking for @config.json@ in current directory.
-}
getConfigText :: MonadIO m => m Text
getConfigText = do
    args <- liftIO getArgs
    let path = fromJust $ findLong args <|> findShort args <|> Just "config.json"
    liftIO $ readFile path
  where
    longArg = "--config-file="

    findLong :: [String] -> Maybe FilePath
    findLong args = drop (length longArg) <$> find (longArg `isPrefixOf`) args

    findShort :: [String] -> Maybe FilePath
    findShort ("-f":xs) = pure . head $ xs
    findShort (_:xs)    = findShort xs
    findShort _         = Nothing
