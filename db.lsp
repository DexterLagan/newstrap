(module "mysql.lsp")

;;; defs

;; attempt to load a db configuration file
(define (maybe-load-settings filename)
    (if (file? filename) 
        (eval-string (read-file filename))))

;; quick error and exit
(define (die error-message)
    (println error-message)
    (exit 1))

;; returns true if the string is not empty
(define (non-empty? s)
    (if (empty? s) nil true))

;; returns true and print the error if a MySQL error is detected, else return nil
(define (maybe-print-mysql-error)
    (if (non-empty? (MySQL:error))
        (print "MySQL Error: " (MySQL:error))
        nil))

;; predicate returns true if connected to the database
(define (connected? db-config)
    (apply MySQL:connect db-config))

;; print a string followed by a variable number of spaces for alignement
(define (printsp s)
    (let (spacing 16)
        (if (nil? s)
            (print "\"\" " (dup " " (- spacing 2)))
            (print s (dup " " (- spacing (length s)))))))

;; utility function that prints SQL query results as table
(define (display-sql query)
    (MySQL:query query)
    (dotimes (x (MySQL:num-rows))
        (map printsp (MySQL:fetch-row))
        (println)))
; unit test
;(display-sql "select * from mw_lans")

;; builds a 2-dimentional list of results
(define (query-record query)
    (MySQL:query query)
    (unless (maybe-print-mysql-error)
        (MySQL:fetch-all)))

;; returns a value from a single query
;; i.e. "SELECT count(*) FROM product WHERE status = 1"
(define (query-value query)
    (MySQL:query query)
    (unless (maybe-print-mysql-error)
        (first (MySQL:fetch-row))))
; unit test
;(print (query-value "SELECT count(*) FROM mw_lans WHERE id_lan = 1 AND id_lanp = 1"))

;; returns a value from a single query
;; i.e. "SELECT name FROM product WHERE status = 1"
(define (query-string query)
    (MySQL:query query)
    (unless (maybe-print-mysql-error)
        (first (MySQL:fetch-row))))
; unit test
;(print (query-string "SELECT Nom FROM mw_lans WHERE id_lan = 1 AND id_lanp = 1"))

;; prints the description of a table
(define (describe table)
    (println "\nTable " table " description:")
    (display-sql (append "DESCRIBE " table)))
; unit test
;(describe "mw_lans")

;; shortcut to close db
(define (close-db)
    ;(println "\nConnection to database closed.")
    (MySQL:close-db))

;;; main

(maybe-load-settings "db.conf")
(unless SETTINGS:db-config 
        (die "Could not load database configuration file."))

; initialize database client
(MySQL:init)

; connect to database and display an error if not successful
(unless (connected? SETTINGS:db-config) 
        (die "Could not connect to database."))

(close-db)
(exit)

; EOF
