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


-- Multiplication: (a-b)*(c-d)=(ac+bd)-(ad+bc)
multI :: II -> II -> II
multI (II a b) (II c d) = II (addN (multN a c) (multN b d)) (addN (multN a d) (multN b c))

-- Subtraction: (a-b)-(c-d)=(a+d)-(b+c)
subtrI :: II -> II -> II
subtrI (II a b) (II c d) = II (addN a d) (addN b c)

-- Negation: -(a-b)=(b-a)
negI :: II -> II
negI (II a b) = II b a 
----------------
-- QQ Arithmetic
----------------

-- add positive numbers
addP :: PP -> PP -> PP
addP I m = T m 
addP (T n) m = T (addP n m)


-- multiply positive numbers
multP :: PP -> PP -> PP
multP I m = m 
multP (T n) m = addP (multP n m) m

-- convert numbers of type PP to numbers of type II
ii_pp :: PP -> II
ii_pp I = II (S O) O
ii_pp (T n) = addI (II (S O) O) (ii_pp n)
----------------
-- Normalisation
----------------

normalizeI :: II -> II
normalizeI (II (S m) O) = II (S m) O 
normalizeI (II O (S n)) = II O (S n) 
normalizeI (II (S m) (S n)) = normalizeI (II m n)

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
    print $ "P:"
    print $ "6 + 2 = 8"
    print $ addP (T (T (T (T (T I))))) (T I)
    print $ "3 * 2 = 6"
    print $ multP (T (T I)) (T I)



    print $ "II"
    -- addI (2-1) + (3-1) = 3
    print $ "1 + 2 = 3 = (5 - 2)"
    print $ addI ( II (S (S O)) (S O) ) ( II (S (S (S O))) (S O) )
    -- subtrI and NegI
    print $ "1 - (-1) = 2 = (2 - 0)"
    print $ subtrI (II (S O) O) (negI (II (S O) O))

    print $ subtrI ( II (S (S O)) (S O) ) ( II (S (S (S O))) (S O) )
    print $ "3 * 2 = 6 = (6 - 0)"
    print $ normalizeI (multI ( II (S (S (S (S O)))) (S O) ) ( II (S (S (S O))) (S O)))

    -- normalizeI
    print $ "normalizeI II (3 4) = (0 1)"
    print $ normalizeI (II (S (S (S O))) (S (S (S (S O)))))

    print $ "convert PP -> II: I -> II (S O) O"
    print $ ii_pp (I)
