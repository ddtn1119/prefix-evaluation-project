-- import to gain Maybe type for error handling
import Data.Maybe (fromMaybe)
import Text.Read (readMaybe)

-- data type for the supported operations to perform the prefix evaluation
data Operators = Add | Sub | Mul | Div 
                deriving Show

-- parse a string to operator
parse :: String -> Maybe Operators
parse "+" = Just Add
parse "-" = Just Sub
parse "*" = Just Mul
parse "/" = Just Div
parse _   = Nothing

-- perform the calculation based on the operator
-- calculate the expression using operators and double
calculate :: Operators -> Double -> Double -> Maybe Double
calculate Add x y  = Just (x + y)
calculate Sub x y  = Just (x - y)
calculate Mul x y  = Just (x * y)
calculate Div x y  = Just (x / y)


-- evaluate a prefix notation expression (Polish expression)
evaluatePrefix :: [(Int, Double)] -> [String] -> Maybe Double
evaluatePrefix history tokens = do
    (result, []) <- evaluate tokens
    return result
    where
        evaluate :: [String] -> Maybe (Double, [String])
        evaluate [] = Nothing -- []: empty list
        evaluate (o:os) = case readMaybe o :: Maybe Double of
            Just rn -> Just (rn, os) -- use the real number to construct prefix expression
            Nothing -> case findid o of
                Just value -> Just (value, os) -- or use the value from history, indicated by the id
                Nothing -> do
                    operator <- parse o -- parse 'o' to operator first
                    (x, p1) <- evaluate os -- evaluate first part of the expression
                    (y, p2) <- evaluate p1 -- evaluate second part of the expression
                    result <- calculate operator x y -- call the calculate function
                    return (result, p2) -- return the result of prefix expression
                
        -- look up the history ID, using $n or -$n format
        findid :: String -> Maybe Double
        findid ('$':ss) = case readMaybe ss :: Maybe Int of
            Just id -> lookup id history -- find the id in history of results
            Nothing -> Nothing
        findid ('-':'$':ss) = case readMaybe ss :: Maybe Int of
            Just id -> fmap negate (lookup id history) -- find the id and negate the value
            Nothing -> Nothing
        findid _ = Nothing
        

-- evalLoop function for evaluating prefix notation expression
-- keep the program running in a loop until the user exits
evalLoop :: [(Int, Double)] -> IO ()
evalLoop history = do -- the history should be a parameter to the evalLoop function.
    putStrLn "Enter a prefix notation expression (space-separated), or type 'exit' to stop the program:" -- prompt the user to enter the expression
    input <- getLine -- read user input
    if input == "exit"
        then 
            putStrLn "Goodbye!" -- stop the program if the user types "exit"
        else do
            let expr_tokens = words input
            case evaluatePrefix history expr_tokens of
                Just expr_result -> do
                    if isNaN expr_result || isInfinite expr_result 
                    then do
                        putStrLn "Error: infinity or undefined." -- print this error message if division by zero occurs or any expressions that lead to infinity/undefined results
                        evalLoop history
                    else do
                    -- define history id
                        let idn = length history + 1 -- add 1 to length history since the first index is zero
                            newhistory = (idn, expr_result) : history -- everytime new result is generated, add it to the history recursively
                        putStrLn $ "Result (id " ++ show idn ++ "): " ++ show expr_result -- print out the result
                        evalLoop newhistory -- continue the loop with updated history
                Nothing -> do
                    putStrLn $ "Error: invalid expression." -- error message if the expression is invalid
                    evalLoop history -- continue the loop until the user types "exit"
            
-- history index operator
-- the history index is in integer
(!?) :: [t] -> Int -> Maybe t
historylist !? index
    | index < 0 = Nothing -- index less than or equal to zero indicates empty history
    | otherwise = findindex historylist index 
    where
        findindex [] _ = Nothing 
        findindex (x:xs) 0 = Just x -- base case
        findindex (x:xs) n = xs !? (n - 1) -- recursively match each prefix expression result to its respective index

-- main function
main :: IO ()
main = do
    putStrLn "Welcome to the prefix notation expression calculator!"
    evalLoop [] -- call evalLoop