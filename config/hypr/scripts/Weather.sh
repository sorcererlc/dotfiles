#!/bin/bash

city=
cachedir=~/.cache/rbn
cachefile=${0##*/}-$1

APIKEY=9fb017f5c5e29a8acbc773ffd3a817dd
LAT=44.426765
LON=26.102537
EXCLUDE=minutely,daily,hourly
UNITS=metric
LANG=en

URL="https://api.openweathermap.org/data/3.0/onecall?lat=$LAT&lon=$LON&exclude=$EXCLUDE&appid=$APIKEY&units=$UNITS&lang=$LANG"

if [ ! -d $cachedir ]; then
    mkdir -p $cachedir
fi

if [ ! -f $cachedir/$cachefile ]; then
    touch $cachedir/$cachefile
fi

# Save current IFS
SAVEIFS=$IFS
# Change IFS to new line.
IFS=$'\n'

cacheage=$(($(date +%s) - $(stat -c '%Y' "$cachedir/$cachefile")))
if [ $cacheage -gt 1740 ] || [ ! -s $cachedir/$cachefile ]; then
    data=($(curl -s $URL 2>&1))
    echo $data > $cachedir/$cachefile
fi

weather=($(cat $cachedir/$cachefile))

# Restore IFSClear
IFS=$SAVEIFS

location=$(echo $weather | jq '.timezone' | sed -r 's/["]+//g' | sed -r 's/.*\///g')
temperature=$(echo $weather | jq '.current.temp')
realfeel=$(echo $weather | jq '.current.feels_like')
cond=$(echo $weather | jq '.current.weather[0].main' | sed -r 's/["]+//g')
cond_id=$(echo $weather | jq '.current.weather[0].id')
cond_icon=$(echo $weather | jq '.current.weather[0].icon' | sed -r 's/["]+//g')

# https://fontawesome.com/icons?s=solid&c=weather
case $(echo $cond_id) in
800)
    icon=""
    ;;
801 | 802)
    icon="󰖕"
    ;;
803)
    icon=""
    ;;
804)
    icon=""
    ;;
701 | 711 | 721 | 731 | 741 | 751 | 761 | 762 | 771 | 781)
    icon=""
    ;;
500 | 501)
    icon="󰼳"
    ;;
502 | 503 | 504 | 520 | 521 | 522 | 531)
    icon=""
    ;;
"patchy snow possible" | "patchy sleet possible" | "patchy freezing drizzle possible" | "freezing drizzle" | "heavy freezing drizzle" | "light freezing rain" | "moderate or heavy freezing rain" | "light sleet" | "ice pellets" | "light sleet showers" | "moderate or heavy sleet showers")
    icon="󰼴"
    ;;
511 | 600 | 601 | 602 | 611 | 612 | 613 | 615 | 616 | 620 | 621 | 622)
    icon="󰙿"
    ;;
"blizzard" | "patchy moderate snow" | "moderate snow" | "patchy heavy snow" | "heavy snow" | "moderate or heavy snow with thunder" | "moderate or heavy snow showers")
    icon=""
    ;;
200 | 201 | 202 | 210 | 211 | 212 | 221 | 230 | 231 | 232)
    icon=""
    ;;
*)
    icon=""
    ;;
esac

text="$temperature($realfeel) $icon"
alt="$location"
tooltip="$location: $temperature($realfeel), $cond $icon"

echo -e "{\"text\":\""$text"\", \"alt\":\""$alt"\", \"tooltip\":\""$tooltip"\"}"

cached_weather=" $temperature  \n$icon ${weather[1]}"

echo -e $cached_weather >  ~/.cache/.weather_cache