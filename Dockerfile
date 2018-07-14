FROM python:3

RUN pip install sphinx
RUN pip install recommonmark
RUN pip install sphinx_rtd_theme
RUN pip install sphinxcontrib-versioning

WORKDIR /doc

