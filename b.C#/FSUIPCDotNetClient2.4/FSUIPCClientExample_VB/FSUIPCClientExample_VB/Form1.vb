Imports FSUIPC
Imports System.Drawing.Drawing2D

Public Class Form1

    ' Constants
    Private Const AppTitle As String = "FSUIPCClientExample_VB"

    ' Register the Offsets we're interesing in for this application
    Dim airSpeed As Offset(Of Integer) = New FSUIPC.Offset(Of Integer)(&H2BC) ' Basic integer read example
    Dim avionics As Offset(Of Integer) = New FSUIPC.Offset(Of Integer)(&H2E80) ' Basic integer read and write example
    Dim fsLocalDateTime As Offset(Of Byte()) = New FSUIPC.Offset(Of Byte())(&H238, 10) ' Example of reading an arbitary set of bytes.
    Dim aircraftType As Offset(Of String) = New FSUIPC.Offset(Of String)("AircraftInfo", &H3160, 24) ' Example of string and use of a group
    Dim lights As Offset(Of BitArray) = New FSUIPC.Offset(Of BitArray)(&HD0C, 2) ' Example of BitArray used to manage a bit field type offset.
    Dim compass As Offset(Of Double) = New FSUIPC.Offset(Of Double)(&H2CC) ' Example for disconnecting/reconnecting
    Dim pause As Offset(Of Short) = New FSUIPC.Offset(Of Short)(&H262, True) ' Example of a write only offset.
    Dim com2bcd As Offset(Of Short) = New FSUIPC.Offset(Of Short)(&H3118) ' Example of reading a frequency coded in Binary Coded Decimal
    Dim playerLatitude As Offset(Of Long) = New Offset(Of Long)(&H560) ' Offset for Lat/Lon features
    Dim playerLongitude As Offset(Of Long) = New Offset(Of Long)(&H568) ' Offset for Lat/Lon features
    Dim onGround As Offset(Of Short) = New Offset(Of Short)(&H366) ' Offset for Lat/Lon features
    Dim magVar As Offset(Of Short) = New Offset(Of Short)(&H2A0) ' Offset for Lat/Lon features
    Dim playerHeadingTrue As Offset(Of UInteger) = New Offset(Of UInteger)(&H580) ' Offset for moving the plane
    Dim playerAltitude As Offset(Of Long) = New Offset(Of Long)(&H570) ' Offset for moving the plane
    Dim slewMode As Offset(Of Short) = New Offset(Of Short)(&H5DC, True) ' Offset for moving the plane
    Dim sendControl As Offset(Of Integer) = New Offset(Of Integer)(&H3110, True) ' Offset for moving the plane

    Const REFRESH_SCENERY As Integer = 65562 ' Control number to refresh the scenery

    Dim EGLL As FsLatLonPoint ' Holds the position of London Heathrow (EGLL)
    Dim runwayQuad As FsLatLonQuadrilateral ' defines the four corners of the runway (27L at EGLL)
    Dim AI As AITrafficServices ' Holds a reference to the AI Traffic Services object

    ' Initialise some of the variables we will need later
    Public Sub New()
        InitializeComponent()
        ' Setup the example data for London Heathrow
        ' 1. The position
        '    This shows an FsLongitude and FsLatitude class made from the Degrees/Minutes/Seconds constructor.
        '    The Timer1_Tick() method shows a different contructor (using the RAW FSUIPC values).
        Dim lat As FsLatitude = New FsLatitude(51, 28, 39D)
        Dim lon As FsLongitude = New FsLongitude(0, -27, -41D)
        EGLL = New FsLatLonPoint(lat, lon)
        ' Now define the Quadrangle for the 27L (09R) runway.
        ' We could just define the four corner Lat/Lon points if we knew them.
        ' In this example however we're using the helper function to calculate the points
        ' from the runway information.  This is the kind of info you can find in the output files
        ' from Pete Dowson's MakeRunways program.
        Dim rwyThresholdLat As FsLatitude = New FsLatitude(51.464943D)
        Dim rwyThresholdLon As FsLongitude = New FsLongitude(-0.434046D)
        Dim rwyMagHeading As Double = 272.7D
        Dim rwyMagVariation As Double = -3D
        Dim rwyLength As Double = 11978D
        Dim rwyWidth As Double = 164D
        ' Call the static helper on the FsLatLonQuarangle class to generate the Quadrangle for this runway...
        Dim thresholdCentre As FsLatLonPoint = New FsLatLonPoint(rwyThresholdLat, rwyThresholdLon)
        Dim trueHeading As Double = rwyMagHeading + rwyMagVariation
        runwayQuad = FsLatLonQuadrilateral.ForRunway(thresholdCentre, trueHeading, rwyWidth, rwyLength)
        ' Set the default value for the distance units and AI Radar range
        Me.cbxDistanceUnits.Text = "Nautical Miles"
        Me.cbxRadarRange.Text = "50"
    End Sub

    ' Application started so try to open the connection to FSUIPC
    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        OpenFSUIPC()
    End Sub

    ' User pressed connect button so try again...
    Private Sub btnStart_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStart.Click
        OpenFSUIPC()
    End Sub


    ' Opens FSUIPC - if all goes well then starts the 
    ' timer to drive start the main application cycle.
    ' If can't open display the error message.
    Private Sub OpenFSUIPC()
        Try
            ' Attempt to open a connection to FSUIPC (running on any version of Flight Sim)
            FSUIPCConnection.Open()
            ' Opened OK so disable the Connect button
            Me.btnStart.Enabled = False
            Me.chkEnableAIRadar.Enabled = True
            ' and start the timer ticking to drive the rest of the application
            Me.Timer1.Interval = 200
            Me.Timer1.Enabled = True
            ' Set the AI object
            AI = FSUIPCConnection.AITrafficServices
        Catch ex As Exception
            ' Badness occurred - show the error message
            MessageBox.Show(ex.Message, AppTitle, MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' Application is unloading so call close to cleanup the 
    ' UNMANAGED memory used by FSUIPC. 
    Private Sub Form1_FormClosed(ByVal sender As System.Object, ByVal e As System.Windows.Forms.FormClosedEventArgs) Handles MyBase.FormClosed
        FSUIPCConnection.Close()
    End Sub

    ' The timer handles the real-time updating of the Form.
    ' The default group (ie, no group specified) is 
    ' Processed and every Offset in the default group is updated.
    Private Sub Timer1_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer1.Tick

        Try

            ' Process the default group
            FSUIPCConnection.Process()

            ' IAS - Simple integer returned so just divide as per the 
            ' FSUIPC documentation for this offset and display the result.
            Dim airpeedKnots As Double = (airSpeed.Value / 128D)
            Me.txtIAS.Text = airpeedKnots.ToString("f1")


            ' Avionics Master Switch
            Me.chkAvionics.Checked = (avionics.Value > 0)  ' 0 = Off, 1 = On.


            ' Advanced Concept: Reading Raw Blocks of Data.
            ' FS Local Date and Time
            ' This demonstrates getting back an arbitrary number of bytes from an offset.
            ' Here we're getting 10 back from Offset 0x0328 which contain info about the 
            ' local date and time in FS.
            ' Because it's returned as a byte array we need to handle everything ourselves...
            ' 1. Year (starts at Byte 8) for 2 bytes. (Int16)
            '    Use the BitConverter class to get it into a native Int16 variable
            Dim year As Short = BitConverter.ToInt16(fsLocalDateTime.Value, 8)
            '    You could also do it manually if you know about such things...
            '    Dim year As Short = (fsLocalDateTime.Value(8) + (fsLocalDateTime.Value(9) * &H100))
            ' 2. Make new datetime with the the time value at 01/01 of the year...
            '    Time - in bytes 0,1 and 2. (Hour, Minute, Second):
            Dim fsTime As DateTime = New DateTime(year, 1, 1, fsLocalDateTime.Value(0), fsLocalDateTime.Value(1), fsLocalDateTime.Value(2))
            ' 3. Get the Day of the Year back (not given as Day and Month) 
            '    and add this on to the Jan 1 date we created above 
            '    to give the final date:
            Dim dayNo As Short = BitConverter.ToInt16(fsLocalDateTime.Value, 6)
            fsTime = fsTime.Add(New TimeSpan(dayNo - 1, 0, 0, 0))
            ' Now print it out
            Me.txtFSDateTime.Text = fsTime.ToString("dddd, MMMM dd yyyy hh:mm:ss")


            ' Lights
            ' This demonstrates using the BitArray type to handle
            ' a bit field type offset.  The lights are a 2 byte (16bit) bit field 
            ' starting in offset 0D0C.
            ' To make the code clearer and easier to write in the first
            ' place - I created a LightType Enum (bottom of this file).
            ' You could of course just use the literal values 0-9 if you prefer.
            ' For the first three, I've put alternative lines in comments
            ' that use a literal indexer instead of the enum.
            ' Update each checkbox according to the relevent bit in the BitArray...
            Me.chkBeacon.Checked = lights.Value(LightType.Beacon)
            'Me.chkBeacon.Checked = lights.Value(1)
            Me.chkCabin.Checked = lights.Value(LightType.Cabin)
            'Me.chkCabin.Checked = lights.Value(9)
            Me.chkInstuments.Checked = lights.Value(LightType.Instruments)
            'Me.chkInstuments.Checked = lights.Value(5)
            Me.chkLanding.Checked = lights.Value(LightType.Landing)
            Me.chkLogo.Checked = lights.Value(LightType.Logo)
            Me.chkNavigation.Checked = lights.Value(LightType.Navigation)
            Me.chkRecognition.Checked = lights.Value(LightType.Recognition)
            Me.chkStrobes.Checked = lights.Value(LightType.Strobes)
            Me.chkTaxi.Checked = lights.Value(LightType.Taxi)
            Me.chkWing.Checked = lights.Value(LightType.Wing)


            ' Compass heading
            ' Used to demonstrate disconnecting and reconnecting an Offset.
            ' We display the data in the field regardless of whether 
            ' it's been updated or not.
            Me.txtCompass.Text = compass.Value.ToString("F2")

            ' COM2 frequency
            ' Shows decoding a DCD frequency to a string
            ' a. Convert to a string in Hexadecimal format
            Dim com2String As String = com2bcd.Value.ToString("X")
            ' b. Add the assumed '1' and insert the decimal point
            com2String = "1" & com2String.Substring(0, 2) & "." & com2String.Substring(2, 2)
            Me.txtCOM2.Text = com2String

            ' Latitude and Longitude 
            ' Shows using the FsLongitude and FsLatitude classes to easily work with Lat/Lon
            ' Create new instances of FsLongitude and FsLatitude using the raw 8-Byte data from the FSUIPC Offsets
            Dim lon As FsLongitude = New FsLongitude(playerLongitude.Value)
            Dim lat As FsLatitude = New FsLatitude(playerLatitude.Value)
            ' Use the ToString() method to output in human readable form:
            ' (note that many other properties are avilable to get the Lat/Lon in different numerical formats)
            Me.txtLatitude.Text = lat.ToString()
            Me.txtLongitude.Text = lon.ToString()

            ' Using fsLonLatPoint to calculate distance and bearing between two points
            ' First get the point for the current plane position
            Dim currentPosition As FsLatLonPoint = New FsLatLonPoint(lat, lon)
            ' Get the distance between here and EGLL
            Dim distance As Double = 0
            Select (Me.cbxDistanceUnits.Text)
                Case "Nautical Miles"
                    distance = currentPosition.DistanceFromInNauticalMiles(EGLL)
                Case "Statute Miles"
                    distance = currentPosition.DistanceFromInFeet(EGLL) / 5280D
                Case "Kilometres"
                    distance = currentPosition.DistanceFromInMetres(EGLL) / 1000D
            End Select
            ' Write the distance to the text box formatting to 2 decimal places
            Me.txtDistance.Text = distance.ToString("N2")
            ' Get the bearing (True) 
            Dim bearing As Double = currentPosition.BearingTo(EGLL)
            ' Get the magnetic variation
            Dim variation As Double = magVar.Value * 360D / 65536D
            ' convert bearing to magnetic bearing by subtracting the magnetic variation
            bearing = bearing - variation
            ' Display the bearing in whole numbers and tag on a degree symbol
            Me.txtBearing.Text = bearing.ToString("F0") & Chr(&HB0)

            ' Now check if the player is on the runway:
            ' Test is the plane is on the ground and if the current position is in the bounds of
            ' the runway Quadrangle we calculated in the constructor above.
            Me.chkPlaneOnRunway.Checked = (Me.onGround.Value = 1 And runwayQuad.ContainsPoint(currentPosition))


        Catch exFSUIPC As FSUIPCException
            If exFSUIPC.FSUIPCErrorCode = FSUIPCError.FSUIPC_ERR_SENDMSG Then
                ' Send message error - connection to FSUIPC lost.
                ' Show message, disable the main timer loop and relight the 
                ' connection button:
                ' Also Close the broken connection.
                Me.Timer1.Enabled = False
                Me.AIRadarTimer.Enabled = False
                Me.btnStart.Enabled = True
                Me.chkEnableAIRadar.Enabled = False
                Me.chkEnableAIRadar.Checked = False
                FSUIPCConnection.Close()
                MessageBox.Show("The connection to Flight Sim has been lost.", AppTitle, MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            Else
                ' not the disonnect error so some other baddness occured.
                ' just rethrow to halt the application
                Throw exFSUIPC
            End If

        Catch ex As Exception
            ' Sometime when the connection is lost, bad data gets returned 
            ' and causes problems with some of the other lines.  
            ' This catch block just makes sure the user doesn't see any
            ' other Exceptions apart from FSUIPCExceptions.
        End Try
    End Sub

    ' Demonstrates the Grouping facility and also returning a string.
    ' The AircraftType Offset is in a Group called "AircraftInfo".
    ' With the Group system you can gain control over which 
    ' Offsets are processed.
    Private Sub btnGetAircraftType_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnGetAircraftType.Click
        ' Aircraft type is in the "AircraftInfo" data group so we only want to proccess that here.
        Try
            FSUIPCConnection.Process("AircraftInfo")
            ' OK so display the string
            ' With strings the DLL automatically handles the 
            ' ASCII/Unicode conversion and deals with the 
            ' zero terminators.
            Me.txtAircraftType.Text = aircraftType.Value
        Catch ex As Exception
            MessageBox.Show(ex.Message, AppTitle, MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' Next few eventhandlers deal with writing the lights.
    ' Again we use the BitArray to manage the individual bits.
    ' I've used the LightType enum again for the bit numbers, although
    ' that's not to everyone's taste.  Some alternative lines using literal index 
    ' numbers are included as comments for the first two.
    Private Sub chkNavigation_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkNavigation.CheckedChanged
        Me.lights.Value(LightType.Navigation) = Me.chkNavigation.Checked
        'Me.lights.Value(0) = Me.chkNavigation.Checked
    End Sub

    Private Sub chkBeacon_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkBeacon.CheckedChanged
        Me.lights.Value(LightType.Beacon) = Me.chkBeacon.Checked
        'Me.lights.Value(1) = Me.chkBeacon.Checked
    End Sub

    Private Sub chkLanding_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkLanding.CheckedChanged
        Me.lights.Value(LightType.Landing) = Me.chkLanding.Checked
    End Sub

    Private Sub chkTaxi_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkTaxi.CheckedChanged
        Me.lights.Value(LightType.Taxi) = Me.chkTaxi.Checked
    End Sub

    Private Sub chkStrobes_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkStrobes.CheckedChanged
        Me.lights.Value(LightType.Strobes) = Me.chkStrobes.Checked
    End Sub

    Private Sub chkInstuments_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkInstuments.CheckedChanged
        Me.lights.Value(LightType.Instruments) = Me.chkInstuments.Checked
    End Sub

    Private Sub chkRecognition_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkRecognition.CheckedChanged
        Me.lights.Value(LightType.Recognition) = Me.chkRecognition.Checked
    End Sub

    Private Sub chkWing_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkWing.CheckedChanged
        Me.lights.Value(LightType.Wing) = Me.chkWing.Checked
    End Sub

    Private Sub chkLogo_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkLogo.CheckedChanged
        Me.lights.Value(LightType.Logo) = Me.chkLogo.Checked
    End Sub

    Private Sub chkCabin_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkCabin.CheckedChanged
        Me.lights.Value(LightType.Cabin) = Me.chkCabin.Checked
    End Sub

    ' Demonstrates a simple 'write' to an Offset.
    ' To send a value to FSUIPC, just change the Value property.
    ' The new data will be written during the next Process().
    Private Sub chkAvionics_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkAvionics.CheckedChanged
        Me.avionics.Value = IIf(chkAvionics.Checked, 1, 0)
    End Sub

    ' This demonstrates disconnecting an individual Offset.
    ' After it's disconnected it doesn't get updated from FSUIPC
    ' and changed to the value of this Offset do not get written
    ' when Process() is called.
    Private Sub btnDisconnect_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDisconnect.Click
        ' Disconnect immediatley.
        Me.compass.Disconnect()
    End Sub

    ' Same as disconnect, except the disconnect happens after 
    ' the next Process.  So one more read/write is done and then
    ' the Offset is disconnected.
    Private Sub btnDisconnectAfterNext_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDisconnectAfterNext.Click
        ' Diconnect after the next process.
        Me.compass.Disconnect(True)
    End Sub

    ' This demonstrates reconnecting an Offset.  It's value 
    ' will be read/written during the subsequent Process()
    ' calls.
    Private Sub btnReconnect_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnReconnect.Click
        ' Reconnect
        Me.compass.Reconnect()
    End Sub


    ' Same as reconnect except the the Offset will be disconnected
    ' again after the next Process() call.
    Private Sub btnReconnectOnce_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnReconnectOnce.Click
        ' Reconnect, but only for one Process().  
        ' The Offset is then disconnected again.
        Me.compass.Reconnect(True)
    End Sub

    ' The pause Offset is Write only.  It's value is never updated from 
    ' FSUIPC.  When it's value changes the new value is written
    ' to FSUIPC during the next Process().
    Private Sub chkPause_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkPause.CheckedChanged
        pause.Value = IIf(Me.chkPause.Checked, 1, 0)

    End Sub

    Private Enum LightType
        Navigation
        Beacon
        Landing
        Taxi
        Strobes
        Instruments
        Recognition
        Wing
        Logo
        Cabin
    End Enum

    Private Sub chkEnableAIRadar_CheckedChanged(ByVal sender As Object, ByVal e As EventArgs) Handles chkEnableAIRadar.CheckedChanged
        ' Turn on/off the radar timer to update the radar info  (runs every second)
        Me.AIRadarTimer.Enabled = Me.chkEnableAIRadar.Checked
        Me.pnlAIRadar.Invalidate()
    End Sub


    Private Sub AIRadarTimer_Tick(ByVal sender As Object, ByVal e As EventArgs) Handles AIRadarTimer.Tick
        ' Every second we update the Ground and Airborne AI trafic info
        AI.RefreshAITrafficInformation(Me.chkShowGroundAI.Checked, Me.chkShowAirborneAI.Checked)
        ' Apply a filter according to the range set by the user
        ' Filtering ground and airborne traffic, no bearing filter (include from 0-360)
        ' No altitude filter (passing 'Nothing's)
        ' Range as set by the combo box.
        AI.ApplyFilter(True, True, 0, 360, Nothing, Nothing, Double.Parse(Me.cbxRadarRange.Text))
        ' Invalidate the radar panel so it redraws.
        Me.pnlAIRadar.Invalidate()
    End Sub

    Private Sub pnlAIRadar_Paint(ByVal sender As Object, ByVal e As PaintEventArgs) Handles pnlAIRadar.Paint
        ' This gets called whenever the panel needs to draw itself.
        If (Me.chkEnableAIRadar.Checked) Then
            ' First Clear the panel and make a black background
            e.Graphics.Clear(Color.Black)
            ' Start by working out the centre of the radar and draw the centre cross
            Dim centre As Point = New Point(Me.pnlAIRadar.ClientSize.Width / 2, Me.pnlAIRadar.ClientSize.Height / 2)
            e.Graphics.DrawLine(Pens.White, centre.X - 4, centre.Y, centre.X + 4, centre.Y)
            e.Graphics.DrawLine(Pens.White, centre.X, centre.Y - 4, centre.X, centre.Y + 4)
            Dim range As Double = Double.Parse(Me.cbxRadarRange.Text)
            ' work out the scale using the range and the smallest size of the panel
            Dim scale As Double = range / IIf(Me.pnlAIRadar.ClientSize.Width < Me.pnlAIRadar.ClientSize.Height, Me.pnlAIRadar.ClientSize.Width, Me.pnlAIRadar.ClientSize.Height) * 2D
            ' Go through each plane and draw it on the radar
            ' Note: We are using the seperate collections for the ground and airborne
            ' There is a collection of all AI traffic called 'AllTraffic' which can be used if
            ' you do not want to deal with these seperatley.
            ' First, draw the ground AI if required
            If (Me.chkShowGroundAI.Checked) Then
                ' Loop through the collection of plane objects in the GroundTraffic collection.
                For Each plane As AIPlaneInfo In AI.GroundTraffic
                    ' Here we just pass the planeInfo off to the draw routine.
                    ' There is quite a lot of information available in the AIPlaneInfo object.
                    ' See the reference manual or Intellisense for details.
                    drawTarget(e.Graphics, scale, centre, plane)
                Next plane
            End If
            ' Next, draw the Airborne AI if required
            If (Me.chkShowAirborneAI.Checked) Then
                ' Loop through the collection of plane objects in the GroundTraffic collection.
                For Each plane As AIPlaneInfo In AI.AirbourneTraffic
                    drawTarget(e.Graphics, scale, centre, plane)
                Next plane
            End If
        Else
            ' Radar turned off so just clear it with white
            e.Graphics.Clear(Color.White)
        End If
    End Sub

    Private Sub drawTarget(ByVal graphics As Graphics, ByVal scale As Double, ByVal centre As Point, ByVal plane As AIPlaneInfo)
        ' We are going to use some of the info from the plane object to draw the target.
        ' Lots more info is avilable for other application.  
        ' See the reference manual or Intellisense for details.
        ' Work out the range of the target in pixels by multiplying by the scale
        Dim distancePixels As Double = plane.DistanceNM / scale
        ' Work out the position from the centre using this distance and the bearing
        Dim dy As Double = Math.Cos(degreeToRadian(plane.BearingTo)) * distancePixels * -1
        Dim dx As Double = Math.Sin(degreeToRadian(plane.BearingTo)) * distancePixels
        Dim target As PointF = New PointF(centre.X + dx, centre.Y + dy)
        ' Draw the target circle around this point oriented to the plane's heading 
        graphics.DrawEllipse(Pens.LightGreen, target.X - 4.0F, target.Y - 4.0F, 8.0F, 8.0F)
        ' Draw a line from the circle to indicate heading
        Dim tailHeading As Double = 180D + plane.HeadingDegrees
        dy = Math.Cos(degreeToRadian(tailHeading)) * -12
        dx = Math.Sin(degreeToRadian(tailHeading)) * 12
        Dim tailEnd As PointF = New PointF(target.X + dx, target.Y + dy)
        graphics.DrawLine(New Pen(New LinearGradientBrush(target, tailEnd, Color.LightGreen, Color.DarkGreen)), target, tailEnd)
        ' Work out the position of the data block
        Dim dataBlock As PointF = New PointF(target.X + 20, target.Y - 20)
        ' Draw the line to the datablock
        graphics.DrawLine(Pens.LightGreen, New PointF(target.X + 5, target.Y - 5), New PointF(dataBlock.X - 5, dataBlock.Y + 7))
        ' Draw the data block
        ' Line 1 - the Callsign
        graphics.DrawString(plane.ATCIdentifier, Me.pnlAIRadar.Font, Brushes.LightGreen, dataBlock)
        ' Line 2 - the Altitude (hundreds of feet) and speed
        Dim altScaled As Integer = plane.AltitudeFeet / 100D
        Dim line2 As String = altScaled.ToString("d3")
        ' Put a +,- or = depending on if the plane is decending, climbing or level
        If (plane.VirticalSpeedFeet < 0) Then
            line2 = line2 & "-"
        ElseIf (plane.VirticalSpeedFeet > 0) Then
            line2 = line2 & "+"
        Else
            line2 = line2 & "="
        End If
        graphics.DrawString(line2, Me.pnlAIRadar.Font, Brushes.LightGreen, New PointF(dataBlock.X, dataBlock.Y + 12))
        ' Line 3 - destination and assigned runway
        graphics.DrawString(plane.DepartureICAO & "->" & plane.DestinationICAO + " " + plane.RunwayAssigned.ToString(), Me.pnlAIRadar.Font, Brushes.LightGreen, New PointF(dataBlock.X, dataBlock.Y + 24))
    End Sub

    Private Function degreeToRadian(ByVal angle As Double) As Double
        Return Math.PI * angle / 180.0
    End Function

    Private Sub btnMoveToEGLL_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnMoveToEGLL.Click
        ' Suspend the timers
        If (Me.Timer1.Enabled) Then
            Me.Timer1.Enabled = False
            If (Me.chkEnableAIRadar.Checked) Then
                Me.AIRadarTimer.Enabled = False
            End If
            ' Put the sim into Slew mode
            slewMode.Value = 1
            FSUIPCConnection.Process()
            ' Make a new point representing the centre of the threshold for 27L
            Dim lat As FsLatitude = New FsLatitude(51.464943D)
            Dim lon As FsLongitude = New FsLongitude(-0.434046D)
            Dim newPos As FsLatLonPoint = New FsLatLonPoint(lat, lon)
            ' Now move this point 150 metres up the runway
            ' Use one of the OffsetBy methods of the FsLatLonPoint class  
            Dim rwyTrueHeading As Double = 269.7D
            newPos = newPos.OffsetByMetres(rwyTrueHeading, 150)
            ' Set the new position
            playerLatitude.Value = newPos.Latitude.ToFSUnits8()
            playerLongitude.Value = newPos.Longitude.ToFSUnits8()
            ' set the heading and altitude
            playerAltitude.Value = 0
            playerHeadingTrue.Value = rwyTrueHeading * (65536D * 65536D) / 360D
            FSUIPCConnection.Process()
            ' Turn off the slew mode
            slewMode.Value = 0
            FSUIPCConnection.Process()
            ' Refresh the scenery
            sendControl.Value = REFRESH_SCENERY
            FSUIPCConnection.Process()
            ' Reenable the timers
            Me.Timer1.Enabled = True
            Me.AIRadarTimer.Enabled = Me.chkEnableAIRadar.Checked
        End If
    End Sub

    Private Sub CheckPlayerIsOnRunway()
        Dim lon As FsLongitude = New FsLongitude(playerLongitude.Value)
        Dim lat As FsLatitude = New FsLatitude(playerLatitude.Value)
        ' Get the point for the current plane position
        Dim currentPosition As FsLatLonPoint = New FsLatLonPoint(lat, lon)

        ' Now define the Quadrangle for the 27L (09R) runway.
        ' We could just define the four corner Lat/Lon points if we knew them.
        ' In this example however we're using the helper function to calculate the points
        ' from the runway information.  This is the kind of info you can find in the output files
        ' from Pete Dowson's MakeRunways program.
        Dim rwyThresholdLat As FsLatitude = New FsLatitude(51.464943D)
        Dim rwyThresholdLon As FsLongitude = New FsLongitude(-0.434046D)
        Dim rwyMagHeading As Double = 272.7D
        Dim rwyMagVariation As Double = -3D
        Dim rwyLength As Double = 11978D
        Dim rwyWidth As Double = 164D

        ' Call the static helper on the FsLatLonQuarangle class to generate the Quadrangle for this runway...
        Dim thresholdCentre As FsLatLonPoint = New FsLatLonPoint(rwyThresholdLat, rwyThresholdLon)
        Dim trueHeading As Double = rwyMagHeading + rwyMagVariation
        runwayQuad = FsLatLonQuadrilateral.ForRunway(thresholdCentre, trueHeading, rwyWidth, rwyLength)

        ' Now check if the player is on the runway:
        ' Test is the plane is on the ground and if the current position is in the bounds of
        ' the runway Quadrangle we calculated in the constructor above.
        If onGround.Value = 1 And runwayQuad.ContainsPoint(currentPosition) Then
            ' Player is on the runway
            ' Do Stuff
        End If
    End Sub
End Class

' A double buffered panel used for the radar scope.
' The normal panel that .NET supplies doesn't use double buffering 
' and therefore suffers from massive flickering issues.
Public Class DoubleBufferPanel
    Inherits Panel

    Public Sub New()
        ' Set the value of the double-buffering style bits to true.
        Me.SetStyle(ControlStyles.DoubleBuffer Or ControlStyles.UserPaint Or ControlStyles.AllPaintingInWmPaint, True)
        Me.UpdateStyles()
    End Sub

End Class