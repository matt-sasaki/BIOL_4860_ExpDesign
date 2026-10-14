-- Typst-friendly tweaks for pages that are rendered to both HTML and PDF
-- (syllabus.qmd and schedule.qmd). Active only for Typst output.
--
--  * Callouts: Quarto's Typst callouts download a Font Awesome package at
--    render time, which fails offline. Convert them to a plain block quote
--    with a bold title instead.
--  * Links to other .qmd pages: these only make sense on the website, so keep
--    the link text and drop the link.

if FORMAT ~= "typst" then
  return {}
end

local function callout_title(div)
  for _, cls in ipairs(div.classes) do
    if cls == "callout-important" then return "Important" end
    if cls == "callout-warning" then return "Warning" end
    if cls == "callout-tip" then return "Tip" end
    if cls == "callout-caution" then return "Caution" end
  end
  return nil
end

local function is_callout(div)
  for _, cls in ipairs(div.classes) do
    if cls:match("^callout") then return true end
  end
  return false
end

function Div(div)
  if not is_callout(div) then return nil end
  local blocks = pandoc.List(div.content)
  local title = nil
  -- an explicit "## Title" heading as first block becomes the title
  if #blocks > 0 and blocks[1].t == "Header" then
    title = pandoc.utils.stringify(blocks[1].content)
    blocks:remove(1)
  elseif div.attributes["title"] then
    title = div.attributes["title"]
  else
    title = callout_title(div)
  end
  local out = pandoc.List()
  if title then
    out:insert(pandoc.Para({ pandoc.Strong(pandoc.Str(title)) }))
  end
  out:extend(blocks)
  return pandoc.BlockQuote(out)
end

function Link(link)
  if link.target:match("%.qmd") then
    return link.content
  end
  return nil
end
