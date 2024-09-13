{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module API (API, api) where

import Servant

import PersonRequest
import PersonResponse

type API = "api" :> "v1" :> "persons" :>
  ( ListPersons
  :<|> CreatePerson
  )

type ListPersons = Verb 'GET 200 '[JSON] [PersonResponse]

type CreatePerson = ReqBody '[JSON] PersonRequest
  :> Verb 'POST 201 '[JSON] (Headers '[Header "Location" String] NoContent)

api :: Proxy API
api = Proxy
