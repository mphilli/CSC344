;;; ASSIGNMENT 2 - LISP (CSC 344)*

;; seeds a random state at program startup 
(setf *random-state* (make-random-state t)) 
(setq *print-case* :downcase)

;; list for gladiator frequencies 
(setq gladlist '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

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
(format t "Probability (PART I):~C" #\linefeed)
(setq prob 1)
(setq doorsp '(T T T T D D D))
(setq n 0)
(loop
(setq prob (* prob (/ 3 (length doorsp))))
(setq doorsp (remove 'T doorsp :count 1))
(format t "Probability that ~d gladiators remain alive: ~d (~5f)~C" (+ 1 n) prob prob #\linefeed) 
(setq n (+ 1 n))
(when (= n glad_num)(return))))


;;SCENARIO FUNCTION 
(defun choices ()
(setq live 1)
(setq i 0)  
(loop 
(setq rand (random (length doors)))
(setq choice (nth rand doors))
(cond ((eq choice 'd) 
	(setq doors (remove 'T doors :count 1))
	(setq t_count (- t_count 1))
	(cond ((eq live 1)
	    (modify_number)
		) (t())))
	(T(setq live 0)))

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
(defun modify_number()
(setf (nth i gladlist) (+ 1 (nth i gladlist))))

(defun print_frequencies() 
(format t "Simulation and frequencies: (PART II):~C" #\linefeed)
(setq x 0) 
(loop 
(format t "Frequency that ~d gladiators lived: ~d~C" (+ 1 x) (nth x gladlist) #\linefeed)
(setq x (+ 1 x))
(when (eq x glad_num) (return))))

(format t "~C" #\linefeed)
(probability) ;; reprints the probabilities
(format t "~C" #\linefeed)
(iterate) ;; runs main function 
(print_frequencies) 