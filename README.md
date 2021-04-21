# newstrap
A fast, lightweight web framework written in newLISP

<h2>How does it look like?</h2>

![Alt text](/screenshots/20181215_102358893_iOS.jpg?raw=true "Screenshot")


<h2>How to use:</h2>
1) update the database configuration file:
<pre>
nano db.conf
</pre>
2) start the server with:
<pre>
sudo newlisp -http -d 80 -w ~/path/to/newstrap/
</pre>
3) point your browser to:
<pre>
http://localhost/index.cgi
</pre>

---

For further customization, see the following pages for sample content:
http://bootstrapdocs.com/v3.3.4/docs/examples/theme/
http://bootstrapdocs.com/v3.3.4/docs/getting-started/#examples

Use following links for CDN-hosted CSS, Theme, jQuery and Javascript:
https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css
https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap-theme.min.css
https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js
https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js

## License

Newstrap is free software; see [LICENSE](https://github.com/DexterLagan/newstrap/blob/main/LICENSE) for more details.
