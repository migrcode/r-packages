# RStudio

## Snippets

### Path from Clipboard

With the following snippet, you can copy a path from your clipboard into RStudio whereas backslashes are automatically replaced by slashes. RStudio snippets can be added in `Tools > Global Options > Code > Edit Snippets`

```r
snippet ep
	`r gsub("\\\\", "/", readClipboard())`
```
**Usage**: Copy a path to your clipboard. In RStudio, type `e-p-tab` (remember as: "enter-path-tab").
