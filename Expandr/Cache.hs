module Expandr.Cache where

import qualified Data.Map as M

import Expandr.Core

getCachedUnshortened cache url maxRedirects = do
    case M.lookup url cache of
        Just unshortenedUrl -> return unshortenedUrl
        Nothing -> getUnshortened url maxRedirects
