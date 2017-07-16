{-# LANGUAGE ScopedTypeVariables #-}

module Configuration.SimpleConfig.Compiled
  ( compiledConfig
  ) where

import ClassyPrelude hiding (lift)
import Configuration.SimpleConfig.Read
import Data.Yaml
import Language.Haskell.TH.Syntax

-- | Read config from specified path at compile time.
-- Required Lift instance, cannot be overridden at run-time
compiledConfig
  :: forall config. (Lift config, FromJSON config)
  => [FilePath]             -- ^ Path to the config
  -> Q (TExp config)
compiledConfig paths = do
  mapM_ addDependentFile paths
  runIO (readConfig paths :: IO config) >>= fmap TExp . lift
