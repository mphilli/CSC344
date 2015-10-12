;;; ASSIGNMENT 2 - LISP (CSC 344)*

;; seeds a random state at program startup 
(setf *random-state* (make-random-state t)) 
(setq *print-case* :downcase)

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
(cond ((= n 0) 	
	(format t "~C Probability that ~d gladiator remains alive: ~d (~4f)"
	#\linefeed (+ n 1) prob (float prob))) (t 
	(format t "~C Probability that ~d gladiators remain alive: ~d (~4f)"
	#\linefeed (+ n 1) prob (float prob))))
(setq n (+ 1 n))
(when (= n glad_num)(return))))

;; (probability)

;;SCENARIO FUNCTION 
(defun choices ()
(probability) ;; reprints the probabilities
(setq i 0)  
(loop 
(setq rand (random (length doors)))
(setq choice (nth rand doors))

(format t "~C~s"  #\linefeed doors)
(cond ((eq choice 'd) 
	(format t " He lives! ")
	(setq doors (remove 'T doors :count 1))
	(setq t_count (- t_count 1)))
	(T  
		(format t " He dies! ")
	))

;; END OF LOOP 
(setq i (+ 1 i))
(when (= i glad_num) (return))))

;;1000x iteration ~
(defun iterate() 
(setq j 1)
(loop 
;; doors to choose from 
(format t "~C Scenario, #~d: "  #\linefeed j) 
(setq doors '(T T T T D D D)) ;; choosable doors
(setq prob 1) ;; probability tracker 
(setq t_count 4) ;; keeps count of tigers
 ;;sets the number of gladiators to input number
	(choices) ;; RUNS SCENARIO 
	
(setq j (+ 1 j)) 
(format t "~C" #\linefeed)
(when (= j 1001) (return))))
;;end of loop

(iterate) ;; runs main function 
