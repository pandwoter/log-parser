# Logs parser 
Tests execution status: [![Ruby Actions Status](https://github.com/pandwoter/log-parser/workflows/Ruby/badge.svg)](https://github.com/{userName}/{repoName}/actions)

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

Note: provided sample file doesn't contain any valid IP address, so to provide expected output, IP addres validation schould be disabled (see [this file](./lib/entries/line.rb#L37))

```bash
bundle exec rspec
```

Test Coverage - 100%

## Script output

```bash
======MOST PAGE VIEWS======
0) /about/2 -- 89 visits
1) /contact -- 89 visits
2) /index -- 82 visits
3) /about -- 81 visits
4) /help_page/1 -- 79 visits
5) /home -- 78 visits
===============================
======MOST UNIQ PAGE VIEWS======
0) /index -- 23 visits
1) /home -- 23 visits
2) /contact -- 23 visits
3) /help_page/1 -- 23 visits
4) /about/2 -- 22 visits
5) /about -- 21 visits
===============================
======UNIQ VISITORS ADDRS======
0) /about/2 -- ["444.701.448.104", "184.123.665.067", "382.335.626.855", "543.910.244.929", "555.576.836.194", "802.683.925.780", "200.017.277.774", "126.318.035.038", "451.106.204.921", "235.313.352.950", "836.973.694.403", "217.511.476.080", "316.433.849.805", "061.945.150.735", "715.156.286.412", "646.865.545.408", "016.464.657.359", "897.280.786.156", "682.704.613.213", "722.247.931.582", "158.577.775.616", "336.284.013.698"] visits
(Actuall output in this section is shorten...)
===============================
======INVALID LOGS======
0) {:addr=>nil, :path=>"/help_page/1", :errors=>["Line format isn't valid!"]}
1) {:addr=>nil, :path=>"836.973.694.403", :errors=>["Line format isn't valid!"]}
(Broke some examples in log file for demonstration purpose)
===============================
```

## Approach description:

Dependency schema:
![dependency schema](https://i.imgur.com/vbgGjGl.png)

```bash
.
├── adapters
│   └── file_adapter.rb
├── entries
│   ├── line.rb
│   └── statistic.rb
├── parser.rb
└── printers
    ├── artifacts_printer.rb
    ├── base_printer.rb
    └── visits_printer.rb
```

- `Adapters` - the goal of adapter is to provide data sources abstraction (so in future we will not be restricted to only `File` source, and we also will have possibility to scale horizontally with different adapters (e.g. DB, HTTP, etc))
- `Entries` - entries encapsulates behavior related to data source (validation, rules of calculation and exposing data in unified format to outer world)
- `Printers` - their job are actually print, format and processing related logic (sorting, ...)

All dependency injections are placed in the constructors to have possibility to test modules independently with mock's.

## Possible Improvements (ideas)

- Move validations in separate namespace (for now validations are implemented in business logic)
- Implement less coupled `Entries` (now `Statistic` is highly depends on `Line`)
