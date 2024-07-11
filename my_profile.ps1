# Sublime Merge
function s {
  $r = "."
  if ($args[0]) { $r = $args[0] }
  & "C:\Program Files\Sublime Merge\sublime_merge.exe" $r
}

# VSCode
function c {
  $r = "."
  if ($args[0]) { $r = $args[0] }
  code $r
}

New-Alias g git
function gs { git status }

