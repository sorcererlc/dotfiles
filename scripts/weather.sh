#!/usr/bin/env bash

source ~/.secrets

CACHE_DIR=~/.cache/rbn
CACHE_FILE="$CACHE_DIR/${0##*/}-$1"

APIKEY=$OWM_KEY # Exported as env var from a secrets file
LAT=$LOCATION_LAT
LON=$LOCATION_LON
EXCLUDE=minutely,daily,hourly
UNITS=metric
LANG=en

URL="https://api.openweathermap.org/data/3.0/onecall?lat=$LAT&lon=$LON&exclude=$EXCLUDE&appid=$APIKEY&units=$UNITS&lang=$LANG"

if [ ! -d $CACHE_DIR ]; then
    mkdir -p $CACHE_DIR
fi

if [ ! -f $CACHE_FILE ]; then
    touch $CACHE_FILE
fi

COD=$(cat $CACHE_FILE | jq '.cod')
if [ $COD == 401 ]; then
    rm $CACHE_FILE
    touch $CACHE_FILE
fi

CACHE_AGE=$(($(date +%s) - $(stat -c '%Y' "$CACHE_FILE")))
if [ $CACHE_AGE -gt 1740 ] || [ ! -s $CACHE_FILE ]; then
    curl -s $URL -o $CACHE_FILE 2>&1
fi

LOCATION=$(cat $CACHE_FILE | jq '.timezone' | sed -r 's/["]+//g' | sed -r 's/.*\///g')
TEMPERATURE=$(cat $CACHE_FILE | jq '.current.temp')
REAL_FEEL=$(cat $CACHE_FILE | jq '.current.feels_like')
COND=$(cat $CACHE_FILE | jq '.current.weather[0].main' | sed -r 's/["]+//g')
CONDITION_ID=$(cat $CACHE_FILE | jq '.current.weather[0].id')
CONDITION_ICON=$(cat $CACHE_FILE | jq '.current.weather[0].icon' | sed -r 's/["]+//g')

# https://fontawesome.com/icons?s=solid&c=weather
case $(echo $CONDITION_ID) in
800)
    ICON=""
    ;;
801 | 802)
    ICON="󰖕"
    ;;
803)
    ICON=""
    ;;
804)
    ICON=""
    ;;
701 | 711 | 721 | 731 | 741 | 751 | 761 | 762 | 771 | 781)
    ICON=""
    ;;
500 | 501)
    ICON="󰼳"
    ;;
502 | 503 | 504 | 520 | 521 | 522 | 531)
    ICON=""
    ;;
"patchy snow possible" | "patchy sleet possible" | "patchy freezing drizzle possible" | "freezing drizzle" | "heavy freezing drizzle" | "light freezing rain" | "moderate or heavy freezing rain" | "light sleet" | "ice pellets" | "light sleet showers" | "moderate or heavy sleet showers")
    ICON="󰼴"
    ;;
511 | 600 | 601 | 602 | 611 | 612 | 613 | 615 | 616 | 620 | 621 | 622)
    ICON="󰙿"
    ;;
"blizzard" | "patchy moderate snow" | "moderate snow" | "patchy heavy snow" | "heavy snow" | "moderate or heavy snow with thunder" | "moderate or heavy snow showers")
    ICON=""
    ;;
200 | 201 | 202 | 210 | 211 | 212 | 221 | 230 | 231 | 232)
    ICON=""
    ;;
*)
    ICON=""
    ;;
esac

TEXT="$TEMPERATURE ($REAL_FEEL) $ICON"
ALT=$LOCATION
TOOLTIP="$LOCATION $TEMPERATURE ($REAL_FEEL), $CONDITION $ICON"

echo -e "{\"text\":\""$TEXT"\", \"alt\":\""$ALT"\", \"tooltip\":\""$TOOLTIP"\"}"

CACHED_WEATHER=" $TEMPERATURE  \n$ICON ${WEATHER[1]}"

echo -e $CACHED_WEATHER >  ~/.cache/.weather_cache
