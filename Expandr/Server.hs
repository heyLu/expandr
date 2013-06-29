{-# LANGUAGE OverloadedStrings #-}
module Expandr.Server where

import Web.Scotty
import Network.Wai
import Control.Monad (when)
import Control.Monad.IO.Class (liftIO)
import Data.IORef
import qualified Data.Map as M
import qualified Data.Text.Lazy as T

import Expandr.Cache (getCachedUnshortened)

server :: IO Application
server = scottyApp $ do
    cacheRef <- liftIO $ newIORef M.empty
    get "/" $ do
        cache <- liftIO $ readIORef cacheRef
        url <- param "url"
        unshortened <- liftIO $ getCachedUnshortened cache url 5
        when (not $ M.member url cache) . liftIO $ do
            putStrLn $ "cache insert: " ++ show (url, unshortened)
            modifyIORef cacheRef (M.insert url unshortened)
        text $ T.pack unshortened
