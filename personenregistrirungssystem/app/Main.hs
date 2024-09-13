module Main (main) where

import System.Environment

import Network.Wai.Handler.Warp
import Servant

import API
import Connection
import Server

main :: IO ()
main = do
  connectionString <- getEnv "CONNECTION_STRING"
  connection <- connect connectionString

  run 8080 . serve api $ server connection
