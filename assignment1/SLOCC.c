/*
 * Source Lines of Code Counter, in C (for Java programs)
 * C Version (adapted from C++)
 */

#include <stdio.h>
#include <string.h>

void SLOCC() {

    // ARRAY OF KEYWORDS 
    printf("Source Lines of Code Counter Program\n");
    printf("Please enter a Java Program, then type __END__\n");
    /* VARIABLES */
    char line [100] = {'\0'}; // the individual line of code being evaluated
    int num_lines = 0; // counts the total number of lines of code
    int cbcountL = 0; //keeps count of left curly brackets { 
    int cbcountR = 0; //keeps count of right curly brackets } 
    int cbtotal = 0; // keeps count of {} scope
    int cbmax; // helps identify the maximum {} scope in a single line 
    int SLOC = 0; //counts the number of source lines of code
    int lparen = 0; // helps count and balance parentheses (left))
    int rparen = 0; // helps count and balance parentheses (right)
    int multicomment = 0; //checks if the code is in a multi-line comment  
    int multisetup = 0; // helps keep track of multi-line comment chars
    int inparen = 0; // keeps track of parts of the line in parenthesis
    int instatement = 0; // keeps track statement declarations
    int prev_star = 0; // helps keep track of multi-line comments
    int afterwhile = 0; //helps identify environments after while
    int afterfor = 0; //helps identify environments after for
    int afterdo = 0; // helps identify environments after do

    /* GETS THE CODE LINE BY LINE FROM STANDARD INPUT*/
    while (fgets(line, sizeof (line), stdin)) {

        /* VARIABLES WHICH RESET LINE BY LINE*/
        char charstring [] = {'\0'}; //builds a string from individual chars
        char line_print [sizeof(line)] = {'\0'};
        strcat(line_print,line);
        char pc = '\0'; // keeps track of the previous character 
        char prev_c; //the previous char
        int slashcount = 0; //helps make sure '/' chars are next to each other
        int quote_num = 0; // helps keep track of code inside quotes
        int charquote_num = 0;
        int incomment = 0; //checks if the code is in a comment
        int inquotes = 0; // checks if the code is inside quotes
        int incharquotes = 0; // checks if the code is in single quotes
        int isstatement = 0; // helps keep track of statements


        // WHILE LOOP BREAK CONDITION 
        if (strstr(line, "..quit..") != NULL || strstr(line, "__END__") != NULL) {
            break;
        }
        num_lines = num_lines + 1;
        int i;


        /*GETS THE CODE CHAR BY CHAR FROM STANDARD INPUT*/
        charstring [i];
        for (i = 0; i < 100; i++) {
            char c = line[i]; //the current char being evaluated

            pc = c; // the previous character

            // COUNT CURLY BRACES 
            if (c == '{' && !inquotes && !incharquotes && !incomment) {
                cbcountL++;
            }

            if (c == '}' && !inquotes && !incharquotes && !incomment) {
                cbcountR++;
            }
            cbtotal = cbcountL - cbcountR;
            if (cbtotal > cbmax) {
                cbmax = cbtotal;
            }
            if (isstatement == 1) {
                isstatement = 0;
                if (c != ' ' && c != '(' && c != '\n') {
                    SLOC--;
                    instatement = 0;
                }
            }

            if (c == '*') {
                prev_star = 1;
            }

            //CHECKING FOR COMMENTS
            if (c == '/' && slashcount == 0) {
                slashcount = 1;
                multisetup = 1;
            } else if (c == '/' && slashcount == 1 && !inquotes &&
                    !incharquotes) {
                incomment = 1;
                slashcount = 0;
            }

            // CHECKING FOR MULTI-LINE COMMENTS
            if (c == '*' && multisetup == 1) {
                multicomment = 1;
            } else if (c == '/' && multisetup == 1) {
                //hold
            } else {
                multisetup = 0;
            }

            if (prev_star && c == '/') {
                multicomment = 0;
                incomment = 0;
                prev_star = 0;
                c = ' ';
            }

            //CHECKING FOR STRING QUOTES
            if (c == '"' && !incharquotes) {
                quote_num++;
            }
            if (quote_num % 2 != 0 && c != '"') {
                inquotes = 1;
            } else if (quote_num % 2 == 0) {
                inquotes = 0;
            }

            //CHECKING FOR CHAR QUOTES
            if (c == '\'' && !inquotes) {
                charquote_num++;
            }
            if (charquote_num % 2 != 0) {
                incharquotes = 1;
            } else if (charquote_num % 2 == 0) {
                incharquotes = 0;
            }

            //CHECKING FOR PARENTHESES 
            if (c == '(') {
                inparen = 1;
                lparen++;
            }
            if (c == ')') {
                rparen++;
                if (lparen == rparen) {
                    inparen = 0;
                    rparen = 0;
                    lparen = 0;
                }
            }

            //COUNTING SEMICOLONS
            if (c == ';' && !incomment && !inquotes && !afterfor &&
                    !multicomment && !incharquotes && !afterwhile) {
                SLOC = SLOC + 1;
                instatement = 0;
            } else if (c == ';' && afterwhile) {
                afterwhile = 0;
            }

            if (c == ';' && !inparen && afterfor) {
                afterfor = 0;
                instatement = 0;
                SLOC++;
            }

            if (c == ':' && !incomment && !inquotes && !multicomment
                    && !incharquotes && !inparen && prev_c != ':') {
                SLOC++;
            }

            // COUNTING LEFT BRACKETS
            if (c == '{' && !incomment && !inquotes && !incharquotes &&
                    !instatement && !multicomment) {
                SLOC++;
                instatement = 0;
            }

            if (c == '{' && instatement) {
                instatement = 0;
            }
            if (c == '{' && afterwhile) {
                afterwhile = 0;
            }
            //@ ANNOTATIONS
            if (c == '@' && !incomment && !inquotes && !incharquotes
                    && !instatement && !multicomment) {
                if (prev_c == '\0' || prev_c == ' ' || prev_c == '	') {
                    SLOC++;
                }
            }


            // CHECKING FOR KEYWORDS
            if (pc == ' ' || pc == '	' || pc == ';' || pc == ':') {
                if (pc == c) {
                    pc = '\0';
                }
            } else {
                strncat(charstring, &c, 1);
                //  printf("charstring: %s\n", charstring);
            }

            if (c == ' ' || c == '	' || c == ';' || c == ':') {
                pc = c;
                memset(charstring, 0, sizeof (charstring));
            }


            // CHECK FOR STATEMENTS
            if (!incomment && !multicomment && !inquotes && !incharquotes) {
            if (strcmp(charstring, "while") == 0 ) {

                instatement = 1;
                SLOC = SLOC + 1;
                isstatement = 1;
                if (afterdo) {
                    afterwhile = 1;
                    afterdo = 0;
                }
            }

            if (strcmp(charstring, "for") == 0
                    || (strcmp(charstring, "do") == 0)
                    || (strcmp(charstring, "if") == 0)
                    || (strcmp(charstring, "else") == 0)
                    || (strcmp(charstring, "switch") == 0 )
                    ) {
                SLOC++;
                isstatement = 1;
                instatement = 1;
                if (strcmp(charstring, "for") == 0) {
                    afterfor = 1;
                }
                if (strcmp(charstring, "while") == 0) {
                    if (afterdo) {
                        afterwhile = 1;
                        afterdo = 0;
                    }
                }
                if (strcmp(charstring, "do") == 0) {
                    afterdo = 1;
                }
                memset(charstring, 0, sizeof (charstring));
            }
            }
            prev_c = c;
        } // end of line for loop

        printf("LOC: %d || SLOC: %d || {} Scope: %d     %s", num_lines, SLOC, cbtotal, line_print);
        memset(charstring, 0, sizeof (charstring));

        memset(line, 0, sizeof(line));


    } // end of while loop
    printf("\n");
    printf("FINAL REPORT: ");
    printf("Total lines of physical code:  %d\n", num_lines);
    printf("Total lines of logical code (SLOC/LLOC):  %d\n", SLOC);
    printf("Maximum {} scope in the code: %d\n", cbmax);
}

int main() {
    //run SLOCC counter
    SLOCC();
    return 0;
}