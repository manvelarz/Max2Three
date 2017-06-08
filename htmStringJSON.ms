fileName = getFilenameFile maxfilename
htmName = fileName+".htm"
BitMapsNames =makeUniqueArray ( for b in getClassInstances bitmaptex  collect b.filename)

dir = maxfilepath + "webgl"
makeDir dir 
htmName = getFilenameFile maxfilename+".htm"
out_name = (dir+"/"+htmName )

allMaps = "" as stringStream
 



--free allMaps 

fn ShelltoStandartAndRevers fromShell =  (
	if fromShell then (
		global matTemp = #()
		for o in objects where o.material != undefined and classof o.material == Shell_Material do (
			o.material.bakedMaterial.diffuse = white
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

fn CopyMapsandGenerateCode =( -- TODO  hay problema con nombres de texturas que tienen espacio y que empiezan con numero
		for m in BitMapsNames where m!= undefined do (
		tempNameExp	 = filenameFromPath m
		tempname =getFilenameFile( tempNameExp)
		copyFile m (dir+ "/obj/" + tempNameExp)
		--maps tempname tempname tempNameExp
			format "---------%" tempname
		)
	)

			
function maps fname varname NameExp= (
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
	
fn InsertWrapsInJS = ( -- TODO aun no funciona porque queria que funcione con streaming y no encuentro manera en insertar una linea ..... siempre anade;(
	jsfile = openFile (getFilenamepath out_name+ "obj/"+getFilenameFile maxfilename+".js" ) mode:"r+"
		for m in BitMapsNames where m!= undefined do (
			seek jsfile 0
			tempNameExp	 = filenameFromPath m
			tempname =getFilenameFile( tempNameExp)
			print tempNameExp
			while skipToString jsfile tempname !=undefined do (
				skipToString jsfile ","
				--skipToNextLine jsfile
				format "\"mapDiffuseWrap\" : [\"repeat\", \"repeat\"],\n"  to:jsfile
				print (filePos jsfile)
				
				)
		)
		close jsfile
	)
	
html = 
"<!DOCTYPE html>
<html lang=\"en\">
	<head>
		<link rel=\"shortcut icon\" href=\"\">
		<title>Sagrada Familia</title>
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
            <script src=\"js/loaders/OBJLoader.js\"></script>
            <script src=\"js/controls/OrbitControls.js\"></script>

            <script>

			var container;

			var camera, scene, renderer, controls, effect, PLight;

			var mouseX = 0, mouseY = 0;

			var windowHalfX = window.innerWidth / 2;
			var windowHalfY = window.innerHeight / 2;


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
				camera.position.z = 150;
				//camera.position.y = 200;
				//camera.rotation.order = 'YXZ'

				scene = new THREE.Scene();

				controls = new THREE.OrbitControls( camera, renderer.domElement );
				//controls.addEventListener( 'change', render ); // add this only if there is no animation loop (requestAnimationFrame)
				controls.target.y = 0;
				controls.enableDamping = true;
				controls.dampingFactor = 0.15;
				controls.enableZoom = true;
				controls.autoRotate = true;
				controls.autoRotateSpeed = 0.2;
				//controls.maxPolarAngle = Math.PI/1.85;
				controls.enablePan = true;
                
				// scene



				var ambient = new THREE.AmbientLight(  \"rgb(155,155,155)\" );
				scene.add( ambient );      
				
				var PLight = new THREE.PointLight( 0xb4e7f2, 1 );
				scene.add( PLight );


				

				

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


				var loader = new THREE.JSONLoader();
				loader.load( 'obj//"+fileName+".js', function ( geometry, materials ) {
								    for ( var i = 0; i < materials.length; i ++ ) {
                            if  (materials[ i ].map != null){
                                try {console.log( \"0000\" +materials[ i ].map.image.currentSrc); 
                                     var mmap = materials[ i ].map;
                                    mmap.version = 1;
                                    mmap.wrapS  = mmap.wrapT =  THREE.RepeatWrapping;
                                     mmap.repeat = {x:2, y:2};
                                    } catch(e) {}
                               }
                            }
				
					var mesh = new THREE.Mesh( geometry, new THREE.MultiMaterial( materials ) );
					scene.add( mesh );
				} );
		
				
				
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
				//PLight.position = camera.position;
				render();

			}

			function render() {
				renderer.render( scene, camera );
			}




            </script>
</body>
</html>"
free allMaps 