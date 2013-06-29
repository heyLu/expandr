{-# LANGUAGE OverloadedStrings #-}
-- | Server component. A simple scotty app that uses core and cache.
module Expandr.Server where

import Web.Scotty
import Network.Wai
import Control.Monad (when)
import Control.Monad.IO.Class (liftIO)
import Data.IORef
import qualified Data.Map as M
import qualified Data.Text.Lazy as T

import Expandr.Core (isShortened)
import Expandr.Cache (getCachedUnshortened)

help :: T.Text
help = T.concat [
    "expandr - expandr'ing for great good!",
    "\n\n",
    "endpoints:\n",
    "/{?url} - expand the given url\n",
    "\texpands if url is a shortened one, otherwise just returns the given url\n",
    "/help - documentation\n",
    "\n",
    "misc\n",
    "- why? because the world needs it, SCIENCE!\n",
    "- written in Haskell, not yet very pretty\n",
    "- you're invited to improve this thing: https://github.com/heyLu/expandr\n",
    "\n",
    "love,\n lu"
    ]

server :: IO Application
server = scottyApp $ do
    cacheRef <- liftIO $ newIORef M.empty
    get "/" $ do
        cache <- liftIO $ readIORef cacheRef
        url <- param "url"
        unshortened <- liftIO $ getCachedUnshortened cache url 5
        when (isShortened url && (not $ M.member url cache)) $ liftIO $ do
            putStrLn $ "cache insert: " ++ show (url, unshortened)
            modifyIORef cacheRef (M.insert url unshortened)
        text $ T.pack unshortened
    get "/help" $ do
        text $ help
