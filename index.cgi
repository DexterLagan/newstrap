#!/usr/bin/env newlisp
(module "cgi.lsp")
(load "newstrap.lsp")
(load "db.lsp")
; purpose:  sample page for newstrap
; how to use:
; start the server with: 
;   sudo newlisp -http -d 80 -w ~/Code/newlisp/newstrap/
;   point your browser to http://localhost/index.cgi

;;; defs

;;; WIP

; needed to generate lists of product links:
; a function that generates links, given a query that returns a list of IDs and a base URL
; say the query "SELECT id, product_designation FROM products ..."
; the function will use the ID cell as basis for link target, and product_designation as link text.
; 
; returns a modified version of the rows-list
; each row's cell is replaced by a link to base-link using the first cell as ID
; from "123456"
; to   (append "<a href='" base-link "123456" "'>123456</a>")
; which resolves to:
;      "<a href='http://www.nodixia.net/app.cgi?action=product&id=123456'>123456</a>"

;(define (generate-rows-links rows-list base-link)
; for each row
;   get first cell's text
;   for each cell
;       generate a link to the base url, using the first cell's text as ID 
;       and the current cell's text as title.

;;; main

(define products 
    (query-record "SELECT produit_num, produit_idp, produit_num_serie, produit_categorie_nom FROM produit ORDER BY produit_num DESC LIMIT 5"))

(define content
    (append
        (navbar "http://www.mysite.com/home"    "My Web App" 1 
                "http://www.mysite.net/product" "Lookup Product..." 
                "http://www.mysite.com/faq"     "FAQ" 
                "http://www.mysite.com/about"   "About...")
        (br 2)
        (container
            (title "Bootstrap on newLISP")
            (tab-bar 0 "index.cgi" "Fiches" "product.cgi?id=12345" "Produits" "#" "Lots")
            (table '("ID" "IDP" "SN" "Category") products)
            (text-field "Fiche Number:" "fiche-id")
            (horizontal
                (button "default" "Default")
                (button "success" "Yes")
                (button "danger" "No"))
            (thumbnail "images/200x200.svg" "Random image!")
            (jumbotron "Important" "You should really read this, it looks very very important. Like vital or something.")
            (link "Google" "https://www.google.com/ncr")
    )))

(output-html content)
;(display content "index.html")
(close-db)
(exit)



