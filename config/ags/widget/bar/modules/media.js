import { media } from "../../../variables.js"
const mpris = await Service.import('mpris')
const players = mpris.bind("players").as(p => p.filter(p => !media.ignored.includes(p.name)))

/** @param {import('types/service/mpris').MprisPlayer} player */
const Player = player => Widget.Button({
    on_clicked: () => player.playPause(),
    on_secondary_click: () => App.toggleWindow("mpris"),
    child: Widget.Label().hook(player, label => {
        const { track_artists, track_title, name } = player;
        label.label = `${track_artists.join(', ')} - ${track_title} (${name})`;
    }),
})

export const Media = Widget.Box({
    children: players.as(p => p.map(Player)),
})
