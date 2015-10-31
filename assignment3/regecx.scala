/*** CSC 344 ASSIGNMENT 3 - Scala ***/

import scala.io.StdIn.readLine

// Tree class for descent parsing: 
abstract class Tree
case class S(E: E, EOF: Char) extends Tree
case class E(T: T, E2: E2) extends Tree
case class E2(OR_OP: Char, E3: E3) extends Tree
case class E3(T: T, E2: E2) extends Tree
case class T(F: F, T2: T2) extends Tree
case class T2(F: F, T2: T2) extends Tree
case class F(A: A, F2: F2) extends Tree
case class F2(OP_OP: Char, F2: F2) extends Tree
case class A(C: Char, A2: A2) extends Tree
case class A2(E: E, C: Char) extends Tree

object regecx {
	def main(args: Array[String]) = {
		println("Pattern Matching Program (Regular Expressions)\n")
		val pattern: String = readLine("pattern? ") + '$'
		val parsed = new parse(pattern, 0)
		val parsed_pattern = parsed.parse
		var string = readLine("string? ")
		
		while (string != "(end)") { // no terminating input
			var isMatch: Boolean = evaluate(string, parsed_pattern, 0)
			if (isMatch) {
				println("match")
			}	else println("no match")
			string = readLine("string? ")
		}
	}

	def evaluate(string: String, parsed_pattern: S, cur: Int): Boolean = {
		var uneval: String = string + '$'
		var matchbool: Boolean = false
		var ulti: Boolean = true
		var pattern: S = parsed_pattern
		var f2bool: Boolean = false
		var curr = cur; var last: Int = 0
		
	def matchfn(x: Any): Any = x match {
			case x:S => matchfn(x.E)
			case x:E => matchfn(x.T)
				if (ulti == true) {} // end descent
				if (x.E2 != null && ulti==false) {
					ulti = true
					curr = last
					matchfn(x.E2)
				}
			case x:T => matchfn(x.F)
				if (x.T2 != null) {
					matchfn(x.T2)
				}
			case x:F =>
				if (x.F2 != null) {
					f2bool = true
				}
				matchfn(x.A)
			case x:A =>
				    if (x.C == uneval.charAt(curr)) {
				    	curr += 1
				    	matchbool = true
				    } else if (x.C == '<') {
			    	  last = curr;
					    matchfn(x.A2)
			    	} else if (x.C != uneval.charAt(curr) && f2bool == true) {
				    	matchbool = true
					    f2bool = false
				    } else {
				      ulti = false
				    }			
			case x:A2 => matchfn(x.E)
			case x:T2 => matchfn(x.F)
			    	if (x.T2 != null) {
				      	matchfn(x.T2)
			      	} 
			case x:E2 => matchfn(x.E3)
			case x:E3 => matchfn(x.T)
			    	if (ulti == true) {
				    	// look no further
				    } else if (x.E2 != null) {
					    ulti = true
					    matchfn(x.E2)
				    }
		}
		
		// for null inputs
    if(uneval=="$") {
    uneval = "\0"; 
    }
    
		matchfn(pattern)
		
		// some final checks	
		if (ulti == true && curr < uneval.length()-1) { 
		  ulti = false; 
		}
		
		if (ulti == false) {
			matchbool = false
		}
		curr = 0
		matchbool
	}
}

// recursive top-down descent parsing class
class parse(pattern: String, currchar: Int) {
	var curchar: Int = currchar;
	var unparsed: String = pattern;

	// some preliminary methods 
	def move () = {
		curchar = curchar + 1
	}

	def back(): Char = {
		unparsed.charAt(curchar - 1)
	}

	def peek(): Char = {
		if ((curchar + 1) == unparsed.length()) {
			'$'
		} else {
			unparsed.charAt(curchar)
		}
	}
    
  /* 
	Parseable form: 
	S  -> E$
  E  -> T E2
  E2 -> '|' E3 
  E2 -> NIL
  E3 -> T E2
  T  -> F T2
  T2 -> F T2
  T2 -> NIL
  F  -> A F2
  F2 -> '?' F2
  F2 -> NIL
  A  -> c
  A  -> '(' A2
  A2 -> E ')'  
	       */
	
	def parse(): S = {
	  // parsing starts here
	  if (unparsed=="$") {
	    // for null pattern inputs
	    S(E(T(F(A('\0',null),null),
	    null),null),'$')
	  }    else parseS()
	}

	def parseS(): S = {
		S(parseE(): E, '$')
	}

	def parseE(): E = {
		E(parseT(), parseE2())
	}

	def parseT(): T = {
		if (peek != ')') {
			T(parseF, parseT2)
		} else null
	}

	def parseF(): F = {
		F(parseA(), parseF2())
	}

	def parseA(): A = {
		if (peek != '?' && peek != '|' && peek != ')' && peek == '(') {
			A('<', parseA2())
		} else if (peek != '?' && peek != '|' && peek != ')' && peek != '(') {
			if (curchar <= unparsed.length()) {
				  move()
			}
			A(back, null)
		}
		else null
	}

	def parseA2(): A2 = {
		if (curchar <= unparsed.length()) {
			move ()
		}
		A2(parseE(), '>')
	}

	def parseF2(): F2 = {
		if (peek == '?') {
			if (curchar <= unparsed.length()) {
				move ()
			}
			F2('?', parseF2())
		} else null
	}

	def parseT2(): T2 = {
		if (peek != '|' && peek != ')' && peek != '$' && peek != '?' && curchar <= unparsed.length()) {
			T2(parseF(), parseT2())
		} else if (peek == ')') {
			if (curchar <= unparsed.length()) {
				move()
			}
			null
		} else null
	}

	def parseE2(): E2 = {
		if (peek == '|' && back != ')') {
			if (curchar < unparsed.length() - 1) {
				move()
			}
			E2('|', parseE3());
		} else if (back == ')' && peek == '|' && curchar < unparsed.length() - 1) {
			unparsed = unparsed.substring(0, curchar) + '|' + unparsed.substring(curchar, unparsed.length())
			if (curchar < unparsed.length() - 1) {
				move()
			}
			null
		} else if (peek == '|' && back == '|') {
			null
		} else null
	}

	def parseE3(): E3 = {
		E3(parseT(), parseE2())
	}
}