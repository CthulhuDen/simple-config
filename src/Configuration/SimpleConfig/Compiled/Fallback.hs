{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE LambdaCase #-}

module Configuration.SimpleConfig.Compiled.Fallback
  ( compiledValue
  , Proxy (Proxy)
  , ConfigError (..)
  ) where

import ClassyPrelude hiding (lift)
import Data.Aeson
import Data.Yaml
import Language.Haskell.TH.Syntax
import Data.Proxy

data ConfigError = ConfigParseException ParseException | InvalidConfig Text

instance Show ConfigError where
  show (ConfigParseException ex)  = "Could not parse YAML from config: " <> show ex
  show (InvalidConfig msg)        = "Invalid configuration in file: " <> unpack msg

instance Exception ConfigError

-- | Produces splice containing fallback value from the config,
-- checked to be parseable into the config type
compiledValue
  :: forall config. (FromJSON config)
  => Proxy config       -- ^ Required for compile-time config validation
  -> FilePath           -- ^ Path to the config file
  -> Q Exp              -- ^ Expression of type Value is produced in Q
compiledValue _ path = do
  addDependentFile path
  v <- runIO (decodeFileEither path) >>= \case
    Left err  -> throw $ ConfigParseException err
    Right v   -> return v
  case fromJSON v :: Result config of
    Error msg -> throw $ InvalidConfig $ pack msg
    Success _ -> return ()
  lift v
