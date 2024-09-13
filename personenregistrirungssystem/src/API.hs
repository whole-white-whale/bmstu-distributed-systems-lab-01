{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module API (API, api) where

import Servant

import PersonRequest
import PersonResponse

type API = "api" :> "v1" :> "persons" :>
  ( ListPersons
  :<|> CreatePerson
  :<|> GetPerson
  :<|> EditPerson
  :<|> DeletePerson
  )

type ListPersons = Verb 'GET 200 '[JSON] [PersonResponse]

type CreatePerson = ReqBody '[JSON] PersonRequest
  :> Verb 'POST 201 '[JSON] (Headers '[Header "Location" String] NoContent)

type GetPerson = Capture "id" Int
  :> Verb 'GET 200 '[JSON] PersonResponse

type EditPerson = Capture "id" Int
  :> ReqBody '[JSON] PersonRequest
  :> Verb 'PATCH 200 '[JSON] PersonResponse

type DeletePerson = Capture "id" Int
  :> Verb 'DELETE 204 '[JSON] NoContent

api :: Proxy API
api = Proxy
