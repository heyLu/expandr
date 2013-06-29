{-# LANGUAGE OverloadedStrings #-}
module Expandr.ScottyExtensions where

import Web.Scotty
import qualified Data.Text.Lazy as T

m :: ActionM a -> ActionM (Maybe a)
m a = (a >>= return . Just) `rescue` \_ -> return Nothing

m' :: a -> ActionM a -> ActionM a
m' n a = m a >>= return . maybe n id

p' :: (Parsable a) => T.Text -> ActionM (Maybe a)
p' = m . param

h' :: T.Text -> ActionM (Maybe T.Text)
h' = m . reqHeader

data T = J | H | P

n :: (T -> ActionM a) -> ActionM a
n f = do
  a <- m' "text/html" $ reqHeader "Accept"
  let t = case a of
        "application/json" -> J
        "text/plain" -> P
        _ -> H
  f t
