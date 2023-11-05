Config for Rime input method.

```sh
for i in *.yaml; do
  for p in ~/.config/ibus/rime ~/.local/share/fcitx5/rime; do
    [ -d "$p" ] && ln -s "$PWD/$i" "$p/$i"
  done
done
```

