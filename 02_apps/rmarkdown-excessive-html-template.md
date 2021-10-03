The following goes into a test.Rhtml file:

```
<!DOCTYPE html>
<html>
<head>
  <title>A minimal knitr example in HTML</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>
  
    <style>
      .bd-placeholder-img {
        font-size: 1.125rem;
        text-anchor: middle;
        -webkit-user-select: none;
        -moz-user-select: none;
        user-select: none;
      }

      @media (min-width: 768px) {
        .bd-placeholder-img-lg {
          font-size: 3.5rem;
        }
      }
      
      main > .container {
       padding: 60px 15px 0;
      }
    </style>
  </head>
<body class="d-flex flex-column h-100">

<header>
  <!-- Fixed navbar -->
  <nav class="navbar navbar-expand-md navbar-dark fixed-top" style="background-color: #333333;">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Bootstrap</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarCollapse">
        <ul class="navbar-nav me-auto mb-2 mb-md-0">
          <li class="nav-item">
            <a class="nav-link active" aria-current="page" href="#">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#">Link</a>
          </li>
        </ul>
 <span class="navbar-text">
       <img src="https://getbootstrap.com/docs/5.1/assets/brand/bootstrap-logo.svg" alt="" width="30" height="24" class="d-inline-block align-text-top">
      </span>
      </div>
    </div>
  </nav>
</header>

<!-- Begin page content -->
<main class="flex-shrink-0">
  <div class="container">
    <h1 class="mt-5">Sticky footer with fixed navbar</h1>
    <p class="lead">Pin a footer to the bottom of the viewport in desktop browsers with this custom HTML and CSS. A fixed navbar has been added with <code class="small">padding-top: 60px;</code> on the <code class="small">main &gt; .container</code>.</p>
    <p>Back to <a href="/docs/5.0/examples/sticky-footer/">the default sticky footer</a> minus the navbar.</p>
  </div>
</main>



<div class="container">

<!-- spielwiese -->

<span class="badge rounded-pill bg-primary">Primary</span>
<span class="badge rounded-pill bg-secondary">Secondary</span>
<span class="badge rounded-pill bg-success">Success</span>
<span class="badge rounded-pill bg-danger">Danger</span>
<span class="badge rounded-pill bg-warning text-dark">Warning</span>
<span class="badge rounded-pill bg-info text-dark">Info</span>
<span class="badge rounded-pill bg-light text-dark">Light</span>
<span class="badge rounded-pill bg-dark">Dark</span>
<!-- spielwiese end -->

</div>


<br /><br />

<div class="container">

<div id = "codeblock">
<!--begin.rcode
  knitr::opts_chunk$set(fig.width=5, fig.height=5)
  end.rcode-->
</div>


  <p class="lead">This is a minimal example that shows
  how <strong>knitr</strong> works with pure HTML
  pages.</p>

  <p class="lead">Boring stuff as usual:</p>


<div id = "codeblock">
<!--begin.rcode
    # a simple calculator
    1 + 1
    # boring random numbers
    set.seed(123)
    rnorm(5)
    end.rcode-->
</div>



  <p>We can also produce plots (centered by the
  option <code>fig.align='center'</code>):</p>

<!--begin.rcode cars-scatter, fig.align='center'
    plot(mpg ~ hp, data = mtcars)
    end.rcode-->
    
<!--begin.rcode
    myvar <- 1
    myvar
    end.rcode-->

  <p>Errors, messages and warnings can be put into
  <code>div</code>s with different <code>class</code>es:</p>

<div id = "codeblock">
<!--begin.rcode
    sqrt(-1)  # warning
    message('knitr says hello to HTML!')
    1 + 'a'  # mission impossible
    end.rcode-->
</div>

  <p>Well, everything seems to be working. Let's ask R what is
  the value of &pi;? Of course it is <!--rinline pi -->.</p>

</div>

<footer class="footer mt-auto py-3 bg-light">
  <div class="container">
    <span class="text-muted">Place sticky footer content here.</span>
  </div>
</footer>




</body>
</html>
```

You can knitr this file with the following code in an .Rmarkdown file:

```
---
title: "Tile Info Test"
author: "Allen OBrien"
date: "6/11/2020"
output:
  html_document:
    theme: flatly
    highlight: tango
---


```{r}
knitr::knit("test.Rhtml")
```
```
