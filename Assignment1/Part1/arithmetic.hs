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
    deriving (Eq,Show) -- for equality and printing





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


-- Addition: (a/b)+(c/d)=(ad+bc)/(bd)
addQ :: QQ -> QQ -> QQ
addQ (QQ a b) (QQ c d) = QQ (addI (multI a (ii_pp d)) (multI (ii_pp b) c)) (multP b d)

-- Multiplication: (a/b)*(c/d)=(ac)/(bd)
multQ :: QQ -> QQ -> QQ
multQ (QQ a b) (QQ c d) = QQ (multI a c) (multP b d)
----------------
-- Normalisation
----------------

normalizeI :: II -> II
normalizeI (II m O) = II m O 
normalizeI (II O n) = II O n
normalizeI (II (S m) (S n)) = normalizeI (II m n)

----------------------------------------------------
-- Converting between VM-numbers and Haskell-numbers
----------------------------------------------------

-- Precondition: Inputs are non-negative
nn_int :: Integer -> NN
nn_int 0 = O 
nn_int m = S (nn_int (m-1))

int_nn :: NN->Integer
int_nn O = 0
int_nn (S n) = 1 + (int_nn n)

ii_int :: Integer -> II
ii_int 0 = (II O O)
ii_int m = addI (II (S O) O) (ii_int (m-1))

int_ii :: II -> Integer
int_ii (II m O) = int_nn m
int_ii (II m (S n)) = (int_ii (II m n)) - 1


-- -- Precondition: Inputs are positive
pp_int :: Integer -> PP
pp_int 1 = I
pp_int m = T (pp_int (m - 1))


int_pp :: PP->Integer
int_pp I = 1
int_pp (T n) = 1 + (int_pp n)

float_qq :: QQ -> Float
float_qq (QQ a b) = (fromIntegral( int_ii a)) / (fromIntegral( int_pp b))
-- Found from integral on https://stackoverflow.com/questions/10303251/haskell-converting-int-to-float
-- This allowed us to convert to float as our results were coming out as Integers

------------------------------
-- Normalisation by Evaluation
------------------------------

nbv :: II -> II
nbv m = ii_int (int_ii m)
----------
-- Testing
----------
main = do

    -- Integers: (II i j) represents i-j, (II k l) represents k-l
    let i = 4
    let j = 2
    let k = 1
    let l = 3
    print $ int_ii (addI (II (nn_int i) (nn_int j)) (II (nn_int k) (nn_int l)))
    print $ int_ii (multI (II (nn_int i) (nn_int j)) (II (nn_int k) (nn_int l)))
    -- Fractions: (QQ i j) represents i/j, (QQ k l) represents k/l
    print $ float_qq (addQ (QQ (ii_int i) (pp_int j)) (QQ (ii_int k) (pp_int l)))
    print $ float_qq (multQ (QQ (ii_int i) (pp_int j)) (QQ (ii_int k) (pp_int l)))
    -- Normalisation (recursive definition)
    print $ normalizeI (II (nn_int i) (nn_int j))
    -- Normalisation (by evaluation)
    print $ nbv (II (nn_int i) (nn_int j))


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

    print $ "addQ"
    print $ "1/3 + 1/3 = 2/3"
    print $ addQ (QQ (II (S O) O) (T (T I)))  (QQ (II (S O) O) (T (T I)))

    print $ "multQ"
    print $ "1/3 * 1/3 = 1/9"
    print $ multQ (QQ (II (S O) O) (T (T I)))  (QQ (II (S O) O) (T (T I)))


    print $ "CONVERSIONS FROM integer-> NN"
    print $ nn_int 4
    print $ "CONVERSIONS FROM NN-> integer"
    print $ int_nn (S (S (S O)))
    print $ "CONVERSIONS FROM integer-> II"
    print $ ii_int 3

    print $ "CONVERSIONS FROM Integer -> PP"
    print $ 2
    print $ pp_int 3
    print $ "CONVERSIONS FROM PP -> Integer"
    print $ "3"
    print $ int_pp (T(T I))
    print $ "CONVERSIONS FROM QQ -> Float"
    print $ "1/4 = 0.25"
    print $ float_qq (QQ (II (S O) O)  (T (T (T I))))


    print $ "CONVERSIONS FROM II-> integer"
    print $ int_ii (II (S (S (S O))) (S O))
