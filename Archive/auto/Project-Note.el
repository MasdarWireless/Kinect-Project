(TeX-add-style-hook "Project-Note"
 (lambda ()
    (LaTeX-add-labels
     "sec:introduction"
     "sec:normal-distribution"
     "sec:definition"
     "eq:1"
     "sec:background"
     "eq:2"
     "sec:parameters"
     "eq:3"
     "eq:4"
     "sec:multi-variate-model"
     "sec:definition-1"
     "eq:5"
     "sec:background-1"
     "sec:examples")
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

