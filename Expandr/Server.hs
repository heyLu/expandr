{-# LANGUAGE OverloadedStrings #-}
module Expandr.Server where

import Web.Scotty
import Network.Wai
import Control.Monad.IO.Class (liftIO)
import qualified Data.Text.Lazy as T

import Expandr.Core (getUnshortened)

server :: IO Application
server = scottyApp $ do
    get "/" $ do
        url <- param "url"
        unshortened <- liftIO $ getUnshortened url 5
        text $ T.pack unshortened
