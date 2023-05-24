# avascribe-api documentation

These are the various type definitions of the Ava API.
Currently, this mostly concerns communications between the Ava client and the Ava server.
However, in principle (and in the future), this could also include communications between e.g. API and room server.
And indeed, there are already some schemas for pyworker works and results.

**Note to backend developers:**
If you want to make modifications to this in the course of backend development,
you probably don't want to work directly in this repository.
Instead, you probably want to work in the `node/schemas/avascribe-api` directory of the [backend repository](https://github.com/AvaHQ/backend).
This repository is included as a git submodule in the backend repository.
Changes you make here can thus directly be made available to the backend repository, allowing for faster iteration.

## Usage

The schemas are written in [JSON Schema](https://json-schema.org/).

To build them in the same way that our CI uses them, run...

```terminal
yarn install --frozen-lockfile
yarn generate-types
```

## Documentation

To see the documentation of the schemas, run...

```terminal
yarn install --frozen-lockfile
yarn open-docs
```

This should open a browser window with the documentation.
If this doesn't work, you can also open the `build/docs/index.html` file manually.
**Note:** the documentation will not hot-reload, so you'll have to run `yarn generate-docs` again if you make changes to the schemas.
