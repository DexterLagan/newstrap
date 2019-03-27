; purpose

; to provide a minimum web app framework using boostrap 3.4 or newer

; see the following pages for sample content 
; http://bootstrapdocs.com/v3.3.4/docs/examples/theme/
; http://bootstrapdocs.com/v3.3.4/docs/getting-started/#examples

; use following links for CDN-hosted CSS, Theme, jQuery and Javascript :
; "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css"
; "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap-theme.min.css"
; "https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"
; "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"

;;; consts

(define html-template   "template.html")
(define html-tag        "<!-- page content -->")

;;; defs

; replace html-tag in html-template by content and return the html
(define (output-html content)
    (print (replace html-tag (read-file html-template) content)))

; create a temporary html pag and point a browser to it
(define (display content filename)
    (let (html (replace html-tag (read-file html-template) content))
        (write-file filename html))
    (process (append (first (exec "which google-chrome")) " " filename)))

; UNUSED:
; replace each pair of strings in the list l in the source s
; i.e. (multi-replace '("some" "none" "something" "else") "some string, something"))
(define (multi-replace l s)
    (if (or (null? l) (null? s)) s
        (if (< (length l) 2) s
            (multi-replace (2 l) (replace (l 0) s (l 1))))))

; multi-<br> tag maker
(define (br)
    (let (a (args))
        (if (null? a) "<br>"
            (when (number? (a 0)) (dup "<br>" (a 0))))))
; unit test
;(println (br 5))

;;; system macros

; macro collates arguments with append
(macro (aargs) (apply append (args)))

; macro defines a function that returns its arguments appended between header and footer
(macro (define-append Func Header Footer)
    (define Func (lambda () (append Header (apply append (args)) Footer ))))
; example - instead of :
;(define container
;    (lambda () (append "<div class='container' role='main'>" (aargs) "</div>")))
; you can write :
;(define-append container "<div class='container' role='main'>" "</div>")

; macro wraps each item in a list by enclosing tags
(macro (map-append Open-tag List Close-tag)
        (join (map (lambda (s) (append Open-tag s Close-tag)) List)))

; generates a string built out of a 2-dimentional list rows-list and the matching tags
(define (map-append2 open-tag row-open-tag rows-list row-close-tag close-tag)
         (map-append open-tag 
            (map (lambda (cell) 
                    (map-append row-open-tag cell row-close-tag)) rows-list)
                    close-tag))

;;; bootstrap grid system

(define-append container    "<div class='container' role='main'>" "</div>")
(define-append row          "<div class='row'>"                   "</div>")
(define-append column       "<div class='col-sm'>"                "</div>")
(define-append horizontal   "<p>"                                 "</p>") ; when chaining controls horizontally

;;; visual elements

; displays a page title
(define-append title        "<div class='page-header'><h1>"         "</h1></div>")

; function that takes a list of pairs of strings and appends them to opening, middle and closin tags in the following way :
; open-tag s1 mid-tag s2 close-tag
(define (multi-append open-tag mid-tag close-tag pairs-list)
    (define (multi-append-rec l r)
        (if (null? l) r
            (if (< (length l) 2) r
                (append r (multi-append-rec (2 l) (append open-tag (l 0) mid-tag (l 1) close-tag))))))
    (multi-append-rec pairs-list ""))
; unit test
; (println (multi-append "<open>" "<mid>" "<close>" '("title1" "url1" "title2" "url2" "title3" "url3" "title4" "url4")))

; same as multi-append but returns a list of strings for later processing
(define (multi-append-list open-tag mid-tag close-tag pairs-list)
    (define (multi-append-rec l r)
        (if (null? l) r
            (if (< (length l) 2) r
                (cons r (multi-append-rec (2 l) (append open-tag (l 0) mid-tag (l 1) close-tag))))))
    (1 (multi-append-rec pairs-list '()))) ; cuts initial empty list
; unit test
;(println (multi-append-list "<open>" "<mid>" "<close>" '("title1" "url1" "title2" "url2" "title3" "url3" "title4" "url4")))

; generates a string containing a list of key-pair values englobed by opening, middle and closing tags
; first three parameters are the opening, middle, closing tags as strings
; last parameter is a flat list of key-pair values
(define (make-key-value-html-lines inactive-item-tag active-item-tag active-item-index open-tag mid-tag close-tag pairs-list)
    (let (links (multi-append-list open-tag mid-tag close-tag pairs-list))
        (setf (nth active-item-index links)
              (replace (append "<"  inactive-item-tag ">")
                       (nth         active-item-index links)
                       (append  "<" inactive-item-tag " " active-item-tag ">")))
        (join links)))
; unit test
;(println (make-key-value-html-lines "li" "class='active'" 0 "<li><a href='" "'>" "</a></li>" '("title1" "url1" "title2" "url2" "title3" "url3" "title4" "url4")))
; should return:
;            <li class="active"><a href='#'>Home</a></li>
;            <li><a href='#about'>About</a></li>
;            <li><a href='#contact'>Contact</a></li>

; displays a fixed navbar with the typical pop-up menu. Takes any number of extra parameters:
(define (navbar title-link title active-item-index) ; link1 menu1 link2 menu2 link3 menu3 ...
    (let (active-item-tag "class='active'")
        (append "
    <nav class='navbar navbar-inverse navbar-fixed-top'>
      <div class='container'>
        <div class='navbar-header'>
          <button type='button' class='navbar-toggle collapsed' data-toggle='collapse' data-target='#navbar' aria-expanded='false' aria-controls='navbar'>
            <span class='sr-only'>Toggle navigation</span>
            <span class='icon-bar'></span>
            <span class='icon-bar'></span>
            <span class='icon-bar'></span>
          </button>
          <a class='navbar-brand' href='" title-link "'>" title "</a>
        </div>
        <div id='navbar' class='navbar-collapse collapse'>
          <ul class='nav navbar-nav'>"
;            generating the following lines from the leftover arguments :
;            <li class="active"><a href='#'>Home</a></li>
;            <li><a href='#about'>About</a></li>
;            <li><a href='#contact'>Contact</a></li>
             (make-key-value-html-lines "li" active-item-tag active-item-index "<li><a href='" "'>" "</a></li>" (args))
         "</ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>")))
; unit test
;(println (navbar "#" "My Title" 0 "link1" "title1" "link2" "title2" "link3" "title3"))
; should return these lines in the menu:
;            <li class="active"><a href='#'>Home</a></li>
;            <li><a href='#about'>About</a></li>
;            <li><a href='#contact'>Contact</a></li>

; displays a large frame for important messages and promotions
(define (jumbotron title content)
    (append "<div class='jumbotron'><h1>" title "</h1><p>" content "</p></div>"))

; button types:
; default, primary, success, info, warning, danger, link
(define (button type title)
    (append "<button type='button' class='btn btn-" type "'>" title "</button>"))

; returns a link to the provided url showing the provided text
(define (link title url)
    (append "<a href='" url "'>" title "</a>"))

; bootstrap's fancy button link
(define (link-button title url)
    (append "<a href='" url "'><button type='button' class='btn btn-link'>" title "</button></a>"))

; display a table. Rows is a list of rows, each row being a list of string cells.
(define (table headers rows)
    (append
    "<div class='row'>
       <div class='col-md-6'>
          <table class='table table-striped'>
            <thead>
              <tr>"
                (map-append "<th>" headers "</th>")
             "</tr>
            </thead>
            <tbody>"
                (map-append2 "<tr>" "<td>" rows "</td>" "<tr>")
            "</tbody>
           </table>
          </div>
        </div>"))

; displays tabs, active-tab being the tab number to set as selected
; support value pairs for the other parameters to describe tabs
(define (tab-bar active-tab-index) ; link1 title1 link2 title2 link3 title3)
    (letn (active-tab-tag "class='active'")
        (append "<ul class='nav nav-tabs' role='tablist'>"
                    (make-key-value-html-lines "li role='presentation'" active-tab-tag active-tab-index "<li role='presentation'><a href='" "'>" "</a></li>" (args))
                  ; genates the following lines:
                  ; <li role='presentation' class='active'><a href='" link1 "'>" title1 "</a></li>
                  ; <li role='presentation'><a href='" link2 "'>" title2 "</a></li>
                  ; <li role='presentation'><a href='" link3 "'>" title3 "</a></li>
                "</ul>")))
; unit test
;(println (tab-bar 0 "link1" "title1" "link2" "title2" "link3" "title3"))

; displays a thumbnail with alternative text
(define (thumbnail image alt)
    (append "<img src='" image "' class='img-thumbnail' alt='" alt "'>"))

;;; basic HTML visual elements

(define (text-field title id)
    (append title "<br><input type='text' name='" id "'>"))

;;; main

(println "newstrap v1.0 - Dexter Santucci - December 2018")

