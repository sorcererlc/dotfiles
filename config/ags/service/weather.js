import { Environment } from "./env.js"

const UPDATE_INTERVAL = 60 * 60 * 1000

class WeatherSvc extends Service {
    static {
        Service.register(this, {}, {
            "weather": ["gobject"],
        })
    }

    #owm = {
        key: "",
        lat: "",
        lon: "",
        exclude: "minutely,daily,hourly",
        units: "metric",
        lang: "en",
    }

    #url = ""

    weather = Variable({
        current: {
            temp: 0.0,
            feels_like: 0.0,
            weather: [{
                icon: "",
                main: "",
            }]
        }
    })

    constructor() {
        super()

        const self = this

        this.#loadEnv()
        this.#refreshCache()

        setInterval(() => {
            self.#refreshCache()
        }, UPDATE_INTERVAL)
    }

    #loadEnv = () => {
        const lines = Utils.readFile(`${Environment.home_dir}/.secrets`).split("\n")

        lines.forEach((l) => {
            if (l.match("OWM_KEY")) {
                this.#owm.key = l.split("=")[1]
            }

            if (l.match("LOCATION_LAT")) {
                this.#owm.lat = l.split("=")[1]
            }

            if (l.match("LOCATION_LON")) {
                this.#owm.lon = l.split("=")[1]
            }
        })

        this.#url = `https://api.openweathermap.org/data/3.0/onecall?lat=${this.#owm.lat}&lon=${this.#owm.lon}&exclude=${this.#owm.exclude}&appid=${this.#owm.key}&units=${this.#owm.units}&lang=${this.#owm.lang}`
    }


    #refreshCache = async () => {
        print("Refreshing weather cache")

        if (this.#url === "") {
            return Promise.reject("OpenWeatherMap URL not set")
        }

        return Utils.fetch(this.#url)
            .then((res) =>
                res.text().then((r) => {
                    const j = JSON.parse(r)

                    if (j.cod) {
                        print("Failed to get weather", "\n", this.#url, "\n", JSON.stringify(j))
                        return
                    }

                    this.weather.value = j
                })
            )
            .catch(print)
    }
}

export const Weather = new WeatherSvc

