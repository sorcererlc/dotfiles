const UPDATE_INTERVAL = 1000

let cpu_times_cache = {
    idle_time: 0,
    total_time: 0,
}

const cpu_info = async () => Utils.readFileAsync("/proc/stat")
    .then((f) => {
        const cpu_line = f.split('\n')[0]
        const cpu_times = cpu_line.split(' ').filter((val) => val !== '')

        const user = parseInt(cpu_times[1], 10)
        const nice = parseInt(cpu_times[2], 10)
        const sys = parseInt(cpu_times[3], 10)
        const idle = parseInt(cpu_times[4], 10)
        const iowait = parseInt(cpu_times[5], 10)
        const irq = parseInt(cpu_times[6], 10)
        const softirq = parseInt(cpu_times[7], 10)

        const total = user + nice + sys + idle + iowait + irq + softirq

        const idle_diff = idle - cpu_times_cache.idle_time
        const total_diff = total - cpu_times_cache.total_time

        cpu_times_cache.idle_time = idle
        cpu_times_cache.total_time = total

        return Math.round(100 * (1 - idle_diff / total_diff))
    })

const memory_info = async () => Utils.execAsync(['bash', '-c', `free -h | awk '/^Mem/ {print $3}' | sed 's/Gi/G/g'`])

export const System = () => {
    const sep = Widget.Label({
        label: " | ",
        class_name: "separator",
    })

    const c_label = Widget.Label()

    const m_label = Widget.Label()

    Utils.interval(UPDATE_INTERVAL, () => {
        cpu_info().then((l) => {
            c_label.label = `󰾆 ${l.toString()}%`
            c_label.class_name = `cpu${l > 95 ? " warn" : ""}`
        }).catch(print)

        memory_info().then((l) => {
            m_label.label = `󰍛 ${l}`
            m_label.class_name = `memory${parseFloat(l) > 28 ? " warn" : ""}`
        }).catch(print)
    })

    return Widget.Button({
        on_secondary_click: () => Utils.execAsync("alacritty --class=btop --command=btop"),
        tooltip_text: "Right click to open btop",
        child: Widget.Box({
            class_name: "system",
            children: [c_label, sep, m_label],
        }),
    })
}
