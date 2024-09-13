{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE OverloadedStrings #-}

module Context (context) where

import Data.Map qualified as Map

import Data.Aeson
import Servant

import ValidationErrorResponse

context :: Context '[ErrorFormatters]
context = errorFormatters :. EmptyContext

errorFormatters :: ErrorFormatters
errorFormatters = defaultErrorFormatters
  { bodyParserErrorFormatter = errorFormatter
  }

errorFormatter :: ErrorFormatter
errorFormatter _ _ bodyError = err400
  { errBody = encode $ validationErrorResponse bodyError
  , errHeaders = [("Content-Type", "application/json")]
  }

validationErrorResponse :: String -> ValidationErrorResponse
validationErrorResponse bodyError = ValidationErrorResponse
  { message = "The request is invalid!"
  , errors = Map.singleton "body" bodyError
  }
