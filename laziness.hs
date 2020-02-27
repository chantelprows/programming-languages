isPrime :: Int -> Bool
isPrime n = null [x | x <- [2..(iSqrt n)], n `mod` x == 0]

primes :: [Int]
primes = filter isPrime [2..]

isPrimeFast :: Int -> Bool
isPrimeFast n
  | n == 2 = True
  | otherwise = null [x | x <- takeWhile (<= iSqrt n) primesFast, n `mod` x == 0]

primesFast :: [Int]
primesFast = filter isPrimeFast [2..]

lcsLength :: String -> String -> Int
lcsLength s1 s2 = length (lcs s1 s2)

lcs :: String -> String -> String
lcs s1 s2
  | length s1 == 0 || length s2 == 0 = ""
  | last s1 == last s2 = (lcs (init s1) (init s2)) ++ [last s1]
  | otherwise = findBiggest (lcs (init s1) s2) (lcs s1 (init s2))

findBiggest :: String -> String -> String
findBiggest s1 s2 = if length s1 > length s2 then s1 else s2


iSqrt :: Int-> Int
iSqrt n = floor(sqrt(fromIntegral n))
