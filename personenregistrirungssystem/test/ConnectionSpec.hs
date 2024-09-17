{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedRecordDot #-}

module ConnectionSpec (spec) where

import Control.Applicative
import System.Environment

import Test.Hspec
import Test.QuickCheck

import Connection
import ErrorResponse
import PersonRequest
import PersonResponse

spec :: Spec
spec = do
  connectionString <- runIO $ getEnv "CONNECTION_STRING"
  connection <- runIO $ connect connectionString

  describe "Connection" $ do
    it "createPerson/getPerson" . property $ \person -> do
      personId <- createPerson connection person

      shouldReturn (getPerson connection personId) . Right $ PersonResponse
        { id = personId
        , name = person.name
        , age = person.age
        , address = person.address
        , work = person.work
        }

      deletePerson connection personId

    it "createPerson/editPerson" . property $ \person personEdit -> do
      personId <- createPerson connection person

      shouldReturn (editPerson connection personId personEdit) . Right $ PersonResponse
        { id = personId
        , name = personEdit.name
        , age = personEdit.age <|> person.age
        , address = personEdit.address <|> person.address
        , work = personEdit.work <|> person.work
        }

      deletePerson connection personId

    it "deletePerson/getPerson" . property $ \person -> do
      personId <- createPerson connection person
      deletePerson connection personId

      shouldReturn (getPerson connection personId) . Left $ ErrorResponse
        { message = "The person does not exist!"
        }

    it "deletePerson/editPerson" . property $ \person personEdit -> do
      personId <- createPerson connection person
      deletePerson connection personId

      shouldReturn (editPerson connection personId personEdit) . Left $ ErrorResponse
        { message = "The person does not exist!"
        }

instance Arbitrary PersonRequest where
  arbitrary = PersonRequest
    <$> arbitraryString
    <*> arbitrary
    <*> arbitraryMaybeString
    <*> arbitraryMaybeString

arbitraryString :: Gen String
arbitraryString = listOf arbitraryPrintableChar

arbitraryMaybeString :: Gen (Maybe String)
arbitraryMaybeString = do
  isNothing <- arbitrary

  case isNothing of
    True -> do
      return Nothing

    False -> do
      Just <$> arbitraryString
