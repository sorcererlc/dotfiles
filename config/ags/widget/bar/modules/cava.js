import { Cava as CavaSvc } from "../../../service/cava.js"

export const Cava = () => Widget.Label({
    class_name: "cava",
    label: CavaSvc.vals.bind().as(v => v),
}) 
