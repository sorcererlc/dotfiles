const HOME_DIR = Utils.exec(["bash", "-c", "echo $HOME"])

const getUpdates = async () => Utils.execAsync(`${HOME_DIR}/.scripts/update_check.sh`)
    .then((res) => parseInt(res))

const installUpdates = async () =>
    Utils.execAsync(`alacritty --title=update --command=${HOME_DIR}/.scripts/update.sh`)
        .catch(print)

const logout = async () => Utils.execAsync(`${HOME_DIR}/.scripts/power_menu.sh`)

const updates_label = Widget.Label()
const updates_button = Widget.Revealer({
    reveal_child: false,
    transition: "slide_left",
    transition_duration: 2,
    child: Widget.Button({
        class_name: "updates",
        child: updates_label,
        on_clicked: () => installUpdates(),
    })
})

const power_button = Widget.Button({
    class_name: "power",
    child: Widget.Label("⏻"),
    on_clicked: () => logout(),
})

Utils.interval(60 * 1000, () => {
    getUpdates()
        .then((res) => {
            updates_label.label = ` ${res}`
            updates_button.reveal_child = res > 0
        })
})

export const Power = () => Widget.Box({
    class_name: "system",
    children: [updates_button, power_button],
})
