{-# LANGUAGE DeriveGeneric #-}

module PersonResponse (PersonResponse (..)) where

import Data.Aeson
import GHC.Generics

data PersonResponse = PersonResponse
  { id :: Int
  , name :: String
  , age :: Maybe Int
  , address :: Maybe String
  , work :: Maybe String
  } deriving (Generic)

instance ToJSON PersonResponse
