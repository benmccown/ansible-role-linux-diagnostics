# linux-troubleshooting

**Please see linux-troubleshooting.md for details on reading the output of these shell commands.**

## Links

- [Source - The Netflix Tech Blog](https://medium.com/netflix-techblog/linux-performance-analysis-in-60-000-milliseconds-accc10403c55)

## Running Tests with Test Kitchen

The diagnostics run as part of the kitchen's default.yml so all you need to do is converge to see them run.

```sh
// Bring Up the Cluster and Run Diagnostics
bundle exec kitchen list
bundle exec kitchen converge

// All finished
bundle exec kitchen destroy
```
