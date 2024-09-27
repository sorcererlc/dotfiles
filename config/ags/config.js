import Bar from './widget/bar/main.js'
import { Launcher } from "./widget/launcher/main.js"
import { Media } from "./widget/media/main.js"
import { Calendar } from "./widget/calendar/main.js"

App.resetCss()

const scss = `${App.configDir}/style/style.scss`
const css = `/tmp/ags-style.css`
Utils.exec(`sassc ${scss} ${css}`)

Utils.monitorFile(
    `${App.configDir}/style`,
    function() {
        Utils.exec(`sassc ${scss} ${css}`)
        App.resetCss()
        App.applyCss(css)
    },
)

App.config({
    style: css,
    windows: [
        Bar(),
        Launcher,
        Media,
        Calendar(),
    ],
})
