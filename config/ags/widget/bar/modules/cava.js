import { Cava as CavaSvc } from "../../../service/cava.js"

const bars = ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"]

export const Cava = () => Widget.Label({
    class_name: "cava",
    label: CavaSvc.vals.bind().as(v => v.replace(/[0-7]/g, m => bars[m]))
}) 
