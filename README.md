# colorize for Erlang [![Build Status][travis_ci_image]][travis_ci]

Everything you need to colorize your output.
**Requires Erlang R16 up.**

## Usage

``` erlang
io:format("~s~n", [colorize:red("bloody red text")]).
```

``` erlang
-include_lib("colorize/include/colorize.hrl").
io:format("~s~n", [?RED("another red text")]).
```

``` erlang
io:format(colorize:green("~s~n"), ["something green"]).
```

[travis_ci]:
https://travis-ci.org/rpt/colorize
[travis_ci_image]:
https://travis-ci.org/rpt/colorize.png
