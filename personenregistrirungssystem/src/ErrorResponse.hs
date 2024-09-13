{-# LANGUAGE DeriveGeneric #-}

module ErrorResponse (ErrorResponse (..)) where

import Data.Aeson
import GHC.Generics

newtype ErrorResponse = ErrorResponse
  { message :: String
  } deriving (Generic)

instance ToJSON ErrorResponse
