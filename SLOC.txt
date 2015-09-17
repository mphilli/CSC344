/*
 * Source Lines of Code Counter, C++ (for Java programs)
 */

#include <iostream>
using namespace std;
#include <stdio.h>
#include <string>
#include <vector> // similar to Java ArrayList<> data type

void SLOC() {

    // ARRAY OF KEYWORDS 
    vector<string> statements; // keywords which are statements
    statements.push_back("for");
    statements.push_back("if");
    statements.push_back("while");
    statements.push_back("else");
    statements.push_back("switch");
    statements.push_back("do");
    cout << "Source Lines of Code Counter Program" << endl;
    cout << "Please enter a Java Program, then type __END__\n" << endl;
    /* VARIABLES */
    string line; // the individual line of code being evaluated
    int num_lines = 0; // counts the total number of lines of code
    int cbcountL = 0; //keeps count of left curly brackets { 
    int cbcountR = 0; //keeps count of right curly brackets } 
    int cbtotal = 0; // keeps count of {} scope
    int cbmax; // helps identify the maximum {} scope in a single line 
    int SLOC = 0; //counts the number of source lines of code
    int lparen = 0; // helps count and balance parentheses (left))
    int rparen = 0; // helps count and balance parentheses (right)
    bool multicomment = false; //checks if the code is in a multi-line comment  
    bool multisetup = false; // helps keep track of multi-line comment chars
    bool inparen = false; // keeps track of parts of the line in parenthesis
    bool instatement = false; // keeps track statement declarations
    bool prev_star = false; // helps keep track of multi-line comments
    bool afterwhile = false; //helps identify environments after while
    bool afterfor = false; //helps identify environments after for
    bool afterdo = false; // helps identify environments after do

    /* GETS THE CODE LINE BY LINE FROM STANDARD INPUT*/
    while (getline(cin, line)) {
        /* VARIABLES WHICH RESET LINE BY LINE*/
        string charstring = ""; //builds a string from individual chars
        char pc = '\0'; // keeps track of the previous character 
        char prev_c; //the previous char
        int slashcount = 0; //helps make sure '/' chars are next to each other
        int quote_num = 0; // helps keep track of code inside quotes
        int charquote_num = 0;
        bool incomment = false; //checks if the code is in a comment
        bool inquotes = false; // checks if the code is inside quotes
        bool incharquotes = false; // checks if the code is in single quotes
        bool isstatement = false; // helps keep track of statements

        // WHILE LOOP BREAK CONDITION 
        if (line.compare("..quit..") == 0 || line.compare ("__END__") == 0) {
            break;
        }
        num_lines++;

        /*GETS THE CODE CHAR BY CHAR FROM STANDARD INPUT*/
        for (int i = 0; i < line.length(); i++) {
            char c = line.at(i); //the current char being evaluated
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
            if (isstatement == true) {
                isstatement = false;
                if (c != ' ' && c != '(') {
                    SLOC--;
                    instatement = false;
                }
            }

            if (c == '*') {
                prev_star = true;
            }

            //CHECKING FOR COMMENTS
            if (c == '/' && slashcount == 0) {
                slashcount = 1;
                multisetup = true;
            } else if (c == '/' && slashcount == 1 && !inquotes &&
                    !incharquotes) {
                incomment = true;
                slashcount = 0;
            }

            // CHECKING FOR MULTI-LINE COMMENTS
            if (c == '*' && multisetup == true) {
                multicomment = true;
            } else if (c == '/' && multisetup == true) {
                //hold
            } else {
                multisetup = false;
            }
            if (prev_star && c == '/') {
                multicomment = false;
                incomment = false;
                prev_star = false;
                c = ' ';
            }

            //CHECKING FOR STRING QUOTES
            if (c == '"' && !incharquotes) {
                quote_num++;
            }
            if (quote_num % 2 != 0 && c != '"') {
                inquotes = true;
            } else if (quote_num % 2 == 0) {
                inquotes = false;
            }

            //CHECKING FOR CHAR QUOTES
            if (c == '\'' && !inquotes) {
                charquote_num++;
            }
            if (charquote_num % 2 != 0) {
                incharquotes = true;
            } else if (charquote_num % 2 == 0) {
                incharquotes = false;
            }

            //CHECKING FOR PARENTHESES 
            if (c == '(') {
                inparen = true;
                lparen++;
            }
            if (c == ')') {
                rparen++;
                if (lparen == rparen) {
                    inparen = false;
                    rparen = 0;
                    lparen = 0;
                }
            }

            //COUNTING SEMICOLONS
            if (c == ';' && !incomment && !inquotes && !afterfor &&
                    !multicomment && !incharquotes && !afterwhile) {
                SLOC++;
                instatement = false;
            } else if (c == ';' && afterwhile) {
                afterwhile = false;
            }
            if (c == ';' && !inparen && afterfor) {
                afterfor = false;
                instatement = false;
                SLOC++;
            }
            if (c == ':' && !incomment && !inquotes && !multicomment
                    && !incharquotes && !inparen && prev_c != ':') {
                SLOC++;
            }

            // COUNTING LEFT BRACKETS
            if (c == '{' && !incomment and !inquotes && !incharquotes &&
                    !instatement && !multicomment) {
                SLOC++;
                instatement = false;
            }

            if (c == '{' && instatement) {
                instatement = false;
            }
            if (c == '{' && afterwhile) {
                afterwhile = false;
            }
            //@ ANNOTATIONS
            if (c=='@' &&  !incomment and !inquotes && !incharquotes &&
                    !instatement && !multicomment &&) {
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
                charstring = charstring + c;
            }

            if (c == ' ' || c == '	' || c == ';' || c == ':') {
                pc = c;
                charstring = "";
            }

            // CHECK FOR STATEMENTS
            for (int i = 0; i < statements.size(); i++) {
                if (statements[i].find(charstring) != string::npos) {
                    if (statements[i].compare(charstring) == 0 && !incomment 
                            && !multicomment && !inquotes && !incharquotes) {
                        SLOC++;
                        instatement = true;
                        isstatement = true;
                        if (charstring.compare("while") == 0) {
                            if (afterdo) {
                                afterwhile = true;
                                afterdo = false;
                            }
                        }
                        if (charstring.compare("for") == 0) {
                            afterfor = true;
                        }
                        if (charstring.compare("do") == 0) {
                            afterdo = true;
                        }
                        charstring = "";
                    }
                }
            }
            prev_c = c;
        } // end of line for loop

        charstring = "";

        cout << "LOC: " << num_lines << " || SLOC: " << SLOC <<
                " || {} Scope : " << cbtotal
                << "     " <<
                line << endl;
    } // end of while loop
    cout << "     " << endl;
    cout << "FINAL REPORT: " << endl;
    cout << "Total lines of physical code:  " << num_lines << endl;
    cout << "Total lines of logical code (SLOC/LLOC):  " << SLOC << endl;
    cout << "Maximum {} scope in the code: " << cbmax << endl;
}

int main() {
    //run SLOC counter
    SLOC();
    return 0;
}