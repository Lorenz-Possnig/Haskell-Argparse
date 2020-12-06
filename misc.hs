module Misc where

import System.IO

(|>) :: a -> (a -> c) -> c
(|>) = flip ($)

readWholeFile :: String -> IO(String)
readWholeFile fname = do
    handle <- openFile fname ReadMode
    hGetContents handle

input :: String -> IO(String)
input output = do
    putStrLn output
    getLine

mySplit :: Eq a => a -> [a] -> ([a], [a])
mySplit sep ls = let
    f = takeWhile (\x -> x /= sep) ls
    s = dropWhile (\x -> x /= sep) ls
        |> tail
    in (f, s)

cprint :: [String] -> IO()
cprint ls = putStrLn $ concat ls

idxMaybe :: Int -> [a] -> Maybe a
idxMaybe _ [] = Nothing
idxMaybe i (x:xs)
    | i == 0 = Just x
    | otherwise = idxMaybe (i - 1) xs

count :: Eq a => a -> [a] -> Int
count n ls = let 
    go :: Eq a => a -> [a] -> Int -> Int
    go _ [] acc = acc
    go n' (x:xs) acc
        | x == n' = go n' xs (acc + 1)
        | otherwise = go n' xs acc
    in go n ls 0

splitOn :: Eq a => a -> [a] -> [[a]]
splitOn sep ls = go sep ls [] [] where
    go :: Eq a => a -> [a] -> [[a]] -> [a] -> [[a]]
    go _ [] final current = final ++ [current]
    go s (x:xs) final current
        |x == s = go s xs (final ++ [current]) []
        |otherwise = go s xs final (current ++ [x])