macroScript Git_Add_Commit_PUSH
	category:"Manvel"
	toolTip:"Add commit and push to github"
	ButtonText:"GitPush"
(
	message = "message generated from Maxscript"
dir = maxfilepath +"Maxscript git\\Max2Three"
ShellLaunch "cmd"  ("/k cd "+dir +"  && git add ." )
ShellLaunch "cmd"  ("/k cd "+dir +"  && git status" )
ShellLaunch "cmd"  ("/k cd "+dir +"  && git commit -m \""+message+"" )
	
)