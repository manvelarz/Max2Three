
function lodeCubeMaps varname = (
	txt = "\n"
	txt += "//Cubemap\n"
	txt += "var urls = [ \"textures/posx.jpg\", \"textures/negx.jpg\", \"textures/posy.jpg\", \"textures/negy.jpg\", \"textures/posz.jpg\", \"textures/negz.jpg\" ];\n"

	txt+=varname + " = new THREE.CubeTextureLoader().load( urls );\n"
	txt+=varname + ".format = THREE.RGBFormat;\n"
	txt+=varname +".mapping = THREE.CubeReflectionMapping;\n"

--		format "%" txt to:allMaps
	
	)
	 



liArray = for l in lights where classof l == Omnilight collect  l



"45454" +addAmbientLight()


$.position.x

"var ambient = new THREE.AmbientLight(  \"rgb(155,155,155)\" );
scene.add( ambient );\n"
				

PLight = new THREE.PointLight( 0xffffff, 0.8 );
PLight.position.z = 150;

scene.add( PLight );

fn pointlightNew liArray =(
	sceneAdd = "" as stringStream
	for i in liArray do (
		format "% = new THREE.PointLight( 0xffffff, 0.8 );\n"  i.name to:sceneAdd
		format "PLight.position.x = %;\n"  i.position.x to:sceneAdd
		format "PLight.position.y = %;\n"  i.position.z to:sceneAdd
		format "PLight.position.z = %;\n"  i.position.y to:sceneAdd
		)
	
	sceneAdd as string
	
	)

fn pointlightSceneAdd liArray =(
	sceneAdd = "" as stringStream
	for i in liArray do format "scene.add( % );\n"  i.name to:sceneAdd
	
	sceneAdd as string
	
	)



jsfile = openFile (getFilenamepath out_name+ "/obj/"+"ROOMSKANLINE - Copy"+".js" ) mode:"r+"

--"mapDiffuseWrap" : ["repeat", "repeat"],

-- ********************************

meditmaterials[24] = copy matTemp[2]
classof meditmaterials[1]
a =  meditmaterials[1]

$.material =a
a = meditmaterials[24]
show a.bakedMaterial
a.bakedMaterial.diffuse = black
matTemp[1]
fn ShelltoStandartAndRevers fromShell =  (
	if fromShell then (
		global matTemp = #()
		for o in objects where o.material != undefined and classof o.material == Shell_Material do (
			MatObjPair = #()
			append MatObjPair o
			append MatObjPair o.material
			append matTemp MatObjPair
			format "__ % ------% \n"  o.name o.material
			o.material = o.material.bakedMaterial
			)
		)
		Else(
				for i = 1 to matTemp.count do (
				matTemp[i][1].material = matTemp[i][2]
				)
			)
	)


--***************************************

readLine jsfile
skipToString jsfile "Map__10_Tiles.jpg"
filePos jsfile
skipToNextLine jsfile
seek jsfile 0
format "\n0000000000%\n" 15 to:jsfile

close (getFilenamepath out_name+ "obj/"+getFilenameFile maxfilename+".js" )
	

BitMapsNames =makeUniqueArray ( for b in getClassInstances bitmaptex  collect b.filename)

	
	
	
pat= (getFilenamepath out_name+ "/obj/"+getFilenameFile maxfilename+".js")
fsadd = openFile pat mode:"r+"
skipToString fsadd "222"
skipToNextLine fsadd
pos = filePos fsadd
print (pos)	

for i = 1 to 10 do (
	format "\rggg" to:fsadd
	seek fsadd pos
	
	)
close fsadd


fn InsertWrapsInJS = (
	jsfile = openFile (getFilenamepath out_name+ "obj/"+getFilenameFile maxfilename+".js" ) mode:"a+"
		for m in BitMapsNames where m!= undefined do (
			seek jsfile 0
			tempNameExp	 = filenameFromPath m
			tempname =getFilenameFile( tempNameExp)
			print tempNameExp
			while skipToString jsfile tempname !=undefined do (
				skipToNextLine jsfile
				print "00,\n"  to:jsfile --"\"mapDiffuseWrap\" : [\"repeat\", \"repeat\"],\n" 
				print (filePos jsfile)
				
				)
		)
		close jsfile
	)

	fn InsertWrapsInJSString = (
		aaa =#()
	jsfile = openFile (getFilenamepath out_name+ "obj/"+getFilenameFile maxfilename+".js" ) mode:"a+"
		 append aaa (readline jsfile +"\n")
		for m in BitMapsNames where m!= undefined do (
			seek jsfile 0
			tempNameExp	 = filenameFromPath m
			tempname =getFilenameFile( tempNameExp)
			print tempNameExp
			while skipToString jsfile tempname !=undefined do (
				skipToNextLine jsfile
				print "00,\n"  to:jsfile --"\"mapDiffuseWrap\" : [\"repeat\", \"repeat\"],\n" 
				print (filePos jsfile)
				
				)
		)
		close jsfile
	)


getNumSubTexmaps $.material
getSubTexmap $.material
for i = 1 to getNumSubTexmaps $.material do (
	getSubTexmap $.material 1
	
	)
	
for i = 1 to getNumSubTexmaps $.material  where (getSubTexmap $.material i)!=undefined  do (
	 tmap =getSubTexmap $.material i
	if (hasproperty tmap "filename") then print tmap.filename
	) 	

	
	fn SceneUnicBitMaps  = (
		uniqBitMaps = #()
		for o in objects where o.material!= undefined do (
			for i = 1 to getNumSubTexmaps o.material  where (getSubTexmap o.material i)!=undefined  do (
				tmap = getSubTexmap o.material i
				if (hasproperty tmap "filename") then (
					appendIfUnique uniqBitMaps tmap.filename
					)
				) 	
			)
		uniqBitMaps	
		) 

	
	fn BitMapsFromMat mat  = (
		BitMaps =#()
			for i = 1 to getNumSubTexmaps mat  where (getSubTexmap mat i)!=undefined  do (
				tmap = getSubTexmap mat i
				if (hasproperty tmap "filename") then (
					appendIfUnique BitMaps tmap.filename
					)
				) 	
		if BitMaps != #() then  BitMaps else 0 -- Look if  array is empty
				
	) 
	
	BitMapsFromMat $.material
	
	BitMaps =#()
	fn RecurciveMtlOut mat = (
			
			if getNumSubMtls  mat != 0 then (
				for i = 1 to getNumSubMtls mat where (getSubMtl mat i) != undefined  do (
					tmat =getSubMtl  mat i
					RecurciveMtlOut tmat
					)	 	
				)
			else ( print mat
					tempArr = ( BitMapsFromMat mat ) 
					for map in tempArr do (
						append BitMaps ( BitMapsFromMat mat )
						)
					)
				BitMaps
		
		)
		
		
		g = for o in objects where o.material!= undefined collect ( RecurciveMtlOut o.material)
		
		
		
		RecurciveMtlOut $.material 
		
		d = makeUniqueArray g
		print d