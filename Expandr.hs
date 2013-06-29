import Network.URI
import Network.HTTP

shorteners = ["t.co", "bit.ly", "fb.me"]

isShortened :: URI -> Bool
isShortened uri = maybe False id $ do
    domain <- fmap uriRegName $ uriAuthority uri
    return $ domain `elem` shorteners

location :: Response a -> Maybe String
location res = lookupHeader HdrLocation . getHeaders $ res

fromMaybe = maybe False id

getUnshortened url maxRedirect = do
    if fromMaybe $ parseURI url >>= return . isShortened
    then do
        res <- simpleHTTP $ getRequest url
        return $ fmap location res
    else return . Right . Just $ url
