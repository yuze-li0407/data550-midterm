install:
	Rscript -e "renv::restore()"

build:
	Rscript -e "rmarkdown::render('report.Rmd', output_file = 'report.html')"