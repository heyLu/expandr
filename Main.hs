module Main where

import Network.Wai.Handler.Warp (run)
import System.Environment (getArgs)
import Text.Read (readMaybe)

import Expandr.Server (s)

main :: IO ()
main = do
    a <- getArgs
    let p = if length a >= 1
               then maybe 3000 id (readMaybe $ head a)
               else 3000

    putStrLn $ "expandr'ing on 0.0.0.0:" ++ show p
    s >>= run p
