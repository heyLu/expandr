module Main where

import Network.Wai.Handler.Warp (run)
import System.Environment (getArgs)
import Text.Read (readMaybe)
import Control.Monad (forever)
import Data.Map (size)
import Data.IORef (newIORef, readIORef)
import Control.Concurrent (forkIO, threadDelay)

import Expandr.Cache (loadCache, saveCache)
import Expandr.Server (server)

main :: IO ()
main = do
    args <- getArgs
    let port = if length args >= 1
               then maybe 3000 id (readMaybe $ head args)
               else 3000

    cacheRef <- newIORef =<< loadCache "expandr.cache.json"
    cache <- readIORef cacheRef
    putStrLn $ show (size cache) ++ " entries cached."
    _ <- forkIO . forever $ do
        threadDelay (30 * 1000 * 1000)
        putStrLn "persisting cache to disk"
        readIORef cacheRef >>= saveCache "expandr.cache.json"

    putStrLn $ "expandr'ing on 0.0.0.0:" ++ show port
    server cacheRef >>= run port
