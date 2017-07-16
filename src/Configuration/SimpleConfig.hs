module Configuration.SimpleConfig
  ( readConfig
  , readConfigFallback
  , compiledValue
  , Value
  , Proxy (Proxy)
  , ConfigError (..)
  ) where

import Configuration.SimpleConfig.Read
import Configuration.SimpleConfig.Compiled.Fallback
