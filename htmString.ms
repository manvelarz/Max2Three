fileName = getFilenameFile maxfilename
htmName = fileName+".htm"
BitMapsNames =makeUniqueArray ( for b in getClassInstances bitmaptex  collect b.filename)

dir = maxfilepath + "webgl"
makeDir dir 
htmName = getFilenameFile maxfilename+".htm"
out_name = (dir+"/"+htmName )

allMaps = "" as stringStream
 

--CopyMapsandGenerateCode()

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


--free allMaps 
fn pointlightNew  =(
	liArray = for l in lights where classof l == Omnilight collect  l
	sceneAdd = "" as stringStream
	for i in liArray do (
		format "var % = new THREE.PointLight( % , % );\n"  i.name (colorToHex i.color) i.multiplier to:sceneAdd
		format "scene.add( % );\n" i.name to:sceneAdd
		format "%.position.set( %, %, % );\n" i.name i.position.x i.position.z -i.position.y to:sceneAdd
		)
	sceneAdd as string
	)

fn addAmbientLight = (
	if ambientColor != color 0 0 0 then(
		return "var ambient = new THREE.AmbientLight(  "+colorToHex ambientColor +" );\n scene.add( ambient );\n"
		
		) else ""
	
	)

fn colorToHex c=
(
	ret = "0x"
	h = bit.intashex c.r
	if h.count < 2 then	(
		h = ("0"+h)
	)
	ret+= h

	h = bit.intashex c.g
	if h.count < 2 then	(
		h = ("0"+h)
	)
	ret+= h

	h = bit.intashex c.b
	if h.count < 2 then	(
		h = ("0"+h)
	)
	ret+= h
	ret
)


fn hexToColor h=
(
	if h[1] == "#" then	(
		if h.count == 7 then (
			colorArray = #()
			for i = 2 to 6 by 2 do	(
				hexString = subString h i 2
				cv = (("0X"+hexString) as integer)
				if cv != undefined then (
					append colorArray cv
				)
				else 	(
					format "invalid hex string supplied\n"
					return undefined
				)
			)
			c = color colorArray[1] colorArray[2] colorArray[3]
		)
	)
	else	(
		if h.count == 6 then (
			colorArray = #()
			for i = 1 to 5 by 2 do (
				hexString = subString h i 2
				cv = (("0X"+hexString) as integer)
				if cv != undefined then (
					append colorArray cv
				)
				else 	(
					format "invalid hex string supplied\n"
					return undefined
				)
			)
			c = color colorArray[1] colorArray[2] colorArray[3]
		)
	)
	c
)

fn CopyMaps =( -- TODO  hay problema con nombres de texturas que tienen espacio y que empiezan con numero
		for m in BitMapsNames where m!= undefined do (
		tempNameExp	 = filenameFromPath m
		tempname =getFilenameFile( tempNameExp)
		newPath = dir+ "/textures/" + tempNameExp	
		copyFile m newPath
		print ("New--> "+newPath	)
		GenerateCodeForMaps tempname tempname tempNameExp
		print m	
		)
	)

			
function GenerateCodeForMaps fname varname NameExp= (
	txt = "\n"
	txt += "var "+ varname +" = new THREE.Texture();\n"
	txt+="var loader = new THREE.ImageLoader( manager );\n"
	txt+="loader.load( 'obj/" +  NameExp + "', function ( image ) {\n"
	txt+=varname + ".image = image;\n"
	txt+=varname + ".needsUpdate = true;\n"
	txt+=varname +".wrapS = "+varname+".wrapT = THREE.RepeatWrapping;\n"
	txt += "} );\n\n"
		format "%" txt to:allMaps

	)
	 
	
