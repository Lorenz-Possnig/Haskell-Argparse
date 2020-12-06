module Main where

import Argparse
import System.Environment

main :: IO()
main = do
    args <- getArgs
    let cmds = parseArgs args
    putStr "Hello "
    forParam_ ("-f", "--firstname") cmds putStr (putStr "John")
    putChar ' '
    forParam_ ("-l", "--lastname") cmds putStr (putStr "Doe")
    putStrLn "!"

    let a = forParam ("-a", "--numberOne") cmds read 0
    let b = forParam ("-b", "--numberTwo") cmds read 0
    print (a + b)