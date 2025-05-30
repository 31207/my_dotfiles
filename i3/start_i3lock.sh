#!/bin/bash


BLANK='#00000000'
CLEAR='#ffffff22'
DEFAULT='#ff00ffcc'
TEXT='#fdfffd'
WRONG='#995C38'
VERIFYING='#8F7359'

i3lock  -L \
--insidever-color=$CLEAR     \
--ringver-color=$VERIFYING   \
\
--insidewrong-color=$CLEAR   \
--ringwrong-color=$WRONG     \
\
--inside-color=$BLANK        \
--ring-color=$BLANK        \
--line-color=$BLANK          \
--separator-color=$BLANK   \
\
--verif-color=$TEXT          \
--wrong-color=$TEXT          \
--time-color=$TEXT           \
--date-color=$TEXT           \
--layout-color=$TEXT         \
--keyhl-color=$WRONG         \
--bshl-color=$WRONG          \
--radius=90              \
--ring-width=10              \
--screen 1                   \
--blur 6                     \
--clock                      \
--indicator                  \
--time-str="%H:%M:%S"        \
--date-str="%A, %Y-%m-%d"       \
--keylayout 1                \
--time-pos="60:80" \
--layout-pos="60:138" \
--{time,date}-font="SF Pro Display"			\
--{time,date,layout,verif,wrong,greeter}-size=24			\
--layout-size=18			\
--{time,date,layout,verif,wrong,greeter}-align=1			\
--{verif,wrong}-align=0			\