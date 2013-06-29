-- | Core functionality. Knows what is shortened and how to expand.
module Expandr.Core where

import Network.URI
import Network.HTTP
import Data.Maybe (isJust, fromJust)

s :: [String]
s = ["t.co", "bit.ly", "fb.me"]

i' :: URI -> Bool
i' u = maybe False id $ do
    d <- fmap uriRegName $ uriAuthority u
    return $ d `elem` s

f :: Maybe Bool -> Bool
f = maybe False id

i :: String -> Bool
i u = f $ parseURI u >>= return . i'

l :: Response a -> Maybe String
l r = lookupHeader HdrLocation . getHeaders $ r

g :: String -> Int -> IO String
g u m = do
    if i u && m > 0
    then do
        r <- simpleHTTP $ getRequest u
        let s = fmap l r
        let s' = either (Just . const u) id s
        if m > 0 && isJust s'
        then g (fromJust s') (m - 1)
        else return $ maybe u id s'
    else return u
