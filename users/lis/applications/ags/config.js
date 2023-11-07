import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

const Workspaces = () => Widget.Box({
    className: 'workspaces',
    connections: [[Hyprland.active.workspace, self => {
        // TODO: fetch amount of workspaces for main monitor instead hardcode 5
        const arr = Array.from({ length: 5 }, (_, i) => i + 1);
        self.children = arr.map(i => Widget.Box({
            child: Widget.Label(``),
            className: Hyprland.active.workspace.id == i ? 'focused' : '',
        }));
    }]],
});

const Clock = () => Widget.Label({
    className: 'clock',
    connections: [
        [1000, self => execAsync(['date', '+%b%e - %H:%M:%S'])
            .then(date => self.label = date).catch(console.error)],
    ],
});

const Notification = () => Widget.Box({
    className: 'notification',
    children: [
        Widget.Icon({
            icon: 'preferences-system-notifications-symbolic',
            connections: [
                [Notifications, self => self.visible = Notifications.popups.length > 0],
            ],
        }),
        Widget.Label({
            connections: [[Notifications, self => {
                self.label = Notifications.popups[0]?.summary || '';
            }]],
        }),
    ],
});

const Media = () => Widget.Box({
    className: 'media',
    child: Widget.Label({
        connections: [[Mpris, self => {
            const mpris = Mpris.getPlayer('');
            if (mpris)
                self.label = ` ${mpris.trackArtists.join(', ')} - ${mpris.trackTitle}`;
            else
                self.label = '';
        }]],
    }),
});

const Volume = () => Widget.Button({
    className: 'volume',
    onClicked: () => Audio.speaker.isMuted = !Audio.speaker.isMuted,
    child: Widget.Icon({
        connections: [[Audio, self => {
            if (!Audio.speaker)
                return;
            const vol = Audio.speaker.volume * 100;
            const icon = [
                [101, 'overamplified'],
                [67, 'high'],
                [34, 'medium'],
                [1, 'low'],
                [0, 'muted'],
            ].find(([threshold]) => threshold <= vol)[1];
            self.icon = `audio-volume-${icon}-symbolic`;
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
        Notification(),
        Volume(),
        Clock(),
        SysTray(),
    ],
});

const Bar = ({ monitor } = {}) => Widget.Window({
    name: `bar`,
    className: 'bar',
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusive: true,
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
