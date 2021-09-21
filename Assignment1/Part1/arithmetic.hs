-- A Virtual Machine (VM) for Arithmetic (template)

-----------------------
-- Data types of the VM
-----------------------

-- Natural numbers
data NN = O | S NN
  deriving (Eq,Show) -- for equality and printing

-- Integers
data II = II NN NN
  deriving (Eq,Show) -- for equality and printing

-- Positive integers (to avoid dividing by 0)
data PP = I | T PP
    deriving (Eq,Show) -- for equality and printing

-- Rational numbers
data QQ =  QQ II PP



----------------------------------------------------
-- Converting between VM-numbers and Haskell-numbers
----------------------------------------------------

-- Precondition: Inputs are non-negative
-- nn_int :: Integer -> NN

-- int_nn :: NN->Integer

-- ii_int :: Integer -> II

-- int_ii :: II -> Integer

-- -- Precondition: Inputs are positive
-- pp_int :: Integer -> PP

-- int_pp :: PP->Integer

-- float_qq :: QQ -> Float

------------------------
-- Arithmetic on the  VM
------------------------

----------------
-- NN Arithmetic
----------------

-- add natural numbers
addN :: NN -> NN -> NN
addN O m = m
addN (S n) m = S (addN n m)

-- multiply natural numbers
multN :: NN -> NN -> NN
multN O m = O
multN (S n) m = addN (multN n m) m

----------------
-- II Arithmetic
----------------

-- Addition: (a-b)+(c-d)=(a+c)-(b+d)
addI :: II -> II -> II
addI (II a b) (II c d) = II (addN a c) (addN b d)


----------------
-- QQ Arithmetic
----------------

-- add positive numbers
addP :: PP -> PP -> PP
addP I m = T m 
addP (T n) m = T (addP n m)
----------------
-- Normalisation
----------------


----------------------------------------------------
-- Converting between VM-numbers and Haskell-numbers
----------------------------------------------------


----------
-- Testing
----------
main = do
    -- print $ addN (S (S O)) (S O)
    -- print $ multN (S (S O)) (S (S (S O)))
    -- Integers: (II i j) represents i-j, (II k l) represents k-l
    let i = 4
    let j = 2
    let k = 1
    let l = 3


    -- addP
    print $ addP (T (T I)) (T I)

    -- addI
    -- addI (2-1) + (3-1) = 3
    print $ addI ( II (S (S O)) (S O) ) ( II (S (S (S O))) (S O) )
