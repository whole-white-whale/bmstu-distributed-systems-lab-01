{-# LANGUAGE DeriveGeneric #-}

module ErrorResponse (ErrorResponse (..)) where

import Data.Aeson
import GHC.Generics

newtype ErrorResponse = ErrorResponse
  { message :: String
  } deriving (Eq, Generic, Show)

instance ToJSON ErrorResponse
