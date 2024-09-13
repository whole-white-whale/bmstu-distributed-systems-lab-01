{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Server (server) where

import Control.Monad.IO.Class

import Database.PostgreSQL.Simple
import Servant

import API
import PersonRequest
import PersonResponse

server :: Connection -> Server API
server connection = listPersons connection
  :<|> createPerson connection

listPersons :: Connection -> Handler [PersonResponse]
listPersons connection = do
  response <- liftIO $ query connection
    "SELECT id, name, age, address, work FROM persons"
    ()

  return . flip map response $
    \(personId, personName, personAge, personAddress, personWork) ->
      PersonResponse
        { id = personId
        , name = personName
        , age = personAge
        , address = personAddress
        , work = personWork
        }

createPerson :: Connection -> PersonRequest -> Handler (Headers '[Header "Location" String] NoContent)
createPerson connection person = do
  [Only personId] :: [Only Int] <- liftIO $ query connection
    "INSERT INTO persons (name, age, address, work) VALUES (?, ?, ?, ?) RETURNING id"
    ( person.name
    , person.age
    , person.address
    , person.work
    )

  return $ addHeader ("/api/v1/persons/" <> show personId) NoContent
