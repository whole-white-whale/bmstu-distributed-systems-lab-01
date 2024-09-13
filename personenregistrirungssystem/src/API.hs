{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module API (API, api) where

import Servant

import PersonRequest
import PersonResponse

type API = "api" :> "v1" :> "persons" :> Verb 'GET 200 '[JSON] [PersonResponse]

api :: Proxy API
api = Proxy
