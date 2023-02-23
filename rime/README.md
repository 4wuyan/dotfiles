Config for Rime input method.

```bash
for i in *.yaml; do
  ln -s "$PWD/$i" ~/.config/ibus/rime/"$i"
done
```

