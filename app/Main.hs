{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE TemplateHaskell    #-}

module Main where

import           Control.Lens  (foldMapByOf, folded, makeLenses)
import           Data.Foldable (foldr')
import qualified Data.Map      as M
import qualified Data.Set      as S
import qualified Data.Text     as T

-- foldMapByOf :: Fold s a -> (r -> r -> r) -> r -> (a -> r) -> s -> r

data Person = Person
  { _name  :: T.Text,
    _foods :: S.Set T.Text
  } deriving stock (Show, Eq)

makeLenses ''Person

people :: [Person]
people =
  [
    Person "mary" $ S.fromList ["pizza", "pasta"]
    , Person "alice" $ S.fromList ["chocolate", "pasta"]
    , Person "paul" $ S.fromList ["pizza", "curry"]
  ]

uniqueFoods :: S.Set T.Text
uniqueFoods = foldMapByOf (folded . foods) (<>) mempty id people

foodCounts :: M.Map T.Text Int
foodCounts =
  foldMapByOf
    (folded . foods)
    (M.unionWith (+))
    mempty
    toFrequencies
    people
  where
    toFrequencies :: (Ord a, Foldable f) => f a -> M.Map a Int
    toFrequencies = foldr' (`M.insert` 1) mempty

main :: IO ()
main = putStrLn "Hello, Haskell!"
