# git
usefull git aliasses

[core]
	editor = nedit
	autocrlf = input
	pager = less -FRSX
  
[diff]
    tool = kdiff3
[difftool]
    tool = kdiff3
    prompt = false
[difftool "diffmerge"]
    path = kdiff3
 
[merge]
    tool = kdiff3
[mergetool]
    tool = kdiff3
    prompt = false
[mergetool "diffmerge"]
    path = kdiff3
    
[alias]
	lga = log --graph --oneline --all --decorate
	br = branch -a -v
	diff2html = "!f() { rm -rf ~/tmp/git-diff; mkdir -p ~/tmp/git-diff; if [ \"$1\" == \"\" ]; then echo \"No input!\" && exit; fi; git diff -U1000 $@ | python /home/user/scripts/github/diff2html/diff2html.py -o ~/tmp/git-diff/diff.html && firefox file:///home/user/tmp/git-diff/; }; f"
	diff2htmlc = "!f() { rm -rf ~/tmp/git-diff; mkdir -p ~/tmp/git-diff; git diff --cached -U1000 | python /home/user/scripts/github/diff2html/diff2html.py -o ~/tmp/git-diff/diff.html && firefox file:///home/user/tmp/git-diff/; }; f"
	sm-update = submodule update --init --recursive
	sm-reset = submodule foreach \"git reset --hard HEAD\"  
  
[help]
	autocorrect = 1
  
[push]
	default = upstream
[rerere]
	enabled = true  
