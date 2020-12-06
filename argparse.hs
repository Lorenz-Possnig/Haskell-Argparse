-----------------------------------------------------------------------------
-- |
-- Module       : Argparse
-- Copyright    : (c) Lorenz Possnig 2020
-- License      : BSD-style
-- Portability  : portable
--
-- A module for parsing command line arguments using the Data.Map module
--
-- Usage:
--
-- Get the command line arguments using getArgs from System.Environment
-- Parse the arguments using parseArgs, which will return a Map String String
-- You can then lookup an argument using forParam as follows:
--
-- forParam (short, long) argsMap success failure
-- where
--
-- short is the short version of the argument (e.g.: -f)
-- long is the long version of the argument (e.g.: --firstname)
-- argsMap is the Map returned by parseArgs
-- success is the function applied to the String before the function returns a value
-- failure is the default value returned by the function if the argument is missing
--
-- e.g.:
--
-- main :: IO()
-- main = do
--      args <- getArgs
--      let argsMap = parseArgs args
--      let firstname = forParam ("-f", "--firstname") argsMap id "John"
--      print firstname
--
-- will print the value entered for the argument -f/--firstname if it's present
-- or "John" if it isn't
--
-- The module also provides forParam_ which does not return a result
-- and instead passes the value on to a function (String -> IO)
-- if the argument is present or calls a function (IO) if it isn't
-- e.g.:
-- main :: IO()
-- main = do
--      args <- getArgs
--      let argsMap = parseArgs args
--      forParam_ ("-f", "--firstname") argsMap print (print "John")
-- 
-- will do the same thing as the first example
--
-- A complete example program is available in main.hs
-----------------------------------------------------------------------------

module Argparse (
    parseArgs,
    forParam,
    forParam_,
    -- in case someone wants to change the way to access the Map
    fromParamMaybe
) where

import Data.Map
import Control.Applicative

toTups :: [String] -> [(String, String)]
toTups ls = go ls [] where
    go :: [String] -> [(String, String)] -> [(String, String)]
    go [] acc = acc
    go (h:t) acc = go (tail t) ((x,y):acc) where
        x = h
        y = head t

toMap :: [(String, String)] -> Map String String
toMap ls = go ls Data.Map.empty where
    go :: [(String,String)] -> Map String String -> Map String String
    go [] acc = acc
    go (h:t) acc = go t (insert k v acc) where
        (k, v) = h

parseArgs :: [String] -> Map String String
parseArgs ls = toMap $ toTups ls

fromParamMaybe :: (String,String) -> Map String String -> Maybe String
fromParamMaybe (short, long) argsMap =
    case argsMap !? short of
        Just n -> Just n
        Nothing -> (argsMap !? long) <|> Nothing

forParam :: (String, String) -> Map String String -> (String -> a) -> a -> a
forParam (short, long) argsMap success failure =
    maybe failure success (fromParamMaybe (short, long) argsMap)

forParam_ :: (String, String) -> Map String String -> (String -> IO()) -> IO() -> IO()
forParam_ (short, long) argsMap success failure =
    maybe failure success (fromParamMaybe (short, long) argsMap)
