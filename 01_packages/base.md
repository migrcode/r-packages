

### Switch is a more compact version of if-else

```
x_option <- function(x) {
  switch(x,
    a = "option 1",
    b = "option 2",
    c = "option 3",
    stop("Invalid `x` value")
  )
}
```
by https://adv-r.hadley.nz/control-flow.html

