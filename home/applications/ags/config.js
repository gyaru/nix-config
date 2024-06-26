import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

// FIXME: Gjs-Console-WARNING **: 01:57:00.568: Error: Using "connections" and "binds" props are DEPRECATED

const Workspaces = () => Widget.Box({
    className: 'workspaces',
    connections: [[Hyprland.active.workspace, self => {
        // TODO: fetch amount of workspaces for main monitor instead hardcode 5 
        const arr = Array.from({ length: 5 }, (_, i) => i + 1);
        self.children = arr.map(i => Widget.Box({
            child: Widget.Label(``),
            className: Hyprland.active.workspace.id == i ? 'focused' : '',
        }));
    }]],
});

const Clock = () => Widget.Label({
    className: 'clock',
    connections: [
        [1000, self => execAsync(['date', '+%H:%M'])
            .then(date => self.label = date).catch(console.error)],
    ],
});

const Media = () => Widget.Box({
    className: 'media',
    child: Widget.Label({
        connections: [[Mpris, self => {
            const mpris = Mpris.getPlayer('');
            if (mpris)
                self.label = `${mpris.trackArtists.join(', ')} - ${mpris.trackTitle}`;
            else
                self.label = '';
        }]],
    }),
});

const Volume = () => Widget.Button({
    className: 'volume',
    onClicked: () => Audio.speaker.isMuted = !Audio.speaker.isMuted,
    child: Widget.Label({
        connections: [[Audio, self => {
            if (!Audio.speaker)
                return;
            const vol = Audio.speaker.volume * 100;
            const label = [
                [67, ''],
                [34, ''],
                [1, ''],
                [0, ''],
            ].find(([threshold]) => threshold <= vol)[1];
            self.label = `${label}`;
            self.tooltipText = `Volume ${Math.floor(vol)}%`;
        }, 'speaker-changed']],
    }),
});

const SysTray = () => Widget.Box({
    className: 'tray',
    connections: [[SystemTray, self => {
        self.children = SystemTray.items.map(item => Widget.Button({
            child: Widget.Icon({ binds: [['icon', item, 'icon']] }),
            onPrimaryClick: (_, event) => item.activate(event),
            onSecondaryClick: (_, event) => item.openMenu(event),
            binds: [['tooltip-markup', item, 'tooltip-markup']],
        }));
    }]],
});

const Left = () => Widget.Box({
    hpack: 'start',
    children: [
        Media(),
    ],
});

const Center = () => Widget.Box({
    children: [
        Workspaces(),
    ],
});

const Right = () => Widget.Box({
    hpack: 'end',
    children: [
        Volume(),
        SysTray(),
        Clock(),
    ],
});

const Bar = ({ monitor } = {}) => Widget.Window({
    name: `bar`,
    className: 'bar',
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child: Widget.CenterBox({
        startWidget: Left(),
        centerWidget: Center(),
        endWidget: Right(),
    }),
})

export default {
    style: App.configDir + '/style.css',
    windows: [
        Bar(),
    ],
};
