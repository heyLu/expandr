-- | Very simple cache. Provides cached expandr'ization and can load/save it.
module Expandr.Cache where

import qualified Data.Map as M
import qualified Data.ByteString.Lazy as B
import Data.Aeson
import System.Directory (doesFileExist)

import Expandr.Core

g' :: M.Map String String -> String -> Int -> IO String
g' c u m = do
    case M.lookup u c of
        Just u' -> return u'
        Nothing -> g u m

l :: String -> IO (M.Map String String)
l f = do
    e <- doesFileExist f
    if e
    then B.readFile f >>= return . maybe M.empty id . decode
    else return M.empty

s :: String -> M.Map String String -> IO ()
s f c = B.writeFile f $ encode c
