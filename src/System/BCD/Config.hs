module System.BCD.Config
  ( GetConfig (..)
  , getConfigText
  ) where

import           Control.Applicative ((<|>))
import           Data.List           (find, isPrefixOf)
import           Data.Maybe          (fromJust)
import           Data.Text           (Text)
import           Data.Text.IO        (readFile)
import           Prelude             hiding (readFile)
import           System.Environment  (getArgs)

class GetConfig a where
  getConfig :: IO a

{-|
  The 'getConfig' function returns 'Text' in 'IO' monad with content of JSON file with config.
  More information on JSON config file convention is availeble here:
  <https://api.biocad.ru/Infrastructure/%D0%9A%D0%BE%D0%BD%D0%B2%D0%B5%D0%BD%D1%86%D0%B8%D0%B8/config.json>

  This function will looks for config file with such params:
  @
  ./some-application --config-file=/path/to/config.json
  ./some-application -f /path/to/config.json
  @
  By default it is looking for @config.json@ in current directory.
-}
getConfigText :: IO Text
getConfigText = do
    args <- getArgs
    let path = fromJust $ findLong args <|> findShort args <|> Just "config.json"
    readFile path
  where
    longArg = "--config-file="

    findLong :: [String] -> Maybe FilePath
    findLong args = drop (length longArg) <$> find (longArg `isPrefixOf`) args

    findShort :: [String] -> Maybe FilePath
    findShort ("-f":xs) = pure . head $ xs
    findShort (_:xs)    = findShort xs
    findShort _         = Nothing
