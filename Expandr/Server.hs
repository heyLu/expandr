{-# LANGUAGE OverloadedStrings #-}
-- | Server component. A simple scotty app that uses core and cache.
module Expandr.Server where

import Web.Scotty
import Network.Wai
import Data.Aeson hiding (json)
import Control.Monad (when)
import Control.Monad.IO.Class (liftIO)
import Data.IORef
import qualified Data.Map as M
import qualified Data.Text as TS
import qualified Data.Text.Lazy as T

import Expandr.Core (i)
import Expandr.Cache (g')
import Expandr.ScottyExtensions

h :: T.Text
h = T.concat [
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

data R = R {
    o :: String,
    e :: String,
    m :: M.Map String String
} deriving (Show)

instance ToJSON R where
    toJSON (R s u m) =
        object $ [
            "originalUrl" .= s,
            "expandedUrl" .= u] ++
            map (\(k,v) -> TS.pack k .= v) (M.toList m)

g'' :: IORef (M.Map String String) -> String -> ActionM String
g'' r u = do
    c <- liftIO $ readIORef r
    u' <- liftIO $ g' c u 5
    when (i u && (not $ M.member u c)) $ liftIO $ do
        putStrLn $ "cache insert: " ++ show (u, u')
        modifyIORef r (M.insert u u')
    return u'

s :: IO Application
s = scottyApp $ do
    r <- liftIO $ newIORef M.empty
    get "/" $ do
        u <- param "url"
        u' <- g'' r u
        n $ \t -> case t of
            J -> json $ R u u' M.empty
            _ -> text . T.pack $ u'
    get "/help" $ do
        text $ h
