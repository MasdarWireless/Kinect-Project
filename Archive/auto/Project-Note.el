(TeX-add-style-hook "Project-Note"
 (lambda ()
    (LaTeX-add-labels
     "sec:introduction"
     "sec:multi-variate-model")
    (TeX-run-style-hooks
     "hyperref"
     "url"
     "listings"
     "graphicx"
     "algorithmic"
     "algorithm"
     "amssymb"
     "amsmath"
     "latex2e"
     "art10"
     "article"
     "")))

