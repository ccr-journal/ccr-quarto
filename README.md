# ccr-quarto

Quarto template for [Computational Communication Research (CCR)](https://journal.computationalcommunication.org/), a peer-reviewed, open-access, community-owned journal publishing articles on computational methods in communication research, published by Amsterdam University Press and founded by the ICA Computational Methods Division.

Please see the [author guide](author_guide_qmd.md) for detailed instructions on how to prepare a manuscript for publication.

## Using the template

```sh
quarto use template ccr-journal/ccr-quarto
```

Quarto will prompt you for a directory name. Once created, you can render the template immediately:

```sh
cd my-article
quarto render template.qmd
```

This produces a PDF using the CCR class. An experimental HTML output is also available:

```sh
quarto render template.qmd --to ccr-html
```

## Writing your article

Edit `template.qmd` (or rename it). The YAML front matter defines your title, authors, affiliations, abstract, keywords, and bibliography. The body is standard Quarto markdown with support for executable R and Python code chunks.

### Anonymised peer review

CCR requires [anonymised manuscripts for peer review](https://journal.computationalcommunication.org/about/submissions). To produce an anonymised build — with author/affiliation info suppressed, line numbers enabled, and a draft watermark — add the `review` class option to your document YAML:

```yaml
format:
  ccr-pdf:
    classoption:
      - review
```

Remove the option when preparing the final camera-ready version.

## PDF engine

This template defaults to `pdflatex`. If you need better support for Unicode characters (e.g. CJK scripts, Arabic, Hebrew), switch to `xelatex`:

```yaml
format:
  ccr-pdf:
    pdf-engine: xelatex
```

## LaTeX authors

A parallel LaTeX template lives at [ccr-journal/ccr-latex](https://github.com/ccr-journal/ccr-latex) and uses the same `ccr.cls`. The two templates render identical title blocks; use whichever fits your workflow.

`ccr.cls` itself is maintained in the LaTeX repository. A GitHub Actions workflow in this repo automatically mirrors changes by opening a pull request whenever the class is updated upstream, keeping the two templates in sync.

## Reporting issues

File template bugs and suggestions at [github.com/ccr-journal/ccr-quarto/issues](https://github.com/ccr-journal/ccr-quarto/issues), or contact the editorial team at <ccreditorialteam@gmail.com>.

## License

[MIT License](./LICENSE)

Articles typeset with this template are released under CC BY 4.0 upon publication in CCR, independent of the template's own license terms.
