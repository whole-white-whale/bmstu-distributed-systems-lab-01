{-# LANGUAGE OverloadedStrings #-}

module Server (server) where

import Control.Monad.IO.Class

import Database.PostgreSQL.Simple
import Servant

import API
import PersonResponse

server :: Connection -> Server API
server connection = listPersons connection

listPersons :: Connection -> Handler [PersonResponse]
listPersons connection = do
  response <- liftIO $ query connection
    "SELECT id, name, age, address, work FROM persons"
    ()

  return . flip map response $ \(id, name, age, address, work) ->
    PersonResponse id name age address work
