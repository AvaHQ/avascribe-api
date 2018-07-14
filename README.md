# avascribe-api documentation

Please open issue / PR for any issue / question related to this API.
Commits on this repo willbe automatically repercuted on the online doc.

## locally

```bash
    git clone git@github.com:avahq/avascribe-api
    cd avascribe-api

    docker build -t avascribe-api
    docker run -v `pwd`:/doc avascribe-api make html

    /path/to/your/browser build/html/index.html
```

### dependencies
- docker
