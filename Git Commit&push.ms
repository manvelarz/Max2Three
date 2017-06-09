macroScript Git_Add_Commit_PUSH
	category:"Manvel"
	toolTip:"Add commit and push to github"
	ButtonText:"GitPush"
(

try(closeRolloutFloater rof) catch()
rof=newrolloutfloater "Commit message" 270 400 500 500
Global message = ""	
	
rollout Connection "Commit " width:263 height:88
	(
	edittext edt1 "" text:""  pos:[10,28] width:230 height:68 readOnly:false -- text:ultimo_Mananger_Access_ip
	button Commit "Commit with message" pos:[13,103] width:230 height:23
	button Gitpush "Push to github" pos:[13,150] width:230 height:43
	GroupBox grp1 "Enter a message and commit" pos:[6,5] width:247 height:130
	--label lbl2 "Automatic Search" pos:[46,57] width:146 height:16
	--checkbox chk1 "Checkbox" pos:[18,55] width:17 height:17 checked:true --(execute ultimo_Mananger_Access_Chek)
	on edt1 entered text do		message = text
	on Commit pressed do(		
		if message == "" then message= "message generated from Maxscript"
		dir = maxfilepath +"Maxscript git\\Max2Three"
		--ShellLaunch "cmd"  ("/k cd "+dir +"  && git add ." )
		--ShellLaunch "cmd"  ("/k cd "+dir +"  && git status" )
		ShellLaunch "cmd"   ("/k cd "+dir +"  && git commit -a -m \""+message+"" )

		)
		on Gitpush pressed do(		
			ShellLaunch "cmd"  ("cd "+dir +"\r\n git push")
		)
		
	on chk1 changed  Automat do(
			 )

	
)
	addrollout Connection  rof
	


)