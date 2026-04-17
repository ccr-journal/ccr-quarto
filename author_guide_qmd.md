# Author Guide: Writing Quarto for CCR XML Conversion

This guide describes how to write Quarto (`.qmd`) documents that convert cleanly to JATS XML for CCR (Computational Communication Research). The conversion uses `quarto render --to jats` followed by a post-processing pipeline. Most standard Quarto/Pandoc markdown works fine; this guide covers areas where authors commonly run into problems.

## Quick start

Your article folder should contain at minimum:

```
article.qmd        # full article: YAML front matter + body text
bibliography.bib   # BibTeX references
```

The YAML front matter must include:

```yaml
---
title: "Your Article Title"
author:
- name: First Author
  affiliation: Department, University, Country
- name: Second Author
  affiliation: Department, University, Country
abstract: |
  Your abstract text here.
keywords: keyword1, keyword2, keyword3
volume: 8
pubnumber: 2
pubyear: 2026
firstpage: 1
bibliography: bibliography.bib
doi: 10.5117/CCR2026.2.11.AUTHOR
execute:
  echo: false
---
```

The converter derives the output filename and article metadata from the `doi` field. The `volume`, `pubnumber`, `pubyear`, and `firstpage` fields are provided by the journal.

---

## YAML front matter

### Required fields

| Field | Description | Example |
|---|---|---|
| `title` | Article title | `"Gender Representation in LLMs"` |
| `author` | List of authors with `name` and `affiliation` | see below |
| `abstract` | Abstract text (use `\|` for multi-line) | |
| `keywords` | Comma-separated keyword list | `Bias, Gender, LLM` |
| `doi` | Full DOI (provided by the journal) | `10.5117/CCR2026.2.11.AUTHOR` |
| `volume` | Volume number | `8` |
| `pubnumber` | Issue number | `2` |
| `pubyear` | Publication year | `2026` |
| `firstpage` | First page number | `1` |
| `bibliography` | Path to `.bib` file | `bibliography.bib` |
| `format` | Optional; the pipeline forces `jats_publishing` | |

### Authors and affiliations

Each author needs a `name` and `affiliation` (or `affiliations` for multiple):

```yaml
author:
- name: Jane Doe
  affiliation: Department of Communication, University of Example, Country
- name: John Smith
  affiliations:
    - name: First Department, University A, Country
    - name: Second Department, University B, Country
```

### Corresponding author

Mark the corresponding author using an inline footnote on the author name:

```yaml
- name: Jane Doe^[**Corresponding author**. University of Example, Country, jane@example.edu.]
  affiliation: Department of Communication, University of Example, Country
```

---

## Citations and references

Quarto uses Pandoc citation syntax. Use these forms:

| Syntax | Output | Use for |
|---|---|---|
| `@smith2020` | Smith (2020) | Subject of sentence: "Smith (2020) found..." |
| `[@smith2020]` | (Smith, 2020) | Parenthetical: "...has been shown (Smith, 2020)" |
| `[@smith2020, p. 12]` | (Smith, 2020, p. 12) | With page number |
| `[see @smith2020]` | (see Smith, 2020) | With prefix |
| `[-@smith2020]` | (2020) | Year only (suppress author name) |

**Multiple citations:** Separate with semicolons inside brackets -- `[@smith2020; @jones2021]`.

**Bibliography:** Include `bibliography: bibliography.bib` in the YAML front matter. Place `# References` followed by a `::: {#refs} :::` div where you want the reference list to appear:

```markdown
# References

::: {#refs}
:::
```

---

## Figures

### Static figures (images)

Reference image files directly using Pandoc figure syntax:

```markdown
![Caption text.](figures/my_figure.svg){#fig-label}
```

Cross-reference with `@fig-label` in the text.

**Rules:**
- Always include the file extension.
- SVG is the preferred format. PNG and JPG are also supported.
- PDF figures are automatically converted to SVG during post-processing (requires inkscape).
- Use descriptive cross-reference IDs starting with `fig-` (e.g., `#fig-results`).
- Do not add "Figure N:" to the caption text manually -- Quarto generates labels automatically.

### Figures in subdirectories

Include the relative path with extension:

```markdown
![Caption text.](figures/subfolder/fig1.svg){#fig-1}
```

### Figures from R/Python code chunks

If you generate figures from code, make sure the chunk has a label starting with `fig-` and a `fig-cap`:

````markdown
```{r}
#| label: fig-results
#| fig-cap: "Distribution of results."
plot(x, y)
```
````

Set `execute: echo: false` in the YAML front matter so code is not shown in the output (unless showing code is the point of the article).

---

## Tables

### Markdown tables

Simple tables can be written directly in markdown:

```markdown
| Column A | Column B | Column C |
|----------|----------|----------|
| 1        | 2        | 3        |

: Caption text. {#tbl-label}
```

Cross-reference with `@tbl-label`.

**Column widths:** Pandoc infers column widths from the number of dashes in the separator line. If one column has more dashes than the others, it will be rendered wider.
Use equal dash counts to let columns auto-size based on content.

### Tables from R code chunks

Use `knitr::kable()` to produce tables from R data:

````markdown
```{r}
#| label: tbl-results
#| tbl-cap: "Summary statistics."
my_data |>
  knitr::kable(format = "markdown")
```
````

