(TeX-add-style-hook "Progress-Report-1"
 (lambda ()
    (LaTeX-add-labels
     "sec:progress"
     "sec:plan")
    (TeX-run-style-hooks
     "hyperref"
     "graphicx"
     "algorithmic"
     "algorithm"
     "amssymb"
     "amsmath"
     "latex2e"
     "art10"
     "article"
     "")))

