# Logs parser

## Task:

Logs parser (collect `MOST PAGE VIEWS` and `MOST UNIQ PAGE VIEWS` metrics)

## Additional work:

Added `Invalid Logs` section
Added `Uniq visitors addresses` section

## Run:

Execute:

```bash
bundler
chmod +x ./parser
bundle exec ./parser ./webserver.log
```

Note: provided sample file doesn't contain any valid IP address, so to provide expected output, IP addres validation is disabled (see [this file](./lib/entries/line.rb#L37))

Execute tests (test will be executed successfully only if we uncoment IP validation lib):

```bash
rspec
```

Test Coverage - 100%

## Approach description:

Dependency schema:
![dependency schema](https://i.imgur.com/FUSIHmZ.png)

```bash
.
├── adapters
│   └── file_adapter.rb
├── entries
│   ├── line.rb
│   └── statistic.rb
├── parser.rb
└── presenters
    ├── console_presenter.rb
    └── printer.rb
```

- `Adapters` - the goal of adapter is to provide data sources abstraction (so in future we will not be restricted to only `File` source, and we also will have possibility to scale horizontally with different adapters (e.g. DB, HTTP, etc))
- `Entries` - entries encapsulates behavior related to data source (validation, rules of calculation and exposing data in unified format to outer world)
- `Presenters` - here we have logic related to presentation (so if we will want to scale with presentation approaches (JSON output, XML output, DB, etc...)) this logic will probably should be placed here

## Possible Improvements (ideas)

- Move validations in separate namespace (for now validations are implemented in business logic)
- Implement less coupled `Entries` (now `Statistic` is highly depends on `Line`)
