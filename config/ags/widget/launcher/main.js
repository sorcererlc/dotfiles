const { query } = await Service.import("applications")

const WINDOW_NAME = "launcher"

/** @param {import('resource:///com/github/Aylur/ags/service/applications.js').Application} app */
const AppItem = app => Widget.Button({
    on_clicked: () => {
        App.closeWindow(WINDOW_NAME)
        app.launch()
    },
    attribute: { app },
    class_name: "entry",
    child: Widget.Box({
        children: [
            Widget.Icon({
                icon: app.icon_name || "",
                size: 42,
            }),
            Widget.Label({
                class_name: "title",
                label: app.name,
                xalign: 0,
                vpack: "center",
                truncate: "end",
            }),
        ],
    }),
})

const AppLauncher = () => {
    let applications = query("").map(AppItem)

    const list = Widget.Box({
        vertical: true,
        class_name: "app-list",
        children: applications,
    })

    function repopulate() {
        applications = query("").map(AppItem)
        list.children = applications
    }

    const search = Widget.Entry({
        hexpand: true,
        class_name: "search",
        on_accept: () => {
            const results = applications.filter((item) => item.visible);
            if (results[0]) {
                App.toggleWindow(WINDOW_NAME)
                results[0].attribute.app.launch()
            }
        },
        on_change: ({ text }) => applications.forEach(item => {
            item.visible = item.attribute.app.match(text ?? "")
        }),
    })

    return Widget.Box({
        vertical: true,
        class_name: "launcher-window",
        children: [
            search,
            Widget.Scrollable({
                hscroll: "never",
                class_name: "scrollable",
                child: list,
            }),
        ],
        setup: self => self.hook(App, (_, windowName, visible) => {
            if (windowName !== WINDOW_NAME) {
                return
            }

            if (visible) {
                repopulate()
                search.text = ""
                search.grab_focus()
            }
        }),
    })
}

export const Launcher = Widget.Window({
    name: WINDOW_NAME,
    visible: false,
    keymode: "exclusive",
    child: AppLauncher(),
    setup: self => self.keybind("Escape", () => {
        App.closeWindow(WINDOW_NAME)
    }),
})
