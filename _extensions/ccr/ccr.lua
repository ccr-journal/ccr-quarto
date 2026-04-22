-- Insert \acknowledgements{...} right before the References heading when
-- rendering to LaTeX. The ccrtemplate.tex $before-bib.tex()$ slot fires
-- after $body$, which lands *after* citeproc-rendered references; moving
-- the emit into a Lua filter lets us anchor it correctly regardless of
-- citeproc vs biblatex. JATS output is handled separately (Python
-- post-processing injects <back><ack>), so this filter is a no-op for
-- non-LaTeX targets.

local function render_meta_as_latex(meta_value)
  local doc
  local t = meta_value.t or pandoc.utils.type(meta_value)
  if t == "MetaBlocks" or t == "Blocks" then
    doc = pandoc.Pandoc(meta_value)
  elseif t == "MetaInlines" or t == "Inlines" then
    doc = pandoc.Pandoc({ pandoc.Plain(meta_value) })
  else
    doc = pandoc.Pandoc({
      pandoc.Plain({ pandoc.Str(pandoc.utils.stringify(meta_value)) })
    })
  end
  return pandoc.write(doc, "latex")
end

local function is_references_header(block)
  if block.t ~= "Header" then return false end
  local text = pandoc.utils.stringify(block):lower()
  return text:match("^references$") or text:match("^bibliography$")
end

function Pandoc(doc)
  if FORMAT ~= "latex" then return nil end
  local ack = doc.meta.acknowledgements
  if not ack then return nil end

  local ack_tex = render_meta_as_latex(ack)
  if not ack_tex or ack_tex == "" then return nil end

  local raw = pandoc.RawBlock("latex",
    "\\acknowledgements{" .. ack_tex .. "}")

  for i, block in ipairs(doc.blocks) do
    if is_references_header(block) then
      table.insert(doc.blocks, i, raw)
      return doc
    end
  end

  -- Fallback: no References heading in the body — append at the end so at
  -- least the section is present (matches the old before-bib.tex behaviour).
  table.insert(doc.blocks, raw)
  return doc
end
