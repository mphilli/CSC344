;;; ASSIGNMENT 2 - LISP (CSC 344)*

;; seeds a random state at program startup 
(setf *random-state* (make-random-state t)) 
(setq *print-case* :downcase)

(setq glad1 0)(setq glad2 0)(setq glad3 0)(setq glad4 0)
(setq glad5 0)(setq glad6 0)(setq glad7 0)(setq glad8 0)
(setq glad9 0)(setq glad10 0)(setq glad11 0)(setq glad12 0)
(setq glad13 0)(setq glad14 0)(setq glad15 0)(setq glad16 0)
(setq glad17 0)(setq glad18 0)(setq glad19 0)(setq glad20 0)


(format t  "~CGladiator Game~C" #\linefeed #\linefeed) 
(format t  "What is the number of gladiators (1-20)? ")
(setq input_num (read))

;; makes sure N gladiators is between 1 and 20
(defun check (input_num)
(cond ((or (> input_num 20) (< input_num 1))
	  (format t "Number of gladiators must be 1 to 20: ")
	  (setq input_num (read))
	  (check input_num))
	  (t (setq input_num input_num))))
	  
(setq input_num (check input_num))
(setq glad_num input_num)

;;function for computing the probabilities
(defun probability ()
(setq prob 1)
(setq doorsp '(T T T T D D D))
(setq n 0)
(loop
(setq prob (* prob (/ 3 (length doorsp))))
(setq doorsp (remove 'T doorsp :count 1))
(setq n (+ 1 n))
(when (= n glad_num)(return))))


;;SCENARIO FUNCTION 
(defun choices ()
(probability) ;; reprints the probabilities
(setq i 0)  
(loop 
(setq rand (random (length doors)))
(setq choice (nth rand doors))
(cond ((eq choice 'd) 
	(setq doors (remove 'T doors :count 1))
	(setq t_count (- t_count 1))
	(modify_num))
	(T))

;; END OF LOOP 
(setq i (+ 1 i))
(when (= i glad_num) (return))))

;;1000x iteration ~
(defun iterate() 
(setq j 1)
(loop 
;; doors to choose from 
(setq doors '(T T T T D D D)) ;; choosable doors
(setq prob 1) ;; probability tracker 
(setq t_count 4) ;; keeps count of tigers
 ;;sets the number of gladiators to input number
	(choices) ;; RUNS SCENARIO 
	
(setq j (+ 1 j)) 
(when (= j 1001) (return))))
;;end of loop

(defun modify_num()
(if (and (eq i 0) (eq choice 'd))
(setq glad1 (+ 1 glad1)))
)

(iterate) ;; runs main function 
(princ glad1)
