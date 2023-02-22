# ccr-quarto

Quarto template for [Computational Communication Research](https://computationalcommunication.org/ccr) (CCR)

## Creating a New Article

You can use this as a template to create an article for CCR. To do this, use the following command:

```sh
quarto use template vanatteveldt/ccr-quarto
```

It should prompt you for directory name. You may choose whether directory name you want. Suppose your choice is `ccrt`. You may test your quarto setup by immediately rendering the template.

```sh
cd ccrt
## default to pdf
quarto render ccrt.qmd
## experimental html support
quarto render ccrt.qmd --to=ccr-html
```

## Installing the extension

```sh
## If you have the extension locally at ./ccr-quarto
## quarto add ./ccr-quarto
quarto add vanatteveldt/ccr-quarto
quarto use template ccr-quarto
```
