# Pre-render script (see _quarto.yml: project.pre-render).
#
# Copies every assignment/Data Safari/project .qmd file into templates/,
# verbatim, so students have a plain static file to download that Quarto's
# render pipeline never treats as a document to render. The files in
# assignments/ *are* rendered (to PDF, via format: typst) as part of the
# normal site build; the copies in templates/ are excluded from rendering
# (see the "!templates/*.qmd" entry in _quarto.yml's render list) and exist
# solely as downloadable source files.
#
# Do not edit files in templates/ directly -- they are overwritten on every
# render. Edit the originals in assignments/ instead.

source_files <- list.files("assignments", pattern = "\\.qmd$", full.names = TRUE)

dir.create("templates", showWarnings = FALSE)

# Clear out any stale templates from files that were renamed/removed
old_templates <- list.files("templates", pattern = "\\.qmd$", full.names = TRUE)
file.remove(old_templates)

file.copy(source_files, file.path("templates", basename(source_files)), overwrite = TRUE)

cat(sprintf("build-templates.R: copied %d assignment file(s) into templates/\n", length(source_files)))
