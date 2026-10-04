Clear-Host
Write-Host ' ZELLIJ SHORTCUTS' -ForegroundColor Cyan
Write-Host ''
Write-Host ' Ctrl+Space enters leader mode. Esc returns to typing.'
Write-Host ' After Ctrl+Space:'
Write-Host ''
Write-Host '   h / j / k / l   Focus left / down / up / right'
Write-Host '   h / l          At the edge: previous / next tab'
Write-Host '   p              Pane commands'
Write-Host '   t              Tab commands'
Write-Host '   r              Resize: hjkl grow; HJKL shrink'
Write-Host '   m              Move pane: hjkl'
Write-Host '   s              Scroll: j/k, PageUp/PageDown; f search'
Write-Host '   o              Session commands'
Write-Host ''
Write-Host ' PANE (leader, p)' -ForegroundColor Cyan
Write-Host '   r split right   d split down   n new   x close'
Write-Host '   f zoom   w floating panes   e float/embed   c rename'
Write-Host ''
Write-Host ' TAB (leader, t)' -ForegroundColor Cyan
Write-Host '   h/k previous   j/l next   1-9 select   n new'
Write-Host '   r rename   x close   b move pane to a new tab'
Write-Host ''
Write-Host ' SESSION (leader, o)' -ForegroundColor Cyan
Write-Host '   w session manager   c configuration   d detach'
Write-Host ''
Write-Host ' BAR: underlined tab = active; [zoom], [sync], [+] = floating'
Write-Host ' Esc, Enter or q closes this help.' -ForegroundColor DarkGray
while ($true) {
    $zellijHelpKey = [Console]::ReadKey($true)
    if ($zellijHelpKey.Key -in @([ConsoleKey]::Escape, [ConsoleKey]::Enter, [ConsoleKey]::Q)) { break }
}