# TODO: Add this to backup location!!!!!!!
~/.local/share/mime/packages/
Run: `update-mime-database ~/.local/share/mime`

~/.local/share/applications
Run: `update-desktop-database ~/.local/share/applications`


Add these just in case. These should, however, be executed by automatic other scripts so are tecnically not needed
```shell
ln -sf $HOME/.config/hypr/config/devices/<environment>.conf $HOME/.config/hypr/config/devices/active.conf
ln -sf $HOME/.config/hypr/config/keybinds/monitor/<environment>.conf $HOME/.config/hypr/config/keybinds/monitor/active.conf
ln -sfn $HOME/.config/hypr/config/monitor/<environment> $HOME/.config/hypr/config/monitor/active
ln -sfn $HOME/.config/hypr/config/themes/system/<theme_name>/ $HOME/.config/hypr/config/themes/system/active
ln -sf $HOME/.config/hypr/config/variables/<environment>.conf $HOME/.config/hypr/config/variables/active.conf
```