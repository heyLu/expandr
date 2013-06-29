module Main where

import Network.Wai.Handler.Warp (run)
import System.Environment (getArgs)
import Text.Read (readMaybe)

import Expandr.Server (server)

main = do
    args <- getArgs
    let port = if length args >= 1
               then maybe 3000 id (readMaybe $ head args)
               else 3000

    putStrLn $ "expandr'ing on 0.0.0.0:" ++ show port
    server >>= run port
