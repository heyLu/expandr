-- | Core functionality. Knows what is shortened and how to expand.
module Expandr.Core where

import Network.URI
import Network.HTTP
import Data.Maybe (isJust, fromJust)

shorteners = ["t.co", "bit.ly", "fb.me"]

isShortened' :: URI -> Bool
isShortened' uri = maybe False id $ do
    domain <- fmap uriRegName $ uriAuthority uri
    return $ domain `elem` shorteners

fromMaybe = maybe False id

isShortened :: String -> Bool
isShortened url = fromMaybe $ parseURI url >>= return . isShortened'

location :: Response a -> Maybe String
location res = lookupHeader HdrLocation . getHeaders $ res

getUnshortened url maxRedirect = do
    if isShortened url && maxRedirect > 0
    then do
        res <- simpleHTTP $ getRequest url
        let loc = fmap location res
        let loc' = either (Just . const url) id loc
        if maxRedirect > 0 && isJust loc'
        then getUnshortened (fromJust loc') (maxRedirect - 1)
        else return $ maybe url id loc'
    else return url
