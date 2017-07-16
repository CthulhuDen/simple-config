{-# LANGUAGE FlexibleInstances #-}

module Configuration.SimpleConfig.Read
  ( readConfig
  , readConfigFallback
  , Value
  ) where

import ClassyPrelude
import Data.Yaml
import Data.Yaml.Config

-- | Read config from specified path at run time
-- Same as 'readConfigFallback` with empty fallbacks list
readConfig
  :: FromJSON config
  => [FilePath]             -- ^ Paths to the config files
  -> IO config
readConfig paths = readConfigFallback paths []

-- | Read config from specified path as run time,
-- adding provided compile-time fallbacks to config and/or environment
readConfigFallback
  :: FromJSON config
  => [FilePath]             -- ^ Paths to the config files
  -> [Value]                -- ^ Usually compile-time fallback json values
  -> IO config
readConfigFallback paths fallbacks = loadYamlSettings paths fallbacks useEnv
