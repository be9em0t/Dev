for OBJ in Geometry do(
print OBJ as string
)

--get all geometry in scene and check =3
objArray = Geometry as array
print objArray.count
if objArray.count != 3 then (
	--shoud write to the log
	MessageBox("Wrong number of LODs: " + (objArray.count as string))
	)
--check each obect for transform
for s in objArray do(
print s as string
s.pos = [0,0,0]
s.rotation.x_rotation = 0
s.rotation.y_rotation = 0
s.rotation.z_rotation = 0
s.scale = [1,1,1]
						)

