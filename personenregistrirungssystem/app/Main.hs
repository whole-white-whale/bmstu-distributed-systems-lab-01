module Main (main) where

import System.Environment

import Network.Wai.Handler.Warp

import Application
import Connection

main :: IO ()
main = do
  connectionString <- getEnv "CONNECTION_STRING"
  connection <- connect connectionString

  run 8080 $ application connection