html = 
"<!DOCTYPE html>
<html lang=\"en\">
	<head>
		<title>"+getFilenameFile maxfilename+"</title>
		<meta charset=\"utf-8\">
		<meta name=\"viewport\" content=\"width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0\">
		<style>
			body {
				font-family: Monospace;
				background-color: #000;
				color: #fff;
				margin: 0px;
				overflow: hidden;
			}
			#info {
				color: #fff;
				position: absolute;
				top: 10px;
				width: 20%;
				text-align: center;
				z-index: 100;
				display:block;
			}
			#info a, .button { color: #f00; font-weight: bold; text-decoration: underline; cursor: pointer }
            div.relative {
                position: relative;
                left: 30px;
                border: 3px solid #73AD21;
            }       
		</style>
	</head>

	<body>


            <div id=\"info\">
                <button type=\"button\" onclick=\"CameraAnim()\">Animation</button>
                <button type=\"button\" onclick=\"CamPos()\">Light</button>
                <button type=\"button\" onclick=\"Pan()\">Paning</button>
                <!--<input type=\"range\" id=\"myRange\" value=\"90\" onchange=\"mesh.morphTargetInfluences[ 0 ] = this.value/100;>-->
                <div id=\"CamPos\">
                    lll
                </div>
            </div>

            <script src=\"js/three.min.js\"></script>
            <script src=\"js/loaders/OBJLoader2.js\"></script>
            <script src=\"js/loaders/MTLLoader.js\"></script>
            <script src=\"js/controls/OrbitControls.js\"></script>

            <script>

			var container;

			var camera, scene, renderer, controls, effect;

			var mouseX = 0, mouseY = 0;

			var windowHalfX = window.innerWidth / 2;
			var windowHalfY = window.innerHeight / 2;
			var objDef = ( {
				path: 'obj/',
				fileObj: '"+fileName+".obj', 
				texturePath: 'obj/',
				fileMtl: '"+fileName+".mtl'
			} );

			init();
			animate();


			function init() {

				container = document.createElement( 'div' );
				document.body.appendChild( container );



				renderer = new THREE.WebGLRenderer({ antialias: true });
				renderer.setClearColor( 0x222222 );
				renderer.setPixelRatio( window.devicePixelRatio );
				renderer.setSize(window.innerWidth, window.innerHeight);
				renderer.shadowMap.enabled = true;
				document.body.appendChild( renderer.domElement );


				camera = new THREE.PerspectiveCamera( 60, window.innerWidth / window.innerHeight, 1, 10000 );
				camera.position.z = 200;
				camera.position.y = 200;


				
				scene = new THREE.Scene();

				controls = new THREE.OrbitControls( camera, renderer.domElement );
				//controls.addEventListener( 'change', render ); // add this only if there is no animation loop (requestAnimationFrame)
				controls.target.y = 0;
				controls.enableDamping = true;
				controls.dampingFactor = 0.5;
				controls.enableZoom = true;
				controls.autoRotate = true;
				controls.autoRotateSpeed = 0.5;
				//controls.maxPolarAngle = Math.PI/1.85;
				controls.enablePan = true;
                
				// scene


				"+addAmbientLight()+"
				//var ambient = new THREE.AmbientLight( \"rgb(155,155,155)\" );
				//scene.add( ambient );
				
				"+pointlightNew()+"
				

				//var spotLight = new THREE.SpotLight(0xFFAA88);
				//spotLight.position.set(2117, 2500, 1330);
				//spotLight.target.position.set(0,0,0);
				//spotLight.shadow.camera.near = 0.01;
				//spotLight.castShadow = true;
				//spotLight.shadowDarkness = 0.5;
				//spotLight.shadowCameraVisible = true;
			    // console.dir(spotLight)
			    // spotLight.shadowMapWidth	= 1024;
			    // spotLight.shadowMapHeight	= 1024;
				//scene.add(spotLight);

				// texture

				var manager = new THREE.LoadingManager();
				manager.onProgress = function ( item, loaded, total ) {

					console.log( item, loaded, total );

				};

				var textureDf = new THREE.Texture();
				var textureSp = new THREE.Texture();
				
				var onProgress = function ( xhr ) {
					if ( xhr.lengthComputable ) {
						var percentComplete = xhr.loaded / xhr.total * 100;
						console.log( Math.round(percentComplete, 2) + '% downloaded' );
					}
				};

				var onError = function ( xhr ) {
				};




				// MODEL
				
					var mtlLoader = new THREE.MTLLoader();
					mtlLoader.setPath( objDef.texturePath );
					mtlLoader.setCrossOrigin( 'anonymous' );
					mtlLoader.load( objDef.fileMtl, function( materials ) {
						materials.preload();
						var objLoader = new THREE.OBJLoader2();
						//objLoader.setSceneGraphBaseNode( scope.pivot );
						objLoader.setMaterials( materials.materials );
						objLoader.setPath( objDef.path );
						objLoader.setDebug( false, false );
						var onSuccess = function ( object3d ) {
							console.log( 'Loading complete. Meshes were attached to: ' + object3d.name );
                            scene.add( object3d );
						};
						var onProgress = function ( event ) {
							if ( event.lengthComputable ) {
								var percentComplete = event.loaded / event.total * 100;
								var output = 'Download of \"' + objDef.fileObj + '\": ' + Math.round( percentComplete ) + '%';
								console.log(output);
							}
						};
						var onError = function ( event ) {
							console.error( 'Error of type \"' + event.type + '\" occurred when trying to load: ' + event.src );
						};
						objLoader.load( objDef.fileObj, onSuccess, onProgress, onError );
					});

				
				window.addEventListener( 'resize', onWindowResize, false );

			}

			function onWindowResize() {

				windowHalfX = window.innerWidth / 2;
				windowHalfY = window.innerHeight / 2;

				camera.aspect = window.innerWidth / window.innerHeight;
				camera.updateProjectionMatrix();

				renderer.setSize( window.innerWidth, window.innerHeight);

			}

			
			function CameraAnim() {

			    controls.autoRotate =  !controls.autoRotate;
			}

			function Pan() {
			    controls.enablePan = !controls.enablePan;
			}

			function CamPos() {
			    document.getElementById(\"CamPos\").innerHTML = 'x : '+String(Math.round(camera.position.x)) + ' y : '+String( Math.round(camera.position.y)) +' z : '+String( Math.round(camera.position.z));
			}
			function changelight() {
			    controls.autoRotate = !controls.autoRotate;
			}

			function animate() {

				requestAnimationFrame( animate );
				CamPos();
				controls.update(); // required if controls.enableDamping = true, or if controls.autoRotate = true
				render();

			}

			function render() {
				renderer.render( scene, camera );
			}




            </script>
</body>
</html>"
