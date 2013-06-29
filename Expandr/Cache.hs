module Expandr.Cache where

import qualified Data.Map as M
import qualified Data.ByteString.Lazy as B
import Data.Aeson
import System.Directory (doesFileExist)

import Expandr.Core

getCachedUnshortened cache url maxRedirects = do
    case M.lookup url cache of
        Just unshortenedUrl -> return unshortenedUrl
        Nothing -> getUnshortened url maxRedirects

loadCache fileName = do
    fileExists <- doesFileExist fileName
    if fileExists
    then B.readFile fileName >>= return . maybe M.empty id . decode
    else return M.empty

saveCache fileName cache = B.writeFile fileName $ encode cache
