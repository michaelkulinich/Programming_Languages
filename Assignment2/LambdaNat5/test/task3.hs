member :: Int -> [Int] -> Int
member _ [] = 0
member elem (x:xs)
    | elem == x = 1
    | otherwise = member elem xs

removeItem :: Int -> [Int] -> [Int]
removeItem _ [] = []
removeItem elem (x:xs) 
    | elem == x    = xs
    | otherwise = x : removeItem elem xs


sum1 :: [Int] -> Int
sum1 [] = 0
sum1 (x:xs) = x + sum1 xs

prod :: [Int] -> Int
prod [] = 1
prod (x:xs) = x * prod xs

plus_two :: Int -> Int
plus_two x = x + 2

map1 :: [Int] -> [Int]
map1 [] = []
map1 (x:xs) = (plus_two x) : (map1 xs)

insert :: Int -> [Int] -> [Int]
insert elem [] = [elem]
insert elem (x:xs) 
    | elem <= x = elem : x : xs
    | otherwise = x : (insert elem xs)

sort1 :: [Int] -> [Int] 
sort1 [] = []
sort1 (x:xs) = insert x (sort1 xs)

main = do
    print (removeItem 2 [1,2,3])
    print (member 21 [])
    print (sum1 [1,2,3,4])
    print (prod [1,2,3,4])
    print (map1 [1,2,3,4])
    print (insert 1 [3,4,5])
    print (sort1 [3,4,5,2,1])






