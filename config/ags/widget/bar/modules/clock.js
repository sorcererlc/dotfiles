export const Clock = () => {
    const time = Variable("", {
        poll: [1000, "date '+%a | %d %B %Y | %H:%M'"],
    })

    return Widget.Button({
        on_clicked: () => App.toggleWindow("calendar"),
        child: Widget.Label({
            class_name: "clock",
            label: time.bind(),
        })
    })
}

