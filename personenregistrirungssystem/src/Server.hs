{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Server (server) where

import Control.Monad.IO.Class

import Data.Aeson
import Database.PostgreSQL.Simple
import Servant

import API
import ErrorResponse
import PersonRequest
import PersonResponse

server :: Connection -> Server API
server connection = listPersons connection
  :<|> createPerson connection
  :<|> getPerson connection
  :<|> editPerson connection

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

getPerson :: Connection -> Int -> Handler PersonResponse
getPerson connection personId = do
  response <- liftIO $ query connection
    "SELECT name, age, address, work FROM persons WHERE id = ?"
    [personId]

  case response of
    [] -> do
      throwError $ err404
        { errBody = encode $ ErrorResponse "The person does not exist!"
        }

    ((personName, personAge, personAddress, personWork) : _) -> do
      return $ PersonResponse
        { id = personId
        , name = personName
        , age = personAge
        , address = personAddress
        , work = personWork
        }

editPerson :: Connection -> Int -> PersonRequest -> Handler PersonResponse
editPerson connection personId person = do
  response <- liftIO $ execute connection
    "UPDATE persons SET name = ?, age = ?, address = ?, work = ? WHERE id = ?"
    ( person.name
    , person.age
    , person.address
    , person.work
    , personId
    )

  case response of
    0 -> do
      throwError $ err404
        { errBody = encode $ ErrorResponse "The person does not exist!"
        }

    _ -> do
      return $ PersonResponse
        { id = personId
        , name = person.name
        , age = person.age
        , address = person.address
        , work = person.work
        }
