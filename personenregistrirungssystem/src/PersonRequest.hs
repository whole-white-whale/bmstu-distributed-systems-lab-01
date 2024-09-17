{-# LANGUAGE DeriveGeneric #-}

module PersonRequest (PersonRequest (..)) where

import Data.Aeson
import GHC.Generics

data PersonRequest = PersonRequest
  { name :: String
  , age :: Maybe Int
  , address :: Maybe String
  , work :: Maybe String
  } deriving (Eq, Generic, Show)

instance FromJSON PersonRequest
