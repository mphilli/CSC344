/* CSC 344 ASSIGNMENT 3 (Scala) */

import scala.io.StdIn.readLine;

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
case class OR_OP(or_op: Char) extends Tree

object regecx {
	def main(args: Array[String]) = {

		println("Pattern Matching Program (Regular Expressions)\n")
		var pattern: String = readLine("pattern? ") + '$'
		val parsed = new parse(pattern, 0);
		val parsed_pattern = parsed.parseS;
		//println(parsed_pattern); 
		var string = readLine("string? ")
		while (string != "") { // change to support null input 

			var isMatch: Boolean = evaluate(string, parsed_pattern, 0);
			if (isMatch) {
				println("match");
			} else {
				println("no match");
			}
			string = readLine("string? ")
		}
	}

	def evaluate(string: String, parsed_pattern: S, cur: Int): Boolean = {
		var uneval: String = string + '$';
		var matchbool: Boolean = false;
		var ulti: Boolean = true; // a stronger matchbool; varies far less often.
		var pattern: S = parsed_pattern;
		var f2bool: Boolean = false;
		var curr = cur;

		def matchfn(x: Any): Any = x match {

			case x:S => matchfn(x.E)
			case x:E => matchfn(x.T)
				if (ulti == true) {
					// look no further
				} else if (x.E2 != null) {
					ulti = true;
					matchfn(x.E2);
				}
			case x:T => matchfn(x.F);
				if (x.T2 != null) {
					matchfn(x.T2);
				}
			case x:F =>
				if (x.F2 != null) {
					f2bool = true;
				}
				matchfn(x.A);
			case x:A =>
				if (x.C == uneval.charAt(curr)) {
					curr += 1;
					matchbool = true;
				} else if (x.C == '<') {
					matchfn(x.A2);
				} else if (x.C != uneval.charAt(curr) && f2bool == true) {
					matchbool = true;
					f2bool = false;
				} else ulti = false;
			case x:A2 => matchfn(x.E);
			case x:T2 => matchfn(x.F);
				if (x.T2 != null) {
					matchfn(x.T2);
				} else null;
			case x:E2 => matchfn(x.E3); // fill in 
			case x:E3 => matchfn(x.T)
				if (ulti == true) {
					// look no further
				} else if (x.E2 != null) {
					ulti = true;
					matchfn(x.E2);
				}
		}

		matchfn(pattern);
        
		// some final checks
		if (curr < uneval.length() - 1) { // this is fine
			matchbool = false;
		}

		if (ulti == false) {
			matchbool = false;
		}
		curr = 0;
		return matchbool;
		return false;
	}
}

/* recursive top-down descent parsing class */

class parse(pattern: String, currchar: Int) {
	var curchar: Int = currchar;
	var unparsed: String = pattern;
	var next = unparsed.charAt(curchar + 1);

	// some preliminary methods 
	def
	continue () = {
		curchar = curchar + 1;
	}

	def back(): Char = {
		unparsed.charAt(curchar - 1);
	}

	def peek(): Char = {
		if ((curchar + 1) == unparsed.length()) {
			return '$';
		} else {
			return unparsed.charAt(curchar);
		}
	}
    
	// the parse methods, utilizing abstract tree class 
	def parse(): Tree = {
		return parseS();
	}

	def parseS(): S = {
		S(parseE(): E, '$')
	}

	def parseE(): E = {
		E(parseT(), parseE2())
	}

	def parseT(): T = {
		if (peek != ')') {
			T(parseF, parseT2);
		} else return null;
	}

	def parseF(): F = {
		F(parseA(), parseF2());
	}

	def parseA(): A = {
		if (peek != '?' && peek != '|' && peek != ')' && peek == '(') {
			A('<', parseA2());
		} else if (peek != '?' && peek != '|' && peek != ')' && peek != '(') {
			if (curchar <= unparsed.length()) {
				continue ();
			}
			A(back, null);
		}
		else {
			return null;
		}
	}

	def parseA2(): A2 = {
		if (curchar <= unparsed.length()) {
			continue ();
		}
		A2(parseE(), '>');
	}

	def parseF2(): F2 = {
		if (peek == '?') {
			if (curchar <= unparsed.length()) {
				continue ();
			}
			F2('?', parseF2());
		} else return null;
	}

	def parseT2(): T2 = {
		if (peek != '|' && peek != ')' && peek != '$' && peek != '?' && curchar <= unparsed.length()) {
			T2(parseF(), parseT2());
		} else if (peek == ')') {
			if (curchar <= unparsed.length()) {
				continue ();
			}
			return null;
		} else return null;
	}

	def parseE2(): E2 = {
		if (peek == '|' && back != ')') {
			if (curchar < unparsed.length() - 1) {
				continue ();
			}
			E2('|', parseE3());
		} else if (back == ')' && peek == '|' && curchar < unparsed.length() - 1) {
			unparsed = unparsed.substring(0, curchar) + '|' + unparsed.substring(curchar, unparsed.length());
			if (curchar < unparsed.length() - 1) {
				continue ();
			}
			return null;
		} else if (peek == '|' && back == '|') {
			return null;
		} else return null;
	}

	def parseE3(): E3 = {
		E3(parseT(), parseE2());
	}
}

/* 
Final TO DO: 
  - clean up/fixes where necessary 
  - allow the program to accept null input for patterns and strings 
  - decide if 'string? ' query will have a terminating command
*/ 