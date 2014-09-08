-- | Core functionality. Knows what is shortened and how to expand.
module Expandr.Core where

import Network.URI
import Network.HTTP

shorteners :: [String]
shorteners = ["t.co", "bit.ly", "fb.me"]

isShortened' :: URI -> Bool
isShortened' uri = maybe False id $ do
    domain <- fmap uriRegName $ uriAuthority uri
    return $ domain `elem` shorteners

fromMaybe :: Maybe Bool -> Bool
fromMaybe = maybe False id

isShortened :: String -> Bool
isShortened url = fromMaybe $ parseURI url >>= return . isShortened'

location :: Response a -> Maybe String
location res = lookupHeader HdrLocation . getHeaders $ res

getUnshortened :: String -> Int -> IO String
getUnshortened url maxRedirect = getUnshortened' url maxRedirect getUnshortened1

getUnshortened' :: String -> Int -> (String -> IO String) -> IO String
getUnshortened' url maxRedirect unshorten = do
    if isShortened url && maxRedirect > 0
    then do
        unshortened <- unshorten url
        if maxRedirect > 0
        then getUnshortened' unshortened (maxRedirect - 1) unshorten
        else return url
    else return url

getUnshortened1 :: String -> IO String
getUnshortened1 url = do
    res <- simpleHTTP $ getRequest url
    return $ maybe url id $ either (Just . const url) id $ fmap location res
