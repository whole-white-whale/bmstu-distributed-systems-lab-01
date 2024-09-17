{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE OverloadedStrings #-}

module Server (server) where

import Control.Monad.IO.Class

import Data.Aeson
import Servant

import API
import Connection (Connection)
import Connection qualified as Connection
import PersonRequest
import PersonResponse

server :: Connection -> Server API
server connection = listPersons connection
  :<|> createPerson connection
  :<|> getPerson connection
  :<|> editPerson connection
  :<|> deletePerson connection

listPersons :: Connection -> Handler [PersonResponse]
listPersons = liftIO . Connection.listPersons

createPerson :: Connection -> PersonRequest -> Handler (Headers '[Header "Location" String] NoContent)
createPerson connection person = do
  personId <- liftIO $ Connection.createPerson connection person

  return $ addHeader ("/api/v1/persons/" <> show personId) NoContent

getPerson :: Connection -> Int -> Handler PersonResponse
getPerson connection personId = do
  response <- liftIO $ Connection.getPerson connection personId

  case response of
    Left errorResponse -> do
      throwError $ err404
        { errBody = encode errorResponse
        , errHeaders = [("Content-Type", "application/json")]
        }

    Right personResponse -> do
      return personResponse

editPerson :: Connection -> Int -> PersonRequest -> Handler PersonResponse
editPerson connection personId person = do
  response <- liftIO $ Connection.editPerson connection personId person

  case response of
    Left errorResponse -> do
      throwError $ err404
        { errBody = encode errorResponse
        , errHeaders = [("Content-Type", "application/json")]
        }

    Right personResponse -> do
      return personResponse

deletePerson :: Connection -> Int -> Handler NoContent
deletePerson connection personId = do
  liftIO $ Connection.deletePerson connection personId

  return NoContent
