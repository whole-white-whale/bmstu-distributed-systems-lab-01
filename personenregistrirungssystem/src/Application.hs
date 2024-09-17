module Application (application) where

import Servant

import API
import Connection
import Context
import Server

application :: Connection -> Application
application = serveWithContext api context . server
