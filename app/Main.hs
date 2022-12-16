{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE TemplateHaskell #-}

module Main where

import           Control.Lens
import qualified Data.Set     as S
import qualified Data.Map     as M
import qualified Data.Text    as T

-- foldMapByOf :: Fold s a -> (r -> r -> r) -> r -> (a -> r) -> s -> r

data Person = Person
  { _name  :: T.Text,
    _foods :: S.Set T.Text
  } deriving stock (Show, Eq)

makeLenses ''Person

-- data Person

x :: Integer
x = foldMapBy (+) 1 (+ 1) [1, 2, 3]

people :: [Person]
people =
  [
    Person "mary" $ S.fromList ["pizza", "pasta"]
    , Person "alice" $ S.fromList ["chocolate", "pasta"]
    , Person "paul" $ S.fromList ["pizza", "curry"]
  ]

-- uniqueFoods :: [T.Text]
uniqueFoods :: S.Set T.Text
uniqueFoods = foldMapByOf (folded . foods) (<>) mempty id people

foodCounts :: M.Map T.Text Int
foodCounts =
  foldMapByOf
    (folded . foods)
    _a
    (M.)
    _c
    people


main :: IO ()
main = putStrLn "Hello, Haskell!"
