%% @doc Everything you need to colorize your output.
-module(colorize).

%% Info API
-export([available_colors/0,
         available_modes/0]).

%% Colorize API
-export([colorize/3,
         colorize/4]).
-export([black/1,
         red/1,
         green/1,
         yellow/1,
         blue/1,
         magenta/1,
         cyan/1,
         white/1]).
-export([bright_black/1,
         bright_red/1,
         bright_green/1,
         bright_yellow/1,
         bright_blue/1,
         bright_magenta/1,
         bright_cyan/1,
         bright_white/1]).

%% Types
-type color() :: black
               | red
               | green
               | yellow
               | blue
               | magenta
               | cyan
               | white
               | default.

-type mode() :: bright
              | underline.

-type text() :: string() | bitstring() | iodata().

-export_types([color/0,
               mode/0]).

%%------------------------------------------------------------------------------
%% API: Info functions
%%------------------------------------------------------------------------------

%% @doc Returns a list of all available colors.
-spec available_colors() -> [color()].
available_colors() ->
    [black, red, green, yellow, blue, magenta, cyan, white, default].

%% @doc Returns a list of all available modes.
-spec available_modes() -> [mode()].
available_modes() ->
    [bright, underscore].

%%------------------------------------------------------------------------------
%% API: Colorize function
%%------------------------------------------------------------------------------

%% @doc Makes given text colorful and good-looking.
-spec colorize(text(), color(), color(), [mode()]) -> bitstring().
colorize(Text, default, default, []) ->
    iolist_to_binary([Text]);
colorize(Text, FGColor, BGColor, Modes) ->
    Esc = esc(FGColor, BGColor, Modes),
    iolist_to_binary([Esc, Text, <<"\x1b[0m">>]).

%% @doc Makes given text colorful and good-looking.
%% Helper function if you only want a background color xor some modes.
-spec colorize(text(), color(), color() | [mode()]) -> bitstring().
colorize(Text, Color, []) ->
    colorize(Text, Color, default, []);
colorize(Text, Color, [_ | _] = Modes) ->
    colorize(Text, Color, default, Modes);
colorize(Text, FGColor, BGColor) ->
    colorize(Text, FGColor, BGColor, []).

%%------------------------------------------------------------------------------
%% API: Colorful helper functions
%%------------------------------------------------------------------------------

black(Text)          -> colorize(Text, black, default, []).
red(Text)            -> colorize(Text, red, default, []).
green(Text)          -> colorize(Text, green, default, []).
yellow(Text)         -> colorize(Text, yellow, default, []).
blue(Text)           -> colorize(Text, blue, default, []).
magenta(Text)        -> colorize(Text, magenta, default, []).
cyan(Text)           -> colorize(Text, cyan, default, []).
white(Text)          -> colorize(Text, white, default, []).
bright_black(Text)   -> colorize(Text, black, default, [bright]).
bright_red(Text)     -> colorize(Text, red, default, [bright]).
bright_green(Text)   -> colorize(Text, green, default, [bright]).
bright_yellow(Text)  -> colorize(Text, yellow, default, [bright]).
bright_blue(Text)    -> colorize(Text, blue, default, [bright]).
bright_magenta(Text) -> colorize(Text, magenta, default, [bright]).
bright_cyan(Text)    -> colorize(Text, cyan, default, [bright]).
bright_white(Text)   -> colorize(Text, white, default, [bright]).

%%------------------------------------------------------------------------------
%% Internal functions
%%------------------------------------------------------------------------------

-spec esc(color(), color(), [mode()]) -> iolist().
esc(default, default, Modes) ->
    encode(Modes);
esc(Color, default, Modes) ->
    encode([{fg_color, Color} | Modes]);
esc(default, Color, Modes) ->
    encode([{bg_color, Color} | Modes]);
esc(FGColor, BGColor, Modes) ->
    encode([{fg_color, FGColor}, {bg_color, BGColor} | Modes]).

-spec encode([{fg_color | bg_color, color()} | mode()]) -> iolist().
encode([X | Xs]) ->
    [<<"\x1b[">>, encode(Xs, [code(X)]), <<"m">>].

-spec encode([{fg_color | bg_color, color()} | mode()], iolist()) -> iolist().
encode([], Codes) ->
    lists:reverse(Codes);
encode([X | Xs], Codes) ->
    encode(Xs, [code(X), ";" | Codes]).

-spec code({fg_color | bg_color, color()} | mode()) -> bitstring().
code({fg_color, Color}) -> fg_color(Color);
code({bg_color, Color}) -> bg_color(Color);
code(Mode) -> mode(Mode).

-spec fg_color(color()) -> bitstring().
fg_color(black) -> <<"30">>;
fg_color(red) -> <<"31">>;
fg_color(green) -> <<"32">>;
fg_color(yellow) -> <<"33">>;
fg_color(blue) -> <<"34">>;
fg_color(magenta) -> <<"35">>;
fg_color(cyan) -> <<"36">>;
fg_color(white) -> <<"37">>.

-spec bg_color(color()) -> bitstring().
bg_color(black) -> <<"40">>;
bg_color(red) -> <<"41">>;
bg_color(green) -> <<"42">>;
bg_color(yellow) -> <<"43">>;
bg_color(blue) -> <<"44">>;
bg_color(magenta) -> <<"45">>;
bg_color(cyan) -> <<"46">>;
bg_color(white) -> <<"47">>.

-spec mode(mode()) -> bitstring().
mode(bright) -> <<"1">>;
mode(underline) -> <<"4">>.
