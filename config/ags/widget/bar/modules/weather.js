import { Weather as WeatherSvc } from "../../../service/weather.js"

export const Weather = () => Widget.Button({
    class_name: "weather",
    child: Widget.Box({
        children: [
            Widget.Label({
                label: WeatherSvc.weather.bind().as(w => `${w.current.temp.toFixed(1)} (${w.current.feels_like.toFixed(1)}) `),
            }),
            Widget.Icon({
                icon: WeatherSvc.weather.bind().as(w => `${App.configDir}/resources/weather/icons/${w?.current.weather[0].icon}@2x.png`),
                tooltip_text: WeatherSvc.weather.bind().as(w => w.current.weather[0].main),
                size: 16,
            })
        ],
    }),
})
