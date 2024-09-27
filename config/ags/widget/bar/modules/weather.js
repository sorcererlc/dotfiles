const UPDATE_INTERVAL = 60 * 60 * 1000

// OpenWeatherMap params
const OWM = {
    key: "",
    lat: "",
    lon: "",
    exclude: "minutely,daily,hourly",
    units: "metric",
    lang: "en",
}
let HOME_DIR

const loadEnv = () => {
    HOME_DIR = Utils.exec(["bash", "-c", "echo $HOME"])

    const lines = Utils.readFile(`${HOME_DIR}/.secrets`).split("\n")

    lines.forEach((l) => {
        if (l.match("OWM_KEY")) {
            OWM.key = l.split("=")[1]
        }

        if (l.match("LOCATION_LAT")) {
            OWM.lat = l.split("=")[1]
        }

        if (l.match("LOCATION_LON")) {
            OWM.lon = l.split("=")[1]
        }
    })
}

const refresh = async () => {
    const cache_dir = `${HOME_DIR}/.cache`
    const cache_file = `${cache_dir}/weather.json`
    const url = `https://api.openweathermap.org/data/3.0/onecall?lat=${OWM.lat}&lon=${OWM.lon}&exclude=${OWM.exclude}&appid=${OWM.key}&units=${OWM.units}&lang=${OWM.lang}`

    print("Refreshing weather cache")

    return Utils.fetch(url)
        .then(async (res) => {
            return res.text().then((r) => {
                const j = JSON.parse(r)
                j.timestamp = new Date().toISOString()
                if (j.cod) {
                    j.owm = OWM
                    j.url = url
                    Utils.writeFile(JSON.stringify(j), "/tmp/weather-error.json")
                    return
                }

                return Utils.writeFile(JSON.stringify(j), cache_file)
                    .then(() => j)
            })
        })
}

const getWeather = async () => {
    const cache_dir = `${HOME_DIR}/.cache`
    const cache_file = `${cache_dir}/weather.json`

    return Utils.readFileAsync(cache_file)
        .then(async (f) => {
            let j = JSON.parse(f)

            const now = new Date().getTime()
            const cache_time = new Date(j.timestamp).getTime()
            const diff = (now - cache_time) / UPDATE_INTERVAL

            if (diff < 1.0) {
                print("Returning weather from cache")
                return Promise.resolve(j)
            }

            const jn = await refresh()
            if (!j) {
                return Promise.resolve(j)
            }

            j = JSON.parse(jn)
            return Promise.resolve(j)
        })
        .catch(async () => {
            return refresh()
        })
        .finally(() => { })
}

export const Weather = () => {
    loadEnv()

    const l = Widget.Label({
        tooltip_text: "Right-click to refresh cache",
    })
    const i = Widget.Icon({
        size: 24,
    })

    const box = Widget.Box({
        children: [l, i],
    })

    Utils.interval(5000, () => {
        getWeather().then((w) => {
            const temp = parseFloat(w.current.temp).toFixed(1)
            const feels_like = parseFloat(w.current.feels_like).toFixed(1)
            const icon = w.current.weather[0].icon

            l.label = `${temp} (${feels_like}) `
            i.icon = `${App.configDir}/resources/weather/icons/${icon}@2x.png`
            i.tooltip_text = w.current.weather[0].main
        })
            .catch(print)
    })

    return Widget.Button({
        class_name: "weather",
        on_secondary_click: () => refresh(),
        child: box,
    })
}
