{-# LANGUAGE OverloadedStrings #-}
module Expandr.ScottyExtensions where

import Web.Scotty
import qualified Data.Text.Lazy as T
import Data.Maybe (fromMaybe)

safe :: ActionM a -> ActionM (Maybe a)
safe action = (action >>= return . Just) `rescue` \_ -> return Nothing

safe' :: a -> ActionM a -> ActionM a
safe' whenNothing action = safe action >>= return . maybe whenNothing id

param' :: (Parsable a) => T.Text -> ActionM (Maybe a)
param' = safe . param

data ContentType = JSON | HTML | Plain

negotiate :: (ContentType -> ActionM a) -> ActionM a
negotiate f = do
  accept <- fmap (fromMaybe "text/html") $ header "Accept"
  let contentType = case accept of
        "application/json" -> JSON
        "text/plain" -> Plain
        _ -> HTML
  f contentType
