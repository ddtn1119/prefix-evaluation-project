
File attached: "prefixevaluationproject.hs" (in Haskell (HS))

Created from September 2024 to October 2024.

This project evaluates prefix notation expressions. The program will prompt the user to enter the prefix notation expression they want to evaluate (space-separated) and evaluate it. Each result includes an ID number, which references the history index number by the order it was printed on the console. If we want to reuse a result for another Polish expression, input the operator with "$n" (n is the index number). For example: + * 2 $1 $2. $1 refers to the result of the first expression. $2 refers to the result of the second expression.

If the expression is invalid, or the result of an expression is undefined or infinite, the program will leave an error message to the user.

To compile the program:
1. Open Windows PowerShell or Command Prompt or a similar program
2. Type "cd [directory name]" if the file is downloaded and save in a directory
3. Type "ghci prefixevaluationproject.hs"
4. If the compilation is successful, type "main" after "ghci>" appears to start the program.
5. The program will continue to execute until the user types "exit"
