{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE ScopedTypeVariables  #-}
{-# LANGUAGE TypeApplications     #-}
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
import           Data.Maybe             (fromJust)
import           Data.Text              as T (Text, pack)
import           Data.Text.IO           (readFile)
import           GHC.Stack              (HasCallStack)
import           Prelude                hiding (readFile)
import           System.Environment     (getArgs, lookupEnv)
import           Text.Read              (readMaybe)
import           Type.Reflection        (Typeable, typeRep)
--
-------------------------------------------------------------------------------
-- dotenv
-------------------------------------------------------------------------------

-- | Describes possibility to read something from dotenv configuration.
--
class FromDotenv a where
  fromDotenv :: (HasCallStack, MonadIO m) => m a

loadDotenv :: MonadIO m => m ()
loadDotenv = liftIO $ void $ loadFile defaultConfig

class Typeable a => GetEnv a where
  getEnv :: (HasCallStack, MonadIO m) => String -> m a
  getEnv key = do
      valueM <- liftIO $ lookupEnv key
      case valueM of
        Nothing -> error $ "bcd-config: could not find environment <" <> key <> ">"
        Just val -> case convertSafe val of
          Nothing -> error $ "bcd-config: could not parse environment <" <> key <> "> = <" <> val <> ">" <> " as type " <> show (typeRep @a)
          Just a -> return a

  convert :: HasCallStack => String -> a
  convert = fromJust . convertSafe

  convertSafe :: HasCallStack => String -> Maybe a

instance GetEnv String where
  convertSafe = Just

instance GetEnv Text where
  convertSafe = Just . T.pack

instance GetEnv Int where
  convertSafe = readMaybe

instance GetEnv Float where
  convertSafe = readMaybe

instance GetEnv Bool where
  convertSafe = readMaybe

-------------------------------------------------------------------------------
-- config.json
-------------------------------------------------------------------------------

-- | class 'FromJsonConfig' describes possibility to read something from configutaion.
--
class FromJsonConfig a where
  fromJsonConfig :: (HasCallStack, MonadIO m) => m a

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
getConfigText :: (HasCallStack, MonadIO m) => m Text
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