**Important: avoid `kable_styling()`.** The `kable_styling()` function from kableExtra produces HTML output that is **incompatible with JATS output**. Using it will cause the error:

> Error: Functions that produce HTML output found in document targeting jats_publishing output.

If you need `kable_styling()` for a LaTeX/PDF version, gate it behind a format check:

````r
if (knitr::is_latex_output()) {
  # LaTeX-specific styling here
  my_table |>
    kable(format = "latex", booktabs = TRUE) |>
    kable_styling(full_width = TRUE)
} else {
  # Plain markdown for JATS and other formats
  my_table |>
    kable(format = "markdown")
}
````

**Safe kableExtra functions** (these work with JATS output):
- `add_footnote()`
- `column_spec()`
- `add_header_above()`

**Functions to avoid** (they produce HTML):
- `kable_styling()`
- `scroll_box()`
- `save_kable()`

### Table notes

Add table notes as plain text below the table, or use `add_footnote()` on a markdown-format kable:

````r
my_data |>
  kable(format = "markdown") |>
  add_footnote("Note. Standard errors in parentheses.", notation = "none")
````

---

## Math

Standard LaTeX math works in Quarto. Use `$...$` for inline math and `$$...$$` for display math:

```markdown
The coefficient $\beta_1$ was significant at $p < .05$.

$$
Y = \beta_0 + \beta_1 X + \epsilon
$$
```

Quarto produces MathML with a LaTeX fallback in the JATS output, which is the preferred format.

---

## Code listings

Use fenced code blocks with a language identifier:

````markdown
```r
x <- c(1, 2, 3)
mean(x)
```
````

For executable code chunks that should display their code in the article, use `echo: true` on that specific chunk:

````markdown
```{r}
#| echo: true
#| label: lst-example
x <- c(1, 2, 3)
mean(x)
```
````

For articles that are not about code, set `execute: echo: false` in the YAML front matter to suppress all code display.

---

## Footnotes

Use Pandoc inline footnotes or reference footnotes:

```markdown
This is a claim.^[This is the footnote text.]

This is another claim.[^fn1]

[^fn1]: This is a reference-style footnote.
```

Footnotes are collected into the back matter of the JATS output.

---

## Appendices

Mark appendix sections with the `.appendix` class:

```markdown
::: {#appendix}
# Appendix {.appendix}

## Additional tables {.appendix}

Content here...
:::
```

The converter moves appendix content into the JATS `<back><app-group>` structure.

---

## Cross-references

Use Quarto's cross-reference syntax:

| Target | Label prefix | Reference syntax | Example output |
|---|---|---|---|
| Figure | `#fig-` | `@fig-label` | Figure 1 |
| Table | `#tbl-` | `@tbl-label` | Table 1 |
| Section | `#sec-` | `@sec-label` | Section 1 |
| Equation | `#eq-` | `@eq-label` | Equation 1 |

---

## Things to avoid

### R/Python packages that produce HTML

Any R or Python function that generates HTML output will cause an error with `jats_publishing`. Common culprits:

- **kableExtra**: `kable_styling()` (see Tables section)
- **gt**: the `gt()` function produces HTML tables
- **DT**: `datatable()` produces interactive HTML widgets
- **reactable**: produces HTML widgets
- **htmltools**: any direct HTML generation
- **plotly**: interactive HTML plots (use static plots instead)
- **leaflet**, **htmlwidgets**: all interactive widget libraries

If you need these for an HTML version, gate them behind format checks or use conditional chunk evaluation:

````markdown
```{r}
#| eval: !expr knitr::is_html_output()
# HTML-only code here
```
````

### LaTeX-specific commands in markdown

Quarto supports some LaTeX commands in markdown (e.g., `\textit{}`, `\footnotesize`), but they will not convert to JATS. Use Pandoc markdown equivalents:

| Instead of | Use |
|---|---|
| `\textit{text}` | `*text*` |
| `\textbf{text}` | `**text**` |
| `\footnotesize`, `\normalsize` | (omit -- font size is irrelevant in XML) |
| `\newpage` | (omit -- page breaks are irrelevant in XML) |
| `\checkmark` | Use `$\checkmark$` (in math mode) |

### Raw LaTeX blocks

Avoid raw LaTeX blocks (```` ```{=latex} ... ``` ````) as they are silently dropped in JATS output. If you need format-specific content, use conditional blocks:

````markdown
::: {.content-visible when-format="jats"}
JATS-specific content here.
:::
````

---

## Checklist before submission

- [ ] YAML front matter includes all required fields (`doi`, `volume`, `pubnumber`, `pubyear`, `firstpage`)
- [ ] No `format:` key that would conflict (the pipeline forces `jats_publishing`)
- [ ] `execute: echo: false` is set (unless code display is intentional)
- [ ] No `kable_styling()` or other HTML-producing kableExtra functions outside of format guards
- [ ] No `gt()`, `DT::datatable()`, or other HTML widget packages outside of format guards
- [ ] All `kable()` calls use `format = "markdown"` (not `"html"`)
- [ ] All figures have a `#fig-` label and a caption
- [ ] All tables have a `#tbl-` label and a caption
- [ ] All image paths include the file extension
- [ ] No raw LaTeX blocks that contain essential content
- [ ] `bibliography.bib` is referenced in front matter and the file exists
- [ ] Test the conversion with `quarto render manuscript_file.qmd --to jats_publishing` before submission
