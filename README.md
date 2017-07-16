# simple-config

Thin wrapper of `yaml` package (specifically mostly `Data.Yaml.Config` module) providing easy API
for compile-time validated config (the produced fallback `Value` is checked at compile-time to be valid config).

## Examples

Compile-time config overridable at run-time:

```haskell
{-# LANGUAGE TemplateHaskell #-}

import Configuration.SimpleConfig

-- | The returned json 'Value' is checked to be parsable into 'Settings'
-- Environment substitution (read `Data.Yaml.Config` docs) will only happen at run time
compiledConfig :: Value
compiledConfig = $(compiledValue (Proxy :: Proxy Settings) "config/settings.yaml")

main :: IO ()
main = do
  settings <- readConfigFallback ["config/settings.yaml"] [compiledConfig]
  return ()
```

Only run-time config:

```haskell
import Configuration.SimpleConfig

main :: IO ()
main = do
  settings <- readConfig ["config/settings.yaml"]
  return ()
```

Compile-time config which involved no run-time parsing of json `Value` but requires `Lift` instance:

```haskell
{-# LANGUAGE TemplateHaskell #-}

import Configuration.SimpleConfig.Compile

-- | Parsed directly into Settings at compile time, but impossible to override at run-time
-- Also, any environment substitution (read about that in docs to 'Data.Yaml.Config') will happen at compile time!
settings :: Settings
settings = $$(compiledConfig ["config/settings.yaml"])
```
