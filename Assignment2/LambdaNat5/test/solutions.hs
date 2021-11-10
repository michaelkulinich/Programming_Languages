member :: Int -> [Int] -> Bool
member _ [] = False
member elem (x:xs)
    | elem == x = True
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

map1 :: (Int -> Int) -> [Int] -> [Int]
map1 _ [] = []
map1 f (x:xs) = (f x) : (map1 f xs)

insert :: Int -> [Int] -> [Int]
insert elem [] = [elem]
insert elem (x:xs) 
    | elem <= x = elem : x : xs
    | otherwise = x : (insert elem xs)

sort1 :: (Int -> [Int] -> [Int]) -> [Int] -> [Int] 
sort1 _ [] = []
sort1 f (x:xs) = f x (sort1 f xs)

main = do
    print (member 1 [2,3,1])
    print (removeItem 2 [1,2,3,1,2,3])

    print (sum1 [1,2,3,4])
    print (prod [1,2,3,4])
    print (map1 plus_two [1,2,3,4])
    print (sort1 insert [1,2,3,1,2,3])






