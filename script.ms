-- *** All the Omnis from the scene translslate to html as PointLights passing the position, Color and , Multiplier parameters
 
 filein "htmString.ms"
 CopyMapsandGenerateCode()
--ShelltoStandartAndRevers true
exportFile (getFilenamepath out_name+ "/obj/"+getFilenameFile maxfilename+".obj" ) #noPrompt using:ObjExp
--ShelltoStandartAndRevers false
--makedir (dir+ "/textures/")


out_file = createfile out_name

format "%" html to:out_file
close out_file


--ShellLaunch "cmd"  ("/k cd "+dir +"/js  && python convert_obj_three_for_python3.py -i "+ "../obj/" +fileName +".obj -o "+"../obj/" + fileName +".js" )

ShellLaunch "cmd"  ("/k cd "+dir +"  && http-server" )


ShellLaunch ("http://127.0.0.1:8080/"+htmName) ""

--for i = 4001 to 4069 do format  ("http://bubblegum.agency/documentos/cv/" +i as string + ".pdf\n")0