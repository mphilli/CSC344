/* CSC 344 ASSIGNMENT 3 (Scala) */

import scala.io.StdIn.readLine;


// TREE CLASS FOR DESCENT PARSING: 
abstract class Tree(Any: Any)
case class S(E: E, EOF: Char) extends Tree
case class E(T: T, E2: E2) extends Tree
case class E2(OR_OP: Char, E3: E3) extends Tree
case class E3(T: T, E2: E2) extends Tree
case class T(F: F, T2: T2) extends Tree
case class T2(F: F, T2: T2) extends Tree
case class F(A: A, F2: F2) extends Tree
case class F2(OP_OP: Char, F2: F2) extends Tree
case class A(C: Char, A2: A2) extends Tree {
	def this(C: Char) = this(C, null)
}
case class A2(E: E, C: Char) extends Tree
case class OR_OP(or_op: Char) extends Tree

object regecx {
	def main(args: Array[String]) = {

		println("Pattern Matching Program (Regular Expressions)\n")
		var pattern: String = readLine("pattern? ") + '$'
		val parsed = new parse(pattern, 0);
		println(parsed.parseS());
		var string = readLine("string? ")
		println("###"); 
	}
}

//recursive top-down descent parsing class
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

	// parse methods, utilizing abstract tree class 

	def parseS(): S = {
		S(parseE(): E, '$')
	}

	def parseE(): E = {

		E(parseT, parseE2)

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
		/* else if (peek != '?' && peek != '|' && peek == ')' && peek!='(') {
	     if (curchar <= unparsed.length()) {continue();}
	    A(peek, null);
	   }
	   */
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
			// FIX ! 
			unparsed = unparsed.substring(0, curchar) + '|' + unparsed.substring(curchar, unparsed.length());
			if (curchar < unparsed.length() - 1) {
				continue ();
			}
			return null; // for now
		} else if (peek == '|' && back == '|') {
			return null;
		} else return null;
	}

	def parseE3(): E3 = {
		E3(parseT(), parseE2());
	}
}

/* 
 * PART I (actually parsing the tree) complete 
 * TO DO: 
 * - fix-up and finish PARSE class & method(s) (as needed) 
 * - figure out how to evaluate incoming strings ("Part II") 
 */
