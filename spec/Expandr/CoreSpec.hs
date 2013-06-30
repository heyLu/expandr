module Expandr.CoreSpec where

import Test.Hspec
import Test.QuickCheck
import qualified Data.Map as M

import Expandr.Core

main = hspec $ do
    getUnshortenedSpec

unshortenSequence :: [String] -> String -> IO String
unshortenSequence seq = \url -> do
    let dict = M.fromList $ zip seq (tail seq)
    return . maybe url id $ M.lookup url dict

expectShortened :: [String] -> String -> Expectation
expectShortened seq expected =
    getUnshortened' (head seq) 10 (unshortenSequence seq) `shouldReturn` expected

getUnshortenedSpec = describe "getUnshortened" $ do
    context "when unshortening an invalid url" $ do
        it "should return the invalid url" $ do
            getUnshortened "invalid" 10 `shouldReturn` "invalid"

        it "should return arbitrary invalid urls" $ do
            property $ \s ->
                getUnshortened s 10 `shouldReturn` s

    context "when given once-shortened url" $ do
        it "should return the unshortened url" $ do
            let short = "http://t.co/something"
            let long = "http://example.com/expanded-link"
            [short, long] `expectShortened` long

    context "when given twice-shortened urls" $ do
        it "should return the unshortened url" $ do
            let short = "http://t.co/something"
            let long = "http://example.com/expanded-link"
            [short, short++"2", long] `expectShortened` long

    context "when given an infinite redirection" $ do
        it "should not loop infinitely" $ do
            let short = "http://t.co/something"
            [short, short] `expectShortened` short
