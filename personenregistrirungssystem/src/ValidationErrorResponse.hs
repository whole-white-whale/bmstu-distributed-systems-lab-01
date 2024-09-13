{-# LANGUAGE DeriveGeneric #-}

module ValidationErrorResponse (ValidationErrorResponse (..)) where

import Data.Map (Map)

import Data.Aeson
import GHC.Generics

data ValidationErrorResponse = ValidationErrorResponse
  { message :: String
  , errors :: Map String String
  } deriving (Generic)

instance ToJSON ValidationErrorResponse
