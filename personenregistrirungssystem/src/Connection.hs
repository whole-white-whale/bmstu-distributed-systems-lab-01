{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE OverloadedStrings #-}

module Connection (connect) where

import Data.ByteString.Char8 qualified as ByteString

import Database.PostgreSQL.Simple hiding (connect)

connect :: String -> IO Connection
connect connectionString = do
  connection <- connectPostgreSQL $ ByteString.pack connectionString

  _ <- execute connection
    "CREATE TABLE IF NOT EXISTS persons (id INT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY, name TEXT NOT NULL, age INT, address TEXT, work TEXT)"
    ()

  return connection
