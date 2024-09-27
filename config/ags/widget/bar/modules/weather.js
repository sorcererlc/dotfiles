import { Weather as WeatherSvc } from "../../../service/weather.js"

export const Weather = () => {
    const l = Widget.Label({
        setup: self => self.hook(WeatherSvc, (self, w) => {
            const temp = w?.current.temp.toFixed(1)
            const feels_like = w?.current.feels_like.toFixed(1)

            self.label = `${temp} (${feels_like}) `
        }, "weather-updated")
    })

    const i = Widget.Icon({
        setup: self => self.hook(WeatherSvc, (self, w) => {
            self.icon = `${App.configDir}/resources/weather/icons/${w?.current.weather[0].icon}@2x.png`
            self.tooltip_text = w?.current.weather[0].main || ""
        }, "weather-updated"),
        size: 16,
    })

    const box = Widget.Box({
        children: [l, i],
    })

    return Widget.Button({
        class_name: "weather",
        child: box,
    })
}
