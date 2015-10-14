;;; CSC344 LISP (ASSIGNMENT 2)

(setf *random-state* (make-random-state t)) 


(format t "What is the number of gladiators? (1-20): ") 
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
(setq ldlist '("L" "D")) 
(setq inlist '("L" "D"))
(setq outlist '())

;;; PART I: PROBABILITY 
(format t "~C" #\linefeed) (format t "Probabilities for the gladiators: ~C" #\linefeed) 
;;PRINTS LITERAL STRINGS OF LIFE (L) OR DEATH (D) 
(defun litprob()
(setq u 1)(setq j_val 1) 
(loop (setq i 0)(setq k 0)
(loop (setq j 0) 
(loop
(if (or (> k (list-length outlist)) (= k (list-length outlist)))
(setf outlist (append outlist '(0)))) ;; makes a new element
(setf (nth k outlist) (concatenate 'string (nth i ldlist) (nth j inlist)))
(setq j (+ 1 j)) (setq k (+ 1 k))
(when (= j (* j_val 2)) (return)))
(setq i (+ 1 i))
(when (= i (list-length ldlist)) (return)))
(setq u (+ 1 u))
(setq j_val (+ j_val j_val))
(setf inlist (copy-list outlist))
(when (= u glad_num) (return))) ;; END OF LOOP
(setf outlist outlist))

(cond ((= glad_num 1)
(setq outlist '("L" "D"))) (t (litprob)))

;; create parallel lists for lcount and probabilities
(setq lclist '()) ;; how many gladiators lived in each element in the "outlist" list 
(setq problist '()) ;; list of probabilities for each element in the "outlist" list 

(defun run_loop() 
(setq stringcount 0)(setq lcount 0)
(loop

(setq curr (subseq (nth loopcount outlist) stringcount (+ stringcount 1)))

(cond ((string= curr "L")
	(setq lcount (+ lcount 1))
	(setq currprob (* currprob (/ 3 (length doorsp))))
	(setq doorsp (remove 'T doorsp :count 1))
	(cond ((> t_count 0)
	(setq t_count (- t_count 1))) 
	(t (setq t_count 0))) ;;*ERR: should not go beneath 0
	) ((and (string= curr "D") (= t_count 0))
		(setq currprob 0) 
		 ) (t     	(setq currprob (* currprob (/ t_count (length doorsp))))))
	(setf (nth loopcount lclist) lcount) 
	(setf (nth loopcount problist) currprob)
;;(format t "curr: ~s || ~d~d: ~d~d~C" curr loopcount ;;temp 
;;(- (length (nth loopcount outlist)) 1) stringcount (+ stringcount 1) #\linefeed) ;; temp
(setq stringcount (+ stringcount 1))
(when (= stringcount (length (nth loopcount outlist))) (return))))

(setq loopcount 0) (loop 
(setf lclist (append lclist '(0)))
(setf problist (append problist '(1)))
(setq doorsp '(T T T T D D D)) ;; the CHOOSEABLE doors 
(setq t_count 4)
(setq currprob 1) ;; the probability
(run_loop) 
(setq loopcount (+ 1 loopcount))
(when (= loopcount (list-length outlist)) (return)))
(setq aproblist (make-list (+ 1 glad_num)))

(setq e 0) (loop 
(cond ((eq (nth (nth e lclist) aproblist) NIL)
	(setf (nth (nth e lclist) aproblist) 0) ))
(setf (nth (nth e lclist) aproblist) (+ (nth (nth e lclist) aproblist) (nth e problist)))
(setq e (+ e 1)) (when (= e (length lclist)) (return)))
(setq ee 0) (loop 
(format t "The probability that ~d gladiators remain alive: ~d (~5f) ~C"
ee (nth ee aproblist) (nth ee aproblist) #\linefeed)
(setq ee (+ ee 1)) (when (= ee (+ glad_num 1)) (return)))

;; PART 2 FREQUENCY 

(format t "~CAfter 1000 scenarios, here are the observed frequencies: ~C" #\linefeed #\linefeed)
(setq freqlist '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)) 
(setq iter 0) (loop 

(setq doors '(T T T T D D D)) ;; choosable doors
(setq dovechoice 0)	

(setq iter2 0) (loop 

(setq rand (random (length doors)))
(setq choice (nth rand doors))
(cond ((eq choice 'D) ;; D means Dove here, not Die
	(setq dovechoice (+ dovechoice 1))
	(setq doors (remove 'T doors :count 1))))
	
	(setq iter2 (+ iter2 1))
	(when (= iter2 glad_num) (return)))
	(setf (nth dovechoice freqlist) (+ (nth dovechoice freqlist) 1))
(setq iter (+ iter 1)) 
(when (= iter 1001) (return)))

;;print frequencies 
(setq final 0) (loop
(format t "The frequency that ~d gladiators remained alive: ~d~C" final (nth final freqlist) #\linefeed)
(setq final (+ final 1))
(when (= final (+ glad_num 1))  (return)))

